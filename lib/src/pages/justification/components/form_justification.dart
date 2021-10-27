import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/assistance/marking.dart';
import 'package:upn_financiero_mobil/src/models/models.dart'
    show
        ApiResponse,
        DescriptionMarkingModel,
        JustificationModel,
        MarkingWorkerModel,
        PaginationModel,
        ProcessJustifcationModel,
        ScheduleWorkerModel;
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/widgets.dart'
    show AppScreen, CheckboxApp, ShowLoadingIndicator;
import 'package:upn_financiero_mobil/src/services/services.dart'
    show JustificationService, MarkingService;
import 'package:intl/intl.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/toast.dart'
    show ToastCustom;
import 'package:upn_financiero_mobil/src/shared/components/visor_pdf_img.dart';

import 'select_descriptions_marking.dart';

class FormJustification extends StatefulWidget {
  final JustificationModel arguments;

  FormJustification({Key? key, required this.arguments}) : super(key: key);

  @override
  State<FormJustification> createState() => _FormJustificationState();
}

class _FormJustificationState extends State<FormJustification> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> listReasons = [];
  List<ScheduleWorkerModel> listSchedule = [];
  List<MarkingWorkerModel> listMarkings = [];
  List<MarkingModel> listAssistance = [];
  List<MarkingWorkerModel> listMarkingsSelected = [];
  List<DescriptionMarkingModel> listDescripMarkings = [];
  List<DescriptionMarkingModel> listDescriptionsMarking = [];
  List<ProcessJustifcationModel> listProcessJustif = [];
  List<Color> listColorsMarkingSelected = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _inputFieldReasonCtrl = new TextEditingController();

  JustificationModel _formData = new JustificationModel();
  JustificationService justificationService = JustificationService();
  String _evidence = '';
  String _evidenceText = 'Adjuntar evidencia';
  bool loading = false;
  bool loadMarking = false;
  bool loadDescripMarking = false;
  bool loadingDescriptionsMarking = false;
  String idDescripMarcacion = '';
  bool deleteEvidence = false;
  bool validForm = false;
  ScheduleWorkerModel? scheduleData;
  @override
  void initState() {
    super.initState();
    _formData = widget.arguments;
    if (_formData.idSolicJustif != null) {
      _inputFieldReasonCtrl.text = _formData.idMotivoJustif.toString();
      if (_formData.evidenciaAdj != null) {
        _evidenceText = 'Adjuntar evidencia';
      }
      _getMarkings();
    } else {
      _formData.idEstadoJustif = '01';
    }
    _getDatheader();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _inputFieldReasonCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
        scrollController: _scrollController,
        enablePullDown: false,
        enablePullUp: false,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(alignment: Alignment.center, children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 8.0),
                      AppBar(
                        centerTitle: true,
                        leading: Transform.translate(
                          offset: Offset(-15, -8),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            iconSize: 40,
                            icon: Icon(Icons.chevron_left,
                                color: ColorsApp.primary),
                          ),
                        ),
                        elevation: 0,
                        backgroundColor: Colors.white,
                        toolbarHeight: 40.0,
                        title: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            _formData.idEstadoJustif == '01'
                                ? _formData.idSolicJustif == null
                                    ? 'Nueva Justificación'
                                    : 'Actualizar Justificación'
                                : 'Detalle Justificación',
                            style: GoogleFonts.montserrat(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                                color: ColorsApp.primary),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      _createInputDate(context),
                      _createInputReason(),
                      _createInputDescription(),
                      _createInputEvidence(),
                    ],
                  ),
                  _formData.idEstadoJustif == '01' && _formData.fecha != null
                      ? _createButtonMarking()
                      : Container(),
                  Column(
                    children: [
                      loadMarking && listSchedule.length > 0
                          ? _createListMarkings(context)
                          : loadMarking && listSchedule.length == 0
                              ? Container(
                                  child: Center(
                                    child: Text(
                                        'No se ha configurado un horario para esta fecha'),
                                  ),
                                )
                              : Container(),
                    ],
                  ),
                  SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),
            if (loading) ...[
              Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  left: 0.0,
                  top: 0.0,
                  child: Container(
                      alignment: Alignment.center,
                      width: constraints.maxWidth,
                      child: Center(child: CircularProgressIndicator())))
            ]
          ]);
        }),
        bottomSheet: _formData.idSolicJustif != null &&
                _formData.idEstadoJustif == '01'
            ? Container(
                color: ColorsApp.primaryVariant,
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          _showModalAnular(context, '');
                        },
                        style: ButtonStyle(
                          alignment: Alignment.center,
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return ColorsApp
                                  .danger; // Use the component's default.
                            },
                          ),
                          shape: MaterialStateProperty.resolveWith<
                              RoundedRectangleBorder>(
                            (Set<MaterialState> states) {
                              return RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      25)); // Use the component's default.
                            },
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.save_alt_outlined,
                                  color: Colors.white),
                              Text(
                                'anular',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(width: 12.0),
                    TextButton(
                        onPressed: () {
                          _submit(context);
                        },
                        style: ButtonStyle(
                          alignment: Alignment.center,
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return ColorsApp
                                  .success; // Use the component's default.
                            },
                          ),
                          shape: MaterialStateProperty.resolveWith<
                              RoundedRectangleBorder>(
                            (Set<MaterialState> states) {
                              return RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      25)); // Use the component's default.
                            },
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Image.asset('assets/icons/save.png',
                                  height: 30, width: 30, color: Colors.white),
                              Text(
                                'actualizar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              )
            : _formData.idSolicJustif == null
                ? Container(
                    color: ColorsApp.primaryVariant,
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              _submit(context);
                            },
                            style: ButtonStyle(
                              alignment: Alignment.center,
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return ColorsApp
                                      .success; // Use the component's default.
                                },
                              ),
                              shape: MaterialStateProperty.resolveWith<
                                  RoundedRectangleBorder>(
                                (Set<MaterialState> states) {
                                  return RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          25)); // Use the component's default.
                                },
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Image.asset('assets/icons/save.png',
                                      height: 30,
                                      width: 30,
                                      color: Colors.white),
                                  Text(
                                    'enviar solicitud',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  )
                : null);
  }

  Widget _createListMarkings(BuildContext buildContext) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                primary: false,
                itemCount: listMarkingsSelected.length,
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 0,
                    color: ColorsApp.primary,
                    thickness: 0,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  MarkingWorkerModel item = listMarkingsSelected[index];
                  return TextButton(
                    onPressed: item.esJustificado
                        ? null
                        : () {
                            if (listMarkingsSelected[index]
                                    .idDescripMarcacion !=
                                null) {
                              listMarkingsSelected[index].fechahoraManual =
                                  _getDateMarking(
                                      item.idDescripMarcacion.toString());
                              setState(() {
                                listMarkingsSelected[index].esSolicitado =
                                    !item.esSolicitado;
                              });
                            } else {
                              ToastCustom().warningContext(
                                context: buildContext,
                                  message:
                                      'No se ha definido el tipo marcación',
                                  time: 8);
                            }
                          },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: CheckboxApp(
                              onChanged: item.esJustificado
                                  ? null
                                  : (val) {
                                      if (listMarkingsSelected[index]
                                              .idDescripMarcacion !=
                                          null) {
                                        listMarkingsSelected[index]
                                                .fechahoraManual =
                                            _getDateMarking(item
                                                .idDescripMarcacion
                                                .toString());

                                        setState(() {
                                          listMarkingsSelected[index]
                                              .esSolicitado = val;
                                        });
                                      } else {
                                        ToastCustom().warningContext(
                                          context: buildContext,
                                            message:
                                                'No se ha definido el tipo marcación',
                                            time: 8);
                                      }
                                    },
                              value: item.esSolicitado,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nombreDescripMarcacion.toString(),
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    color: listColorsMarkingSelected[index]),
                              ),
                              item.fechahora != null
                                  ? Text(
                                      DateFormat('hh:mm a')
                                              .format(DateTime.parse(
                                                  item.fechahora.toString()))
                                              .toLowerCase() +
                                          ' (Registrado)',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                          color: ColorsApp.primary))
                                  : Container(),
                              item.fechahoraManual != null
                                  ? Text(
                                      DateFormat('hh:mm a')
                                          .format(DateTime.parse(
                                              item.fechahoraManual.toString()))
                                          .toLowerCase(),
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                          color: ColorsApp.primary))
                                  : Container(),
                              item.esJustificado
                                  ? Text('Justificado')
                                  : Container(),
                            ],
                          ),
                        ]),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Color _getColorEnt(MarkingModel item) {
    Color color = ColorsApp.success;
    if (item.horaEntJust == '1') {
      color = ColorsApp.primary;
    } else if (item.horaEntradaReal == null) {
      color = ColorsApp.danger;
    } else if (double.parse(item.numMinutosTarEnt.toString()) > 0) {
      color = ColorsApp.warning;
    } else if (double.parse(item.numMinutosTarEnt.toString()) == 0) {
      color = ColorsApp.success;
    } else {
      color = ColorsApp.danger;
    }
    return color;
  }

  Color _getColorSalRef(MarkingModel item) {
    Color color = ColorsApp.success;
    if (item.horaSalRefJust == '1') {
      color = ColorsApp.primary;
    } else if (item.horaSalidaRefReal == null &&
        item.horaBaseSalRef != null &&
        item.horaBaseEntRef != null) {
      color = ColorsApp.danger;
    } else if (item.horaBaseSalRef == null && item.horaBaseEntRef == null) {
      color = ColorsApp.danger;
    } else if (double.parse(item.numMinutosTarSalRef.toString()) > 0) {
      color = ColorsApp.warning;
    } else if (double.parse(item.numMinutosTarSalRef.toString()) == 0) {
      color = ColorsApp.success;
    } else {
      color = ColorsApp.danger;
    }
    return color;
  }

  Color _getColorEntRef(MarkingModel item) {
    Color color = ColorsApp.success;
    if (item.horaEntRefJust == '1') {
      color = ColorsApp.primary;
    } else if (item.horaEntradaRefReal == null &&
        item.horaBaseSalRef != null &&
        item.horaBaseEntRef != null) {
      color = ColorsApp.danger;
    } else if (item.horaBaseSalRef == null && item.horaBaseEntRef == null) {
      color = ColorsApp.danger;
    } else if (double.parse(item.numMinutosTarRef.toString()) > 0) {
      color = ColorsApp.warning;
    } else if (double.parse(item.numMinutosTarRef.toString()) == 0) {
      color = ColorsApp.success;
    } else {
      color = ColorsApp.danger;
    }
    return color;
  }

  Color _getColorSal(MarkingModel item) {
    Color color = ColorsApp.success;
    if (item.horaSalJust == '1') {
      color = ColorsApp.primary;
    } else if (item.horaSalidaReal == null) {
      color = ColorsApp.danger;
    } else if (double.parse(item.numMinutosTarSal.toString()) > 0) {
      color = ColorsApp.warning;
    } else if (double.parse(item.numMinutosTarSal.toString()) == 0) {
      color = ColorsApp.success;
    } else {
      color = ColorsApp.danger;
    }
    return color;
  }

  Container _createButtonMarking() {
    return Container(
      child: TextButton(
          onPressed: () {
            _getMarkings();
          },
          style: ButtonStyle(
            alignment: Alignment.center,
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return ColorsApp.primary; // Use the component's default.
              },
            ),
            shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
              (Set<MaterialState> states) {
                return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25)); // Use the component's default.
              },
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Cargar Marcaciones'.toUpperCase(),
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.white)
            ],
          )),
    );
  }

  Container _createInputDescription() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled: _formData.idEstadoJustif != '01' ? false : true,
        initialValue: _formData.descripcion,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          labelStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: ColorsApp.primary),
          labelText: 'Descripción',
        ),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        maxLines: 4,
        keyboardType: TextInputType.multiline,
        onSaved: (val) => setState(() => _formData.descripcion = val ?? ''),
      ),
    );
  }

  Container _createInputReason() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: SelectFormField(
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelText: 'Motivo',
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            suffixIcon: Icon(Icons.arrow_drop_down, color: ColorsApp.primary)),
        type: SelectFormFieldType.dialog,
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600, color: ColorsApp.primary),
        controller: _inputFieldReasonCtrl,
        changeIcon: true,
        dialogTitle: 'Seleccionar',
        dialogCancelBtn: 'Cancelar',
        enableSearch: false,
        dialogSearchHint: 'Buscar',
        items: listReasons,
        enabled: _formData.idEstadoJustif != '01' ? false : true,
        onSaved: (val) => setState(() => _formData.idMotivoJustif = val ?? ''),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Container _createInputEvidence() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                    child: Text(_evidenceText.toLowerCase(),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            color: ColorsApp.primary))),
                Row(
                  children: [
                    _formData.idEstadoJustif == '01'
                        ? IconButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: [
                                    'jpg',
                                    'pdf',
                                    'png',
                                    'jpeg'
                                  ]);

                              if (result != null) {
                                PlatformFile file = result.files.first;
                                setState(() {
                                  _evidence = file.path.toString();
                                  _evidenceText = file.name;
                                });
                              } else {
                                return;
                              }
                            },
                            icon: Icon(Icons.file_upload_outlined),
                          )
                        : Container(),
                    _formData.idEstadoJustif == '01'
                        ? IconButton(
                            onPressed: () async {
                              final picker = new ImagePicker();
                              final XFile? pickedFile = await picker.pickImage(
                                  source: ImageSource.camera,
                                  imageQuality: 100);
                              if (pickedFile == null) {
                                return;
                              } else {
                                setState(() {
                                  _evidence = pickedFile.path.toString();
                                  _evidenceText = pickedFile.name;
                                });
                              }
                            },
                            icon: Icon(Icons.photo_camera),
                          )
                        : Container(),
                    _formData.evidenciaAdj != null
                        ? IconButton(
                            onPressed: () async {
                              if (_evidence.isEmpty &&
                                  _formData.evidenciaAdj != null) {
                                setState(() {
                                  loading = true;
                                });
                                Map<String, String> params = {
                                  'archivo': _formData.evidenciaAdj.toString()
                                };
                                ApiResponse resp = await justificationService
                                    .geFileRequest(params);
                                if (resp.success) {
                                  final dir = await getTemporaryDirectory();
                                  File file = new File(dir.path +
                                      _formData.evidenciaAdj.toString());
                                  Uint8List bytes = base64.decode(resp.data);
                                  await file.writeAsBytes(bytes);
                                  setState(() {
                                    loading = false;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VisorPdfImgPage(
                                              title: 'Evidencia',
                                              filePath: file.path)));
                                }
                              } else if (_evidence.isNotEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VisorPdfImgPage(
                                            title: 'Evidencia',
                                            filePath: _evidence)));
                              }
                            },
                            icon: Icon(Icons.remove_red_eye),
                          )
                        : Container(),
                    _evidence.isNotEmpty
                        ? IconButton(
                            onPressed: () async {
                              setState(() {
                                deleteEvidence = true;
                                _evidence = '';
                                _evidenceText = 'Adjuntar evidencia';
                              });
                            },
                            icon: Icon(Icons.delete),
                          )
                        : Container()
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _createInputDate(BuildContext context) {
    final format = DateFormat("dd/MM/yyyy");
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: DateTimeField(
        enabled: _formData.idEstadoJustif != '01' ? false : true,
        initialValue: _formData.fecha != null
            ? DateTime.parse(_formData.fecha.toString())
            : null,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Fecha'),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(DateTime.now().year, DateTime.now().month),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime.now());
          if (date != null) {
            return date;
          } else {
            return currentValue;
          }
        },
        validator: (value) {
          if (value == null) {
            return 'Campo requerido.';
          }
          return null;
        },
        onChanged: (val) {
          listMarkings = [];
          loadMarking = false;
          _formData.fecha = val != null
              ? DateFormat('y-MM-dd HH:mm:ss')
                  .format(DateTime.parse(val.toString()))
              : null;
          setState(() {});
        },
      ),
    );
  }

  void _showModalAnular(BuildContext context, String id) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          TextEditingController _inputFieldCtrl = new TextEditingController();
          return AlertDialog(
            elevation: 0,
            backgroundColor: ColorsApp.info,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            titlePadding: EdgeInsets.zero,
            scrollable: true,
            content: TextFormField(
              controller: _inputFieldCtrl,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                labelText: 'Descripción (opcional)',
              ),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),
            actions: [
              TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return ColorsApp
                            .primary; // Use the component's default.
                      },
                    ),
                    shape: MaterialStateProperty.resolveWith<
                        RoundedRectangleBorder>(
                      (Set<MaterialState> states) {
                        return RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25)); // Use the component's default.
                      },
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child:
                        Text('Cerrar', style: TextStyle(color: Colors.white)),
                  ),
                  onPressed: () => Navigator.of(context).pop()),
              TextButton(
                style: ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return ColorsApp.danger; // Use the component's default.
                    },
                  ),
                  shape:
                      MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                    (Set<MaterialState> states) {
                      return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              25)); // Use the component's default.
                    },
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Anular'),
                ),
                onPressed: () {
                  changeRequestStatus(
                      _inputFieldCtrl.value.text.isNotEmpty
                          ? _inputFieldCtrl.value.text
                          : '',
                      context);
                },
              )
            ],
          );
        });
  }

  void changeRequestStatus(String text, BuildContext context) async {
    setState(() {
      loading = true;
    });
    UserPreferences userPreferences = UserPreferences();
    Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker.toString(),
      'id_solic_justif': _formData.idSolicJustif.toString(),
      'id_estado_justif': '00',
      'comentario': text
    };
    ApiResponse create = await justificationService.changeRequestStatus(params);
    setState(() {
      loading = false;
    });
    if (create.success) {
      Navigator.pop(context);
      Navigator.of(context).pop({'change': true, 'data': null});
    }
  }

  void _submit(BuildContext buildContext) async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    final markingsSelected =
        listMarkingsSelected.where((el) => el.esSolicitado == true);
    if (markingsSelected.length > 0) {
      ShowLoadingIndicator.showLoadingIndicator(
          text: 'Guardando ...', context: buildContext);
      if (_formData.idSolicJustif == null) {
        final Map<String, String> params = {
          'id_motivo_justif': _formData.idMotivoJustif.toString(),
          'fecha': _formData.fecha.toString(),
          'descripcion': _formData.descripcion.toString(),
          'evidencia_adj': _formData.evidenciaAdj.toString(),
          'archivo': _evidence,
          'id_estado_justif': _formData.idEstadoJustif.toString(),
          'marcaciones': json.encode(markingsSelected.toList()).toString()
        };
        ApiResponse create =
            await justificationService.createJustification(params);
        Navigator.pop(buildContext);
        if (create.success) {
          Navigator.of(buildContext).pop({'change': true, 'data': null});
        }
      } else {
        final Map<String, String> params = {
          'id_entidad': _formData.idEntidad.toString(),
          'id_depto': _formData.idDepto.toString(),
          'id_trabajador': _formData.idTrabajador.toString(),
          'id_motivo_justif': _formData.idMotivoJustif.toString(),
          'fecha': _formData.fecha.toString(),
          'descripcion': _formData.descripcion.toString(),
          'evidencia_adj': _formData.evidenciaAdj.toString(),
          'archivo': _evidence,
          'id_estado_justif': _formData.idEstadoJustif.toString(),
          'marcaciones': json.encode(markingsSelected.toList()).toString(),
          'eliminar_evidencia': deleteEvidence.toString()
        };
        ApiResponse update = await justificationService.updateJustification(
            params, _formData.idSolicJustif.toString());
        Navigator.pop(buildContext);
        if (update.success) {
          Navigator.of(buildContext).pop({'change': true, 'data': null});
        }
      }
    } else {
      ToastCustom().warningContext(
        context: buildContext,
          message: 'Debe seleccionar por lo menos una marcación', time: 8);
    }
  }

  void _getDatheader() async {
    setState(() {
      loading = true;
    });

    final list = await justificationService.getReasonsJustification();
    list.forEach((element) {
      listReasons.add({
        'value': element.idMotivoJustif,
        'label': element.nombre,
        'icon': null,
      });
    });
    setState(() {
      loading = false;
    });
  }

  void _getMarkings() async {
    Map<String, String> params = {
      'fecha': DateFormat('y-MM-dd')
          .format(DateTime.parse(_formData.fecha.toString())),
    };
    setState(() {
      loading = true;
    });
    listSchedule = await justificationService.getScheduleWorker(params);
    if (listSchedule.length > 0) {
      scheduleData = listSchedule[0];
      Map<String, String> params = {
        'fechahora_entrada': listSchedule[0].fechahoraEntrada.toString(),
        'fechahora_salida': listSchedule[0].fechahoraSalida.toString(),
        'id_solic_justif': _formData.idSolicJustif != null
            ? _formData.idSolicJustif.toString()
            : '',
        'fecha': DateFormat('y-MM-dd')
            .format(DateTime.parse(_formData.fecha.toString()))
      };
      setState(() {
        loading = true;
      });
      listMarkings = await justificationService.getMarkingWorker(params);
      UserPreferences _userPreferences = UserPreferences();
      params = {
        'id_entidad': _userPreferences.idEntity != null
            ? _userPreferences.idEntity.toString()
            : '',
        'id_depto': _userPreferences.idDeparment != null
            ? _userPreferences.idDeparment.toString()
            : '',
        'id_trabajador': _userPreferences.idWorker != null
            ? _userPreferences.idWorker.toString()
            : '',
        'id_motivo_asist': 'A',
        'per_page': '10',
        'page': '1'
      };
      params['fecha'] = DateFormat('y-MM-dd')
          .format(DateTime.parse(_formData.fecha.toString()));

      MarkingService _markingService = MarkingService();
      PaginationModel pagination = await _markingService.assistMarkings(params);
      List<dynamic> jsonList =
          pagination.data == null ? [] : pagination.data as List<dynamic>;

      List<MarkingModel> list = jsonList
          .map((jsonElement) => MarkingModel.fromJson(jsonElement))
          .toList();
      listAssistance = list;
    } else {
      listMarkings = [];
    }
    listMarkingsSelected = [];
    listColorsMarkingSelected = [];
    MarkingWorkerModel _horaEntrada = new MarkingWorkerModel();
    MarkingWorkerModel _horaSalidaRef = new MarkingWorkerModel();
    MarkingWorkerModel _horaEntradaRef = new MarkingWorkerModel();
    MarkingWorkerModel _horaSalida = new MarkingWorkerModel();
    final schedule = listSchedule.isNotEmpty ? listSchedule[0] : null;
    final assistance =
        listAssistance.isNotEmpty ? listAssistance[0] : new MarkingModel();
    MarkingWorkerModel findEntrada = listMarkings.firstWhere(
        (val) => val.idMarcacion != null && val.idDescripMarcacion == '01',
        orElse: () => new MarkingWorkerModel());
    MarkingWorkerModel findSalidaRef = listMarkings.firstWhere(
        (val) => val.idMarcacion != null && val.idDescripMarcacion == '02',
        orElse: () => new MarkingWorkerModel());
    MarkingWorkerModel findEntradaRef = listMarkings.firstWhere(
        (val) => val.idMarcacion != null && val.idDescripMarcacion == '03',
        orElse: () => new MarkingWorkerModel());
    MarkingWorkerModel findSalida = listMarkings.firstWhere(
        (val) => val.idMarcacion != null && val.idDescripMarcacion == '04',
        orElse: () => new MarkingWorkerModel());
    final colorEnt = _getColorEnt(assistance);
    final colorSalRef = _getColorSalRef(assistance);
    final colorEntRef = _getColorEntRef(assistance);
    final colorSal = _getColorSal(assistance);
    if (findEntrada.idDescripMarcacion == null) {
      if (schedule != null) {
        _horaEntrada = new MarkingWorkerModel(
            fechahoraManual: schedule.fechahoraEntrada,
            idDescripMarcacion: '01',
            esSolicitado: false,
            eliminar: true,
            esJustificado: false,
            nombreDescripMarcacion: 'Hora entrada');
        listColorsMarkingSelected.add(colorEnt);
        listMarkingsSelected.add(_horaEntrada);
      }
    } else {
      listColorsMarkingSelected.add(colorEnt);
      listMarkingsSelected.add(findEntrada);
    }
    if (findSalidaRef.idDescripMarcacion == null) {
      if (schedule != null) {
        if (schedule.fechahoraSalidaRef != null) {
          _horaSalidaRef = new MarkingWorkerModel(
              fechahoraManual: schedule.fechahoraSalidaRef,
              idDescripMarcacion: '02',
              esSolicitado: false,
              eliminar: true,
              esJustificado: false,
              nombreDescripMarcacion: 'Hora salida ref');

          listColorsMarkingSelected.add(colorSalRef);
          listMarkingsSelected.add(_horaSalidaRef);
        }
      }
    } else {
      listColorsMarkingSelected.add(colorSalRef);
      listMarkingsSelected.add(findSalidaRef);
    }
    if (findEntradaRef.idDescripMarcacion == null) {
      if (schedule != null) {
        if (schedule.fechahoraEntradaRef != null) {
          _horaEntradaRef = new MarkingWorkerModel(
              fechahoraManual: schedule.fechahoraEntradaRef,
              idDescripMarcacion: '03',
              esSolicitado: false,
              eliminar: true,
              esJustificado: false,
              nombreDescripMarcacion: 'Hora entrada ref');
          listColorsMarkingSelected.add(colorEntRef);
          listMarkingsSelected.add(_horaEntradaRef);
        }
      }
    } else {
      listColorsMarkingSelected.add(colorEntRef);
      listMarkingsSelected.add(findEntradaRef);
    }
    if (findSalida.idDescripMarcacion == null) {
      if (schedule != null) {
        _horaSalida = new MarkingWorkerModel(
            fechahoraManual: schedule.fechahoraSalida,
            idDescripMarcacion: '04',
            esSolicitado: false,
            eliminar: true,
            esJustificado: false,
            nombreDescripMarcacion: 'Hora salida');

        listColorsMarkingSelected.add(colorSal);
        listMarkingsSelected.add(_horaSalida);
      }
    } else {
      listColorsMarkingSelected.add(colorSal);
      listMarkingsSelected.add(findSalida);
    }
    Future.delayed(Duration.zero, () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    });
    setState(() {
      loading = false;
      loadMarking = true;
    });
  }

  void goToFormDescripMarking(
      MarkingWorkerModel? item, int? index, bool isNew) async {
    if (!loadDescripMarking) {
      setState(() {
        loading = true;
      });
      listDescripMarkings = await justificationService.getDescriptionsMarking();
      setState(() {
        loading = false;
        loadDescripMarking = true;
      });
    }
    selectDescriptionMarking(
            context,
            listDescripMarkings,
            item != null ? item.idDescripMarcacion.toString() : '',
            scheduleData!)
        .then((value) {
      final Map<String, dynamic> data = value;
      if (data['change'] == 'true' || data['change'] == true) {
        DescriptionMarkingModel selectData =
            data['data'] as DescriptionMarkingModel;
        final countMarkings = listMarkings.where(
            (val) => val.idDescripMarcacion == selectData.idDescripMarcacion);
        if (countMarkings.length == 0 && isNew) {
          MarkingWorkerModel newMarking = new MarkingWorkerModel();
          newMarking.esJustificado = false;
          newMarking.eliminar = true;
          newMarking.esSolicitado = true;
          newMarking.fechahoraManual =
              _getDateMarking(selectData.idDescripMarcacion.toString());
          newMarking.idDescripMarcacion = selectData.idDescripMarcacion;
          newMarking.nombreDescripMarcacion = selectData.nombre;
          listMarkings.add(newMarking);
        } else if (!isNew) {
          if (((countMarkings.length == 1 &&
                  item!.idDescripMarcacion == selectData.idDescripMarcacion) ||
              countMarkings.length == 0)) {
            listMarkings[index!].idDescripMarcacion =
                selectData.idDescripMarcacion;
            listMarkings[index].nombreDescripMarcacion = selectData.nombre;
            listMarkings[index].fechahoraManual =
                _getDateMarking(selectData.idDescripMarcacion.toString());
          } else {
            ToastCustom().warningContext(context:context,message: 'Ya existe', time: 8);
          }
        } else {
          ToastCustom().warningContext(context:context,message: 'Ya existe', time: 8);
        }
        Future.delayed(Duration.zero, () {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut);
        });
        setState(() {});
      }
    });
  }

  String _getDateMarking(String idDescripMarcacion) {
    String fechahora = '';
    if (scheduleData!.idTipoHorario != null) {
      switch (idDescripMarcacion) {
        case '01':
          fechahora = scheduleData!.fechahoraEntrada.toString();
          break;
        case '02':
          if (scheduleData!.fechahoraSalidaRef != null) {
            fechahora = scheduleData!.fechahoraSalidaRef.toString();
          }
          break;
        case '03':
          if (scheduleData!.fechahoraEntradaRef != null) {
            fechahora = scheduleData!.fechahoraEntradaRef.toString();
          }
          break;
        case '04':
          fechahora = scheduleData!.fechahoraSalida.toString();
          break;
        default:
      }
    }
    return fechahora;
  }
}
