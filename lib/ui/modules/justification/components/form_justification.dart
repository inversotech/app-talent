import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lamb_talent/controllers/justification/form_justification_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';
import 'package:lamb_talent/shared/components/checkbox_app.dart';
import 'package:select_form_field/select_form_field.dart';

class FormJustification extends StatelessWidget {
  final JustificationModel arguments;
  const FormJustification({Key? key, required this.arguments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormJustificationController>(
        init: FormJustificationController(arguments: arguments),
        builder: (controller) {
          return AppScreen(
              scrollController: controller.scrollController,
              enablePullDown: false,
              enablePullUp: false,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Obx(() => Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 8.0),
                              AppBar(
                                centerTitle: true,
                                leading: Transform.translate(
                                  offset: const Offset(-15, -8),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    iconSize: 40,
                                    icon: const Icon(Icons.chevron_left,
                                        color: ColorsApp.primary),
                                  ),
                                ),
                                elevation: 0,
                                backgroundColor: Colors.white,
                                toolbarHeight: 40.0,
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    controller.formData.value.idEstadoJustif ==
                                            '01'
                                        ? controller.formData.value
                                                    .idSolicJustif ==
                                                null
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
                              const SizedBox(height: 8.0),
                              _createInputDate(context, controller),
                              _createInputReason(controller),
                              _createInputDescription(controller),
                              _createInputEvidence(controller),
                            ],
                          ),
                          controller.formData.value.idEstadoJustif == '01' &&
                                  controller.formData.value.fecha != null
                              ? _createButtonMarking(controller)
                              : Container(),
                          Column(
                            children: [
                              controller.loadMarking.value &&
                                      controller.listSchedule.isNotEmpty
                                  ? _createListMarkings(controller)
                                  : controller.loadMarking.value &&
                                          controller.listSchedule.isEmpty
                                      ? const Center(
                                          child: Text(
                                              'No se ha configurado un horario para esta fecha'),
                                        )
                                      : Container(),
                            ],
                          ),
                          const SizedBox(
                            height: 80,
                          )
                        ],
                      ),
                    ));
              }),
              bottomSheet: controller.formData.value.idSolicJustif != null &&
                      controller.formData.value.idEstadoJustif == '01'
                  ? Container(
                      color: ColorsApp.primaryVariant,
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                _showModalAnular(context, '', controller);
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: const [
                                    Icon(Icons.save_alt_outlined,
                                        color: Colors.white),
                                    Text(
                                      'anular',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(width: 12.0),
                          TextButton(
                              onPressed: () {
                                controller.submit();
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
                                    const Text(
                                      'actualizar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    )
                  : controller.formData.value.idSolicJustif == null
                      ? Container(
                          color: ColorsApp.primaryVariant,
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    controller.submit();
                                  },
                                  style: ButtonStyle(
                                    alignment: Alignment.center,
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      children: [
                                        Image.asset('assets/icons/save.png',
                                            height: 30,
                                            width: 30,
                                            color: Colors.white),
                                        const Text(
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
        });
  }

  Widget _createInputDate(
      BuildContext context, FormJustificationController controller) {
    final format = DateFormat("dd/MM/yyyy");
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DateTimeField(
        enabled:
            controller.formData.value.idEstadoJustif != '01' ? false : true,
        initialValue: controller.formData.value.fecha != null
            ? DateTime.parse(controller.formData.value.fecha.toString())
            : null,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
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
          controller.listMarkings = [];
          controller.loadMarking.value = false;
          controller.formData.value.fecha = val != null
              ? DateFormat('y-MM-dd HH:mm:ss')
                  .format(DateTime.parse(val.toString()))
              : null;
        },
      ),
    );
  }

  Container _createInputReason(FormJustificationController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SelectFormField(
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelText: 'Motivo',
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            suffixIcon:
                const Icon(Icons.arrow_drop_down, color: ColorsApp.primary)),
        type: SelectFormFieldType.dialog,
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600, color: ColorsApp.primary),
        controller: controller.inputFieldReasonCtrl,
        changeIcon: true,
        dialogTitle: 'Seleccionar',
        dialogCancelBtn: 'Cancelar',
        enableSearch: false,
        dialogSearchHint: 'Buscar',
        items: controller.listReasons,
        enabled:
            controller.formData.value.idEstadoJustif != '01' ? false : true,
        onSaved: (val) => controller.formData.value.idMotivoJustif = val ?? '',
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Container _createInputDescription(FormJustificationController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled:
            controller.formData.value.idEstadoJustif != '01' ? false : true,
        initialValue: controller.formData.value.descripcion,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          labelStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: ColorsApp.primary),
          labelText: 'Descripción',
        ),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        maxLines: 4,
        keyboardType: TextInputType.multiline,
        onSaved: (val) => controller.formData.value.descripcion = val ?? '',
      ),
    );
  }

  Container _createInputEvidence(FormJustificationController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                    child: Text(controller.evidenceText.value.toLowerCase(),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            color: ColorsApp.primary))),
                Row(
                  children: [
                    controller.formData.value.idEstadoJustif == '01'
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
                                controller.evidence.value =
                                    file.path.toString();
                                controller.evidenceText.value = file.name;
                              } else {
                                return;
                              }
                            },
                            icon: const Icon(Icons.file_upload_outlined),
                          )
                        : Container(),
                    controller.formData.value.idEstadoJustif == '01'
                        ? IconButton(
                            onPressed: () async {
                              final picker = ImagePicker();
                              final XFile? pickedFile = await picker.pickImage(
                                  source: ImageSource.camera,
                                  imageQuality: 100);
                              if (pickedFile == null) {
                                return;
                              } else {
                                controller.evidence.value =
                                    pickedFile.path.toString();
                                controller.evidenceText.value = pickedFile.name;
                              }
                            },
                            icon: const Icon(Icons.photo_camera),
                          )
                        : Container(),
                    controller.formData.value.evidenciaAdj != null
                        ? IconButton(
                            onPressed: () async {
                              controller.fnShowEvidence();
                            },
                            icon: const Icon(Icons.remove_red_eye),
                          )
                        : Container(),
                    controller.evidence.value.isNotEmpty
                        ? IconButton(
                            onPressed: () async {
                              controller.deleteEvidence.value = true;
                              controller.evidence.value = '';
                              controller.evidenceText.value =
                                  'Adjuntar evidencia';
                            },
                            icon: const Icon(Icons.delete),
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

  Widget _createButtonMarking(FormJustificationController controller) {
    return TextButton(
        onPressed: () {
          controller.getMarkings();
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
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white)
          ],
        ));
  }

  Widget _createListMarkings(FormJustificationController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        primary: false,
        itemCount: controller.listMarkingsSelected.length,
        separatorBuilder: (context, index) {
          return const Divider(
            height: 0,
            color: ColorsApp.primary,
            thickness: 0,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          MarkingWorkerModel item = controller.listMarkingsSelected[index];
          return TextButton(
            onPressed: item.esJustificado
                ? null
                : () {
                    controller.fnClickMarking(index, item);
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
                              controller.fnChangeMarking(index, item, val);
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
                            color: controller.listColorsMarkingSelected[index]),
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
                          ? const Text('Justificado')
                          : Container(),
                    ],
                  ),
                ]),
          );
        },
      ),
    );
  }

  void _showModalAnular(BuildContext buildContext, String id,
      FormJustificationController controller) async {
    await showDialog(
        context: buildContext,
        barrierDismissible: false,
        builder: (context) {
          TextEditingController _inputFieldCtrl = TextEditingController();
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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Anular'),
                ),
                onPressed: () {
                  controller.changeRequestStatus(
                      _inputFieldCtrl.value.text.isNotEmpty
                          ? _inputFieldCtrl.value.text
                          : '');
                },
              )
            ],
          );
        });
  }
}
