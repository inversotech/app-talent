import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/models.dart'
    show
        ApiResponse,
        LicensePermitModel,
        StateLicensePermitModel,
        TypeConceptLicensePermitModel,
        TypeInstitutionModel,
        TypeLicensePermitModel,
        ValidLicensePermitModel;
import 'package:upn_financiero_mobil/src/pages/license_permit/components/pdf_img_input_upload.dart';
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/services/services.dart'
    show LicensePermitService;
import 'package:intl/intl.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/widgets.dart'
    show AppScreen, ShowLoadingIndicator, ToastCustom;

class FormLicensePermit extends StatefulWidget {
  final LicensePermitModel arguments;
  FormLicensePermit({Key? key, required this.arguments}) : super(key: key);

  @override
  State<FormLicensePermit> createState() => _FormLicensePermitState();
}

class _FormLicensePermitState extends State<FormLicensePermit> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LicensePermitModel _formData = new LicensePermitModel();
  LicensePermitService licensePermitService = LicensePermitService();
  TextEditingController _inputFieldTypeLicPerCtrl = new TextEditingController(),
      _inputFieldTypeConLicPerCtrl = new TextEditingController(),
      _inputFieldTypeInstitutionCtrl = new TextEditingController(),
      _inputFieldPeriodoCtrl = new TextEditingController(),
      _inputFieldDateFromCtrl = new TextEditingController(),
      _inputFieldDateToCtrl = new TextEditingController();
  UserPreferences userPreferences = UserPreferences();
  String adjunto = '',
      adjuntoText = '',
      adjuntoVoucher = '',
      adjuntoVoucherText = '',
      adjuntoCITT = '',
      adjuntoCITTText = '',
      adjuntoNITT = '',
      adjuntoNITTText = '',
      adjuntoVIVA = '',
      adjuntoVIVAText = '',
      fechaFinDesmed = '',
      fechaFinSubs = '',
      fechaIniSubs = '';
  bool loading = false,
      showPeriodo = true,
      showDateFrom = false,
      showDateTo = false,
      showTotalDays = false,
      showTotalHours = false,
      showHourFrom = false,
      showHourTo = false,
      requiredAdjunto = false,
      showArea = false,
      showInstitution = false,
      showCodeCITT = false,
      showCodeNitt = false,
      showAdjuntoCITT = false,
      validAdjunto = true,
      validAdjuntoCITT = true,
      validAdjuntoNITT = true,
      validAdjuntoVoucher = true;
  int maxDias = 0,
      minDias = 0,
      diasFijo = 0,
      maxDiasAnho = 0,
      diasAcumulados = 0,
      diasSumados = 0,
      diasSeleccionados = 0,
      diasDesmed = 0,
      diasSubs = 0;
  List<TypeLicensePermitModel> listTypeLicensePermit = [];
  List<TypeConceptLicensePermitModel> listTypeConceptLicensePermit = [];
  List<TypeInstitutionModel> listTypeInstitution = [];
  List<StateLicensePermitModel> listProcessLicensePermit = [];
  List<ValidLicensePermitModel> listValidLicensePermit = [];

  @override
  void initState() {
    super.initState();
    _formData = widget.arguments;
    if (_formData.idLicenciaPermiso != null) {
      _inputFieldTypeLicPerCtrl.text = _formData.idTipoPermLic.toString();
      /*  if (_formData.adjunto != null) {
        _evidenceText = 'Se adjuntó evidencia';
      } */

    } else {
      _formData.idEstadoLicaPer = '01';
    }
    _getDatheader();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _inputFieldTypeLicPerCtrl.dispose();
    _inputFieldTypeConLicPerCtrl.dispose();
    _inputFieldTypeInstitutionCtrl.dispose();
    _inputFieldPeriodoCtrl.dispose();
    _inputFieldDateToCtrl.dispose();
    _inputFieldDateFromCtrl.dispose();
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
                        icon:
                            Icon(Icons.chevron_left, color: ColorsApp.primary),
                      ),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.white,
                    toolbarHeight: 40.0,
                    title: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        _formData.idEstadoLicaPer == '01'
                            ? _formData.idLicenciaPermiso == null
                                ? 'Nueva Solicitud'
                                : 'Actualizar Solicitud'
                            : 'Detalle Solicitud',
                        style: GoogleFonts.montserrat(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            color: ColorsApp.primary),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      _createInputTypeLicPer(),
                      _createInputTypeConceptLicPer(),
                      _createInputPeriodo(),
                      _formData.periodo == 'D' || _formData.periodo == 'H'
                          ? _createInputDateFrom(context)
                          : Container(),
                      _formData.periodo == 'D'
                          ? _createInputDateTo(context)
                          : Container(),
                      _formData.periodo == 'H'
                          ? _createInputHourFrom(context)
                          : Container(),
                      _formData.periodo == 'H'
                          ? _createInputHourTo(context)
                          : Container(),
                      _createInputReason(),
                      _createInputAdjunto(),
                      showInstitution
                          ? _createInputTypeInstitution()
                          : Container(),
                      showInstitution
                          ? _createInputNameInstitution()
                          : Container(),
                      showCodeCITT ? _createInputCodeCITT() : Container(),
                      showCodeNitt && diasSumados > 20
                          ? _createInputCodeNITT()
                          : Container(),
                      showCodeCITT ? _createInputAdjuntoCITT() : Container(),
                      showCodeNitt && diasSumados > 20
                          ? _createInputAdjuntoNITT()
                          : Container(),
                      showCodeNitt && diasSumados > 20
                          ? _createInputCodeVIVA()
                          : Container(),
                      showCodeNitt && diasSumados > 20
                          ? _createInputAdjuntoVIVA()
                          : Container(),
                      showCodeNitt ? _createInputAdjuntoVoucher() : Container()
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
        bottomSheet: Container(
          color: ColorsApp.primaryVariant,
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: _formData.idLicenciaPermiso != null &&
                  _formData.idEstadoLicaPer == '01'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {},
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
                        ))
                  ],
                )
              : _formData.idLicenciaPermiso == null
                  ? Row(
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
                            ))
                      ],
                    )
                  : Container(),
        ));
  }

  Container _createInputTypeLicPer() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: SelectFormField(
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Tipo',
            suffixIcon: Icon(Icons.arrow_drop_down)),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600, color: ColorsApp.primary),
        type: SelectFormFieldType.dialog,
        controller: _inputFieldTypeLicPerCtrl,
        changeIcon: true,
        dialogTitle: 'Seleccionar',
        dialogCancelBtn: 'Cancelar',
        enableSearch: false,
        dialogSearchHint: 'Buscar',
        items: listTypeLicensePermit
            .map((element) => <String, dynamic>{
                  'value': element.idTipoPermLic,
                  'label': element.nombre,
                  'enable': element.codigo == 'PPOA' ? false : true,
                  'icon': null,
                })
            .toList(),
        enabled: _formData.idEstadoLicaPer != '01' ? false : true,
        onSaved: (val) => setState(() => _formData.idTipoPermLic = val ?? ''),
        onChanged: (val) {
          if (val.isNotEmpty) {
            _formData.idTipoPermLic = val;
            _inputFieldTypeConLicPerCtrl.clear();
            _inputFieldPeriodoCtrl.clear();
            _inputFieldTypeInstitutionCtrl.clear();
            _inputFieldDateToCtrl.clear();
            _inputFieldDateFromCtrl.clear();

            listTypeConceptLicensePermit = [];
            listTypeInstitution = [];

            _cleanConcept();

            _formData.idConceptoPermLic = null;

            adjunto = '';
            adjuntoText = '';

            _formData.idTipoInstAtencion = null;
            _formData.nombreInst = null;
            _formData.codigocitt = null;

            // _formData.tipo = null;

            _getTypeConLicePer(val);
            setState(() {});
          }
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  void _cleanConcept() {
    _formData.goce = null;
    _formData.engrupo = null;
    _formData.periodo = null;
    _formData.codigoConcepto = null;

    showPeriodo = false;

    _cleanFormCasos('DH');
    _cleanDays();
  }

  void _cleanDays() {
    diasAcumulados = 0;
    diasSumados = 0;
    diasSeleccionados = 0;
    maxDiasAnho = 0;
    fechaFinDesmed = '';
    fechaFinSubs = '';
    fechaIniSubs = '';
    diasDesmed = 0;
    diasSubs = 0;
  }

  void _cleanFormCasos(String periodo) {
    switch (periodo) {
      case 'D':
        showDateFrom = true;
        showDateTo = true;
        showTotalDays = true;
        showHourFrom = false;
        showHourTo = false;
        showTotalHours = false;
        _formData.fechaDesde = null;
        _formData.fechaHasta = null;
        _formData.dias = null;
        _formData.horaInicio = null;
        _formData.horaFin = null;
        _formData.horas = null;
        diasSeleccionados = 0;
        break;
      case 'H':
        showDateFrom = true;
        showDateTo = false;
        showTotalDays = false;
        showHourFrom = true;
        showHourTo = true;
        showTotalHours = true;
        _formData.fechaDesde = null;
        _formData.fechaHasta = null;
        _formData.dias = null;
        _formData.horaInicio = null;
        _formData.horaFin = null;
        _formData.horas = null;
        diasSeleccionados = 1;
        break;
      case 'DH':
        showDateFrom = false;
        showDateTo = false;
        showHourFrom = false;
        showHourTo = false;
        showTotalDays = false;
        showTotalHours = false;
        _formData.fechaDesde = null;
        _formData.fechaHasta = null;
        _formData.dias = null;
        _formData.horaInicio = null;
        _formData.horaFin = null;
        _formData.horas = null;
        diasSeleccionados = 0;
        break;
      default:
    }
  }

  void _cleanTypeInstitution() {
    _formData.idTipoInstAtencion = null;
    _formData.nombreInst = null;
    _formData.codigocitt = null;
    _formData.codigonit = null;
    _formData.codigoviva = null;
    adjuntoVoucher = '';
    adjuntoVoucherText = '';
    adjuntoCITT = '';
    adjuntoCITTText = '';
    adjuntoVIVA = '';
    adjuntoVIVAText = '';
  }

  Container _createInputTypeConceptLicPer() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: SelectFormField(
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Concepto',
            suffixIcon: Icon(Icons.arrow_drop_down)),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600, color: ColorsApp.primary),
        type: SelectFormFieldType.dialog,
        controller: _inputFieldTypeConLicPerCtrl,
        changeIcon: true,
        dialogTitle: 'Seleccionar',
        dialogCancelBtn: 'Cancelar',
        enableSearch: false,
        dialogSearchHint: 'Buscar',
        items: listTypeConceptLicensePermit
            .map((element) => <String, dynamic>{
                  'value': element.idConceptoPermLic,
                  'label': element.nombre,
                  'icon': null,
                })
            .toList(),
        enabled: _formData.idEstadoLicaPer != '01' ? false : true,
        onChanged: (val) {
          _formData.idConceptoPermLic = val;
          _inputFieldPeriodoCtrl.clear();
          _inputFieldTypeInstitutionCtrl.clear();
          _inputFieldDateToCtrl.clear();
          _inputFieldDateFromCtrl.clear();

          showPeriodo = false;
          final findConcept = listTypeConceptLicensePermit.firstWhere(
              (element) => element.idConceptoPermLic == val.toString());
          if (findConcept.idConceptoPermLic != null) {
            minDias = int.parse(findConcept.minDias.toString());
            maxDias = int.parse(findConcept.maxDias.toString());
            diasFijo = int.parse(findConcept.diasFijo.toString());
            _formData.engrupo = findConcept.engrupo.toString();
            _formData.codigoConcepto = findConcept.codigo.toString();
            _formData.goce = findConcept.tipoSuspension.toString();
            if (findConcept.periodo != 'DH') {
              _inputFieldPeriodoCtrl.text = findConcept.periodo.toString();
              _formData.periodo = findConcept.periodo.toString();
              _cleanFormCasos(findConcept.periodo.toString());
            } else {
              _formData.periodo = '';
              showPeriodo = true;
              _cleanFormCasos(findConcept.periodo.toString());
            }
            if (findConcept.adjuntos == 'S') {
              adjuntoText = '';
              adjunto = '';
              requiredAdjunto = true;
            } else {
              adjuntoText = '';
              adjunto = '';
              requiredAdjunto = false;
            }
            if (findConcept.codigo == 'DESC_MED') {
              showInstitution = true;
              _cleanTypeInstitution();
              _getTypeInstitution();
            } else {
              _cleanTypeInstitution();
              showInstitution = false;
            }

            showCodeCITT = false;
            showCodeNitt = false;
          }

          setState(() {});
        },
        onSaved: (val) =>
            setState(() => _formData.idConceptoPermLic = val ?? ''),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Container _createInputPeriodo() {
    List<Map<String, dynamic>> listPeriodo = [];
    listPeriodo.add({'value': 'D', 'label': 'Día', 'icon': null});
    listPeriodo.add({'value': 'H', 'label': 'Hora', 'icon': null});
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: SelectFormField(
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Periodo',
            suffixIcon: Icon(Icons.arrow_drop_down)),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600, color: ColorsApp.primary),
        type: SelectFormFieldType.dialog,
        controller: _inputFieldPeriodoCtrl,
        changeIcon: true,
        dialogTitle: 'Seleccionar',
        dialogCancelBtn: 'Cancelar',
        enableSearch: false,
        dialogSearchHint: 'Buscar',
        items: listPeriodo,
        enabled:
            _formData.idEstadoLicaPer != '01' || !showPeriodo ? false : true,
        onChanged: (val) {
          _formData.periodo = val;
          _formData.fechaDesde = null;
          _formData.fechaHasta = null;
          _formData.horaInicio = null;
          _formData.horaFin = null;
          _inputFieldDateToCtrl.clear();
          _inputFieldDateFromCtrl.clear();
          setState(() {});
        },
        onSaved: (val) => setState(() => _formData.periodo = val ?? ''),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Widget _createInputDateFrom(BuildContext context) {
    final format = DateFormat("dd/MM/yyyy");
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: DateTimeField(
        controller: _inputFieldDateFromCtrl,
        enabled: _formData.idEstadoLicaPer != '01' ? false : true,
        initialValue: _formData.fechaDesde != null
            ? DateTime.parse(_formData.fechaDesde.toString())
            : null,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: _formData.periodo == 'H' ? 'Fecha' : 'Desde'),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(DateTime.now().year + 1));
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
          _formData.fechaDesde = val != null
              ? DateFormat('y-MM-dd').format(DateTime.parse(val.toString()))
              : null;
          if (_formData.periodo == 'H' &&
              _formData.horaInicio != null &&
              _formData.horaFin != null &&
              _formData.fechaDesde != null) {
          } else if (_formData.periodo == 'D' && _formData.fechaDesde != null) {
            final fechaDesde =
                DateTime.parse(_formData.fechaDesde.toString() + ' 00:00:00');
            DateTime fechaHasta = fechaDesde;
            if (diasFijo > 0) {
              fechaHasta = fechaDesde.add(Duration(days: (diasFijo - 1)));
            }
            _inputFieldDateToCtrl.text =
                DateFormat('dd/MM/yyyy').format(fechaHasta);
            _formData.fechaHasta = DateFormat('y-MM-dd').format(fechaHasta);
            if (_formData.fechaHasta != null) {
              final date1 = DateTime.parse(_formData.fechaDesde.toString());
              final date2 = DateTime.parse(_formData.fechaHasta.toString());
              final difference = date2.difference(date1).inHours;
              if (difference >= 0) {
                _formData.dias = (difference + 1).toString();
              }
              if (_formData.engrupo == 'N' &&
                  _formData.codigoConcepto == 'DESC_MED') {
                _validLicensePermit();
              }
            }
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _createInputHourFrom(BuildContext context) {
    final format = DateFormat("HH:mm");
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: DateTimeField(
        enabled: _formData.idEstadoLicaPer != '01' ? false : true,
        initialValue: _formData.horaInicio != null
            ? DateTime.parse(DateFormat('y-MM-dd').format(DateTime.now()) +
                ' ' +
                _formData.horaInicio.toString())
            : null,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Hora inicio'),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        format: format,
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()));
          if (time != null) {
            return DateTimeField.convert(time);
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
          _formData.horaInicio = val != null
              ? DateFormat('HH:mm').format(DateTime.parse(val.toString()))
              : null;
          if (_formData.periodo == 'H' &&
              _formData.horaInicio != null &&
              _formData.horaFin != null &&
              _formData.fechaDesde != null) {
            final format = DateFormat("HH:mm");
            final hourFrom = format.parse(_formData.horaInicio.toString());
            final hourTo = format.parse(_formData.horaFin.toString());
            final differenceHour = hourTo.difference(hourFrom);
            _formData.horas = DateFormat('HH:mm:ss')
                .format(format.parse(differenceHour.toString()));
          }
          //_formData.horas =
          setState(() {});
        },
      ),
    );
  }

  Widget _createInputHourTo(BuildContext context) {
    final format = DateFormat("HH:mm");
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: DateTimeField(
        enabled: _formData.idEstadoLicaPer != '01' ? false : true,
        initialValue: _formData.horaFin != null
            ? DateTime.parse(DateFormat('y-MM-dd').format(DateTime.now()) +
                ' ' +
                _formData.horaFin.toString())
            : null,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Hora fin'),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        format: format,
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()));
          if (time != null) {
            return DateTimeField.convert(time);
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
          _formData.horaFin = val != null
              ? DateFormat('HH:mm').format(DateTime.parse(val.toString()))
              : null;
          if (_formData.periodo == 'H' &&
              _formData.horaInicio != null &&
              _formData.horaFin != null &&
              _formData.fechaDesde != null) {
            final format = DateFormat("HH:mm");
            final hourFrom = format.parse(_formData.horaInicio.toString());
            final hourTo = format.parse(_formData.horaFin.toString());
            final differenceHour = hourTo.difference(hourFrom);
            _formData.horas = DateFormat('HH:mm:ss')
                .format(format.parse(differenceHour.toString()));
          }
          //_formData.horas =
          setState(() {});
        },
      ),
    );
  }

  Widget _createInputDateTo(BuildContext context) {
    final format = DateFormat("dd/MM/yyyy");
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: DateTimeField(
        controller: _inputFieldDateToCtrl,
        enabled: _formData.idEstadoLicaPer != '01' ? false : true,
        initialValue: _formData.fechaHasta != null
            ? DateTime.parse(_formData.fechaHasta.toString())
            : null,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Hasta'),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        format: format,
        onShowPicker: (context, currentValue) async {
          DateTime firstdate =
              DateTime.parse(_formData.fechaDesde.toString() + ' 00:00:00');
          DateTime initialDate =
              DateTime.parse(_formData.fechaDesde.toString() + ' 00:00:00');
          DateTime lastDate =
              DateTime.parse(_formData.fechaDesde.toString() + ' 00:00:00');
          if (diasFijo > 0) {
            firstdate = firstdate.add(Duration(days: (diasFijo - 1)));
            initialDate = initialDate.add(Duration(days: (diasFijo - 1)));
            lastDate = lastDate.add(Duration(days: (diasFijo - 1)));
          } else if (maxDias > 0) {
            initialDate =
                DateTime.parse(_formData.fechaHasta.toString() + ' 00:00:00');
            lastDate = lastDate.add(Duration(days: (maxDias - 1)));
          } else {
            initialDate =
                DateTime.parse(_formData.fechaHasta.toString() + ' 00:00:00');
            lastDate = lastDate = DateTime(DateTime.now().year + 1);
          }
          final date = await showDatePicker(
              context: context,
              firstDate: firstdate,
              initialDate: initialDate,
              lastDate: lastDate);
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
          _formData.fechaHasta = val != null
              ? DateFormat('y-MM-dd').format(DateTime.parse(val.toString()))
              : null;
          if (_formData.periodo == 'H' &&
              _formData.horaInicio != null &&
              _formData.horaFin != null &&
              _formData.fechaDesde != null) {
          } else if (_formData.periodo == 'D' &&
              _formData.fechaDesde != null &&
              _formData.fechaHasta != null) {
            final date1 = DateTime.parse(_formData.fechaDesde.toString());
            final date2 = DateTime.parse(_formData.fechaHasta.toString());
            final difference = date2.difference(date1).inDays;
            if (difference >= 0) {
              _formData.dias = (difference + 1).toString();
            }
            if (_formData.engrupo == 'N' &&
                _formData.codigoConcepto == 'DESC_MED') {
              _validLicensePermit();
            }
          }
          setState(() {});
        },
      ),
    );
  }

  Container _createInputReason() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled: _formData.idEstadoLicaPer != '01' ? false : true,
        initialValue: _formData.motivo,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          labelStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: ColorsApp.primary),
          labelText: 'Motivo',
        ),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        maxLines: 4,
        keyboardType: TextInputType.multiline,
        onSaved: (val) => setState(() => _formData.motivo = val ?? ''),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Widget _createInputAdjunto() {
    return PdfImgInputUpload(
      title: 'Adjuntar sustento',
      subTitle: adjuntoText,
      filePath: adjunto,
      colorBorder: validAdjunto ? Colors.black12 : Colors.red,
      onFile: (val) {
        if (val.path != null) {
          adjunto = val.path.toString();
          adjuntoText = val.name.toString();
          setState(() {});
        }
      },
      onTakePicture: (val) {
        if (val.path.isNotEmpty) {
          adjunto = val.path.toString();
          adjuntoText = val.name.toString();
          setState(() {});
        }
      },
      onDelete: () {
        adjunto = '';
        adjuntoText = '';
        setState(() {});
      },
    );
  }

  Container _createInputTypeInstitution() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: SelectFormField(
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Tipo institución',
            suffixIcon: Icon(Icons.arrow_drop_down)),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600, color: ColorsApp.primary),
        type: SelectFormFieldType.dialog,
        controller: _inputFieldTypeInstitutionCtrl,
        changeIcon: true,
        dialogTitle: 'Seleccionar',
        dialogCancelBtn: 'Cancelar',
        enableSearch: false,
        dialogSearchHint: 'Buscar',
        items: listTypeInstitution
            .map((element) => <String, dynamic>{
                  'value': element.idTipoInstAtencion,
                  'label': element.nombre,
                  'icon': null,
                })
            .toList(),
        enabled: _formData.idEstadoLicaPer != '01' ? false : true,
        onChanged: (val) {
          _formData.idTipoInstAtencion = val;
          final findConcept = listTypeInstitution.firstWhere(
              (element) => element.idTipoInstAtencion == val.toString());
          if (findConcept.idTipoInstAtencion != null) {
            if (findConcept.codigo == 'ESSA') {
              showCodeCITT = true;
              showCodeNitt = false;
            } else if (findConcept.codigo == 'PART') {
              showCodeCITT = false;
              showCodeNitt = true;
            }
          }
          setState(() {});
        },
        onSaved: (val) =>
            setState(() => _formData.idTipoInstAtencion = val ?? ''),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Container _createInputNameInstitution() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled: _formData.idEstadoLicaPer != '01' ||
                _formData.idTipoInstAtencion == null
            ? false
            : true,
        initialValue: _formData.nombreInst,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          labelStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: ColorsApp.primary),
          labelText: 'Nombre institución',
        ),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        onSaved: (val) => setState(() => _formData.nombreInst = val ?? ''),
        onChanged: (val) {},
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Container _createInputCodeCITT() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled: _formData.idEstadoLicaPer != '01' ? false : true,
        initialValue: _formData.codigocitt,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Código N°. de CITT',
            hintText: '0-000-00000000-00'),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        onSaved: (val) => setState(() => _formData.codigocitt = val ?? ''),
        validator: (value) {
          if (value!.isEmpty && showCodeCITT) {
            return 'Campo requerido.';
          } else if (value.isEmpty &&
              showCodeCITT &&
              value.length >= 17 &&
              value.length <= 18) {
            return 'Debe ingresar mínimo 17 caracteres y máximo 18 caracteres.';
          }
          return null;
        },
      ),
    );
  }

  Container _createInputCodeNITT() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled: _formData.idEstadoLicaPer != '01' ? false : true,
        initialValue: _formData.codigocitt,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Código N°. de NITT',
            hintText: '0-000-00000000-00'),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        onSaved: (val) => setState(() => _formData.codigocitt = val ?? ''),
        validator: (value) {
          if (value!.isEmpty && showCodeNitt && diasSumados > 20) {
            return 'Campo requerido.';
          } else if (value.isEmpty &&
              showCodeNitt &&
              value.length >= 12 &&
              value.length <= 13 &&
              diasSumados > 20) {
            return 'Debe ingresar mínimo 12 caracteres y máximo 13 caracteres.';
          }
          return null;
        },
      ),
    );
  }

  Widget _createInputAdjuntoCITT() {
    return PdfImgInputUpload(
      title: 'Adjuntar CITT',
      subTitle: adjuntoCITTText,
      colorBorder: validAdjuntoCITT ? Colors.black12 : Colors.red,
      filePath: adjuntoCITT,
      onFile: (val) {
        if (val.path != null) {
          adjuntoCITT = val.path.toString();
          adjuntoCITTText = val.name.toString();
          setState(() {});
        }
      },
      onTakePicture: (val) {
        if (val.path.isNotEmpty) {
          adjuntoCITT = val.path.toString();
          adjuntoCITTText = val.name.toString();
          setState(() {});
        }
      },
      onDelete: () {
        adjuntoCITT = '';
        adjuntoCITTText = '';
        setState(() {});
      },
    );
  }

  Widget _createInputAdjuntoNITT() {
    return PdfImgInputUpload(
      title: 'Adjuntar NITT',
      subTitle: adjuntoNITTText,
      colorBorder: validAdjuntoNITT ? Colors.black12 : Colors.red,
      filePath: adjuntoNITT,
      onFile: (val) {
        if (val.path != null) {
          adjuntoNITT = val.path.toString();
          adjuntoNITTText = val.name.toString();
          setState(() {});
        }
      },
      onTakePicture: (val) {
        if (val.path.isNotEmpty) {
          adjuntoNITT = val.path.toString();
          adjuntoNITTText = val.name.toString();
          setState(() {});
        }
      },
      onDelete: () {
        adjuntoNITT = '';
        adjuntoNITTText = '';
        setState(() {});
      },
    );
  }

  Container _createInputCodeVIVA() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled: _formData.idEstadoLicaPer != '01' ? false : true,
        initialValue: _formData.codigoviva,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 30.0, vertical: 18.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400, color: ColorsApp.primary),
            labelText: 'Código N°. de VIVA',
            hintText: 'A9DA9S8KK9D7'),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400, color: ColorsApp.primary),
        onSaved: (val) => setState(() => _formData.codigoviva = val ?? ''),
        validator: (value) {
          if (value!.isNotEmpty && value.length >= 12 && value.length <= 13) {
            return 'Debe ingresar mínimo 12 caracteres y máximo 13 caracteres.';
          }
          return null;
        },
      ),
    );
  }

  Widget _createInputAdjuntoVIVA() {
    return PdfImgInputUpload(
      title: 'Adjuntar VIVA',
      subTitle: adjuntoVIVAText,
      filePath: adjuntoVIVA,
      onFile: (val) {
        if (val.path != null) {
          adjuntoVIVA = val.path.toString();
          adjuntoVIVAText = val.name.toString();
          setState(() {});
        }
      },
      onTakePicture: (val) {
        if (val.path.isNotEmpty) {
          adjuntoVIVA = val.path.toString();
          adjuntoVIVAText = val.name.toString();
          setState(() {});
        }
      },
      onDelete: () {
        adjuntoVIVA = '';
        adjuntoVIVAText = '';
        setState(() {});
      },
    );
  }

  Widget _createInputAdjuntoVoucher() {
    return PdfImgInputUpload(
      title: 'Adjuntar voucher',
      subTitle: adjuntoVoucherText,
      colorBorder: validAdjuntoVoucher ? Colors.black12 : Colors.red,
      filePath: adjuntoVoucher,
      onFile: (val) {
        if (val.path != null) {
          adjuntoVoucher = val.path.toString();
          adjuntoVoucherText = val.name.toString();
          setState(() {});
        }
      },
      onTakePicture: (val) {
        if (val.path.isNotEmpty) {
          adjuntoVoucher = val.path.toString();
          adjuntoVoucherText = val.name.toString();
          setState(() {});
        }
      },
      onDelete: () {
        adjuntoVoucher = '';
        adjuntoVoucherText = '';
        setState(() {});
      },
    );
  }

  void _submit(BuildContext buildContext)async {
    validAdjunto = true;
    validAdjuntoCITT = true;
    validAdjuntoNITT = true;
    validAdjuntoVoucher = true;
    List<Map<String, String>> files = [];
    bool isValid = _formKey.currentState!.validate();
    if (requiredAdjunto && adjunto.isEmpty) {
      validAdjunto = false;
      isValid = false;
    } else if (adjunto.isNotEmpty) {
      files.add({'filename': 'adjunto', 'filepath': adjunto});
    }
    if (showInstitution && showCodeCITT && adjuntoCITT.isEmpty) {
      validAdjuntoCITT = false;
      isValid = false;
    } else if (adjuntoCITT.isNotEmpty) {
      files.add({'filename': 'adjunto_citt', 'filepath': adjuntoCITT});
    }
    if (showInstitution &&
        showCodeNitt &&
        diasSumados > 20 &&
        adjuntoNITT.isEmpty) {
      validAdjuntoNITT = false;
      isValid = false;
    } else if (adjuntoNITT.isNotEmpty) {
      files.add({'filename': 'adjunto_nitt', 'filepath': adjuntoNITT});
    }
    if (showInstitution && showCodeNitt && adjuntoVoucher.isEmpty) {
      validAdjuntoVoucher = false;
      isValid = false;
    } else if (adjuntoVoucher.isNotEmpty) {
      files.add({'filename': 'adjunto_voucher', 'filepath': adjuntoVoucher});
    }

    if (adjuntoVIVA.isNotEmpty) {
      files.add({'filename': 'adjunto_viva', 'filepath': adjuntoVIVA});
    }
    setState(() {});
    if (!isValid) {
      ToastCustom()
          .warningContext(context: buildContext, message: 'Corriga los campos marcados de rojo', time: 8);
      return;
    }
    _formKey.currentState!.save();
    ShowLoadingIndicator.showLoadingIndicator(
        text: 'Guardando ...', context: buildContext);
    final Map<String, String> params = {
      'id_concepto_perm_lic': _formData.idConceptoPermLic.toString(),
      'id_entidad': userPreferences.idEntity.toString(),
      'id_trabajador': userPreferences.idWorker.toString(),
      'id_trabajador_grupo': [].toString(),
      'periodo': _formData.periodo.toString(),
      'motivo': _formData.motivo != null ? _formData.motivo.toString() : '',
      'fecha_desde':
          _formData.fechaDesde != null ? _formData.fechaDesde.toString() : '',
      'fecha_hasta':
          _formData.fechaHasta != null ? _formData.fechaHasta.toString() : '',
      'id_tipo_inst_atencion': _formData.idTipoInstAtencion != null
          ? _formData.idTipoInstAtencion.toString()
          : '',
      'nombre_inst':
          _formData.nombreInst != null ? _formData.nombreInst.toString() : '',
      'codigo_citt':
          _formData.codigocitt != null ? _formData.codigocitt.toString() : '',
      'codigo_nitt':
          _formData.codigonit != null ? _formData.codigonit.toString() : '',
      'codigo_viva':
          _formData.codigoviva != null ? _formData.codigoviva.toString() : '',
      'hora_inicio':
          _formData.horaInicio != null ? _formData.horaInicio.toString() : '',
      'hora_fin': _formData.horaFin != null ? _formData.horaFin.toString() : '',
      'id_estado_lica_per': _formData.idEstadoLicaPer.toString(),
      'enhoras': _formData.horas != null ? _formData.horas.toString() : '',
      'ambiente': 'P',
      'engrupo': _formData.engrupo != null ? _formData.engrupo.toString() : '',
      'codigo': _formData.codigoConcepto != null
          ? _formData.codigoConcepto.toString()
          : ''
    };
    ApiResponse create =
        await licensePermitService.createLicensePermit(params, files);
    Navigator.pop(buildContext);
    if (create.success) {
      Navigator.of(buildContext).pop({'change': true, 'data': null});
    }
  }

  void _getDatheader() async {
    setState(() {
      loading = true;
    });

    listTypeLicensePermit = await licensePermitService.getTypeLicensePermit();
    setState(() {
      loading = false;
    });
  }

  void _getTypeConLicePer(String idTipoPermLic) async {
    setState(() {
      loading = true;
    });
    final Map<String, String> params = {'id_tipo_perm_lic': idTipoPermLic};
    listTypeConceptLicensePermit =
        await licensePermitService.getTypeConceptLicensePermit(params);

    setState(() {
      loading = false;
    });
  }

  void _getTypeInstitution() async {
    setState(() {
      loading = true;
    });
    listTypeInstitution = await licensePermitService.getTypeInstitution();
    setState(() {
      loading = false;
    });
  }

  void _validLicensePermit() async {
    setState(() {
      loading = true;
    });
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity.toString(),
      'id_depto': userPreferences.idDeparment.toString(),
      'trabajador': userPreferences.idWorker.toString(),
      'id_concepto_perm_lic': _formData.idConceptoPermLic.toString(),
      'fecha_desde': _formData.fechaDesde.toString(),
      'fecha_hasta': _formData.fechaHasta.toString(),
      'periodo': _formData.periodo.toString()
    };
    listValidLicensePermit =
        await licensePermitService.getValidateLicensePermit(params);
    if (listValidLicensePermit.length > 0) {
      diasAcumulados = listValidLicensePermit[0].diasAcumulado != null
          ? int.parse(listValidLicensePermit[0].diasAcumulado.toString())
          : 0;
      diasSumados = listValidLicensePermit[0].totalDia != null
          ? int.parse(listValidLicensePermit[0].totalDia.toString())
          : 0;
      maxDiasAnho = listValidLicensePermit[0].diasAcumulado != null
          ? int.parse(listValidLicensePermit[0].diasAcumulado.toString())
          : 0;
      fechaFinDesmed = listValidLicensePermit[0].fechaFinDesmes != null
          ? listValidLicensePermit[0].fechaFinDesmes.toString()
          : '';
      fechaFinSubs = listValidLicensePermit[0].fechaFinSubs != null
          ? listValidLicensePermit[0].fechaFinSubs.toString()
          : '';
      fechaIniSubs = listValidLicensePermit[0].fechaIniSubs != null
          ? listValidLicensePermit[0].fechaIniSubs.toString()
          : '';
      diasDesmed = listValidLicensePermit[0].diasDesmed != null
          ? int.parse(listValidLicensePermit[0].diasDesmed.toString())
          : 0;
      diasSubs = listValidLicensePermit[0].diasSubs != null
          ? int.parse(listValidLicensePermit[0].diasSubs.toString())
          : 0;
      maxDiasAnho = listValidLicensePermit[0].maxDiasAnho != null
          ? int.parse(listValidLicensePermit[0].maxDiasAnho.toString())
          : 0;
    }
    setState(() {
      loading = false;
    });
  }
}
