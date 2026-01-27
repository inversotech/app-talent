import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:select_form_field/select_form_field.dart';

import 'package:lamb_talent/controllers/license_permit/form_license_permit_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/shared/components/secondary_screen.dart';

import 'pdf_img_input_upload.dart';

class FormLicensePermit extends StatelessWidget {
  final LicensePermitModel arguments;
  const FormLicensePermit({Key? key, required this.arguments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormLicensePermitController>(
        init: FormLicensePermitController(arguments: arguments),
        builder: (controller) {
          return SecondaryScreen(
              title: controller.formData.value.idEstadoLicaPer == '01'
                  ? controller.formData.value.idLicenciaPermiso == null
                      ? 'Nueva Solicitud'
                      : 'Actualizar Solicitud'
                  : 'Detalle Solicitud',
              scrollController: controller.scrollController,
              enablePullDown: false,
              enablePullUp: false,
              floatingActionButton: Container(
                padding: const EdgeInsets.only(left: 32.0),
                child: SingleChildScrollView(
                  child: controller.formData.value.idLicenciaPermiso != null &&
                          controller.formData.value.idEstadoLicaPer == '01'
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
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
                                ))
                          ],
                        )
                      : controller.formData.value.idLicenciaPermiso == null
                          ? Row(
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            )
                          : Container(),
                ),
              ),
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Obx(() => !controller.loadingData.value
                    ? Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                _createInputTypeLicPer(controller),
                                _createInputTypeConceptLicPer(controller),
                                _createInputPeriodo(controller),
                                controller.formData.value.periodo == 'D' ||
                                        controller.formData.value.periodo == 'H'
                                    ? _createInputDateFrom(context, controller)
                                    : Container(),
                                controller.formData.value.periodo == 'D'
                                    ? _createInputDateTo(context, controller)
                                    : Container(),
                                controller.formData.value.periodo == 'H'
                                    ? _createInputHourFrom(context, controller)
                                    : Container(),
                                controller.formData.value.periodo == 'H'
                                    ? _createInputHourTo(context, controller)
                                    : Container(),
                                _createInputReason(controller),
                                _createInputAdjunto(controller),
                                controller.showInstitution.value
                                    ? _createInputTypeInstitution(controller)
                                    : Container(),
                                controller.showInstitution.value
                                    ? _createInputNameInstitution(controller)
                                    : Container(),
                                controller.showCodeCITT.value
                                    ? _createInputCodeCITT(controller)
                                    : Container(),
                                controller.showCodeNitt.value &&
                                        controller.diasSumados.value > 20
                                    ? _createInputCodeNITT(controller)
                                    : Container(),
                                controller.showCodeCITT.value
                                    ? _createInputAdjuntoCITT(controller)
                                    : Container(),
                                controller.showCodeNitt.value &&
                                        controller.diasSumados.value > 20
                                    ? _createInputAdjuntoNITT(controller)
                                    : Container(),
                                controller.showCodeNitt.value &&
                                        controller.diasSumados.value > 20
                                    ? _createInputCodeVIVA(controller)
                                    : Container(),
                                controller.showCodeNitt.value &&
                                        controller.diasSumados.value > 20
                                    ? _createInputAdjuntoVIVA(controller)
                                    : Container(),
                                controller.showCodeNitt.value
                                    ? _createInputAdjuntoVoucher(controller)
                                    : Container()
                              ],
                            ),
                            const SizedBox(
                              height: 80,
                            )
                          ],
                        ),
                      )
                    : Container());
              }));
        });
  }

  Container _createInputTypeLicPer(FormLicensePermitController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SelectFormField(
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Tipo',
            suffixIcon: const Icon(Icons.arrow_drop_down)),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600, color: ColorsApp.primary),
        type: SelectFormFieldType.dialog,
        controller: controller.inputFieldTypeLicPerCtrl,
        changeIcon: true,
        dialogTitle: 'Seleccionar',
        dialogCancelBtn: 'Cancelar',
        enableSearch: false,
        dialogSearchHint: 'Buscar',
        items: controller.listTypeLicensePermit
            .map((element) => <String, dynamic>{
                  'value': element.idTipoPermLic,
                  'label': element.nombre,
                  'enable': element.codigo == 'PPOA' ? false : true,
                  'icon': null,
                })
            .toList(),
        enabled:
            controller.formData.value.idEstadoLicaPer != '01' ? false : true,
        onSaved: (val) => controller.formData.value.idTipoPermLic = val ?? '',
        onChanged: (val) {
          if (val.isNotEmpty) {
            controller.formData.value.idTipoPermLic = val;
            controller.inputFieldTypeConLicPerCtrl.clear();
            controller.inputFieldPeriodoCtrl.clear();
            controller.inputFieldTypeInstitutionCtrl.clear();
            controller.inputFieldDateToCtrl.clear();
            controller.inputFieldDateFromCtrl.clear();

            controller.listTypeConceptLicensePermit = [];
            controller.listTypeInstitution = [];

            controller.cleanConcept();

            controller.formData.value.idConceptoPermLic = null;

            controller.adjunto.value = '';
            controller.adjuntoText.value = '';

            controller.formData.value.idTipoInstAtencion = null;
            controller.formData.value.nombreInst = null;
            controller.formData.value.codigocitt = null;

            controller.getTypeConLicePer(val);
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

  Container _createInputTypeConceptLicPer(
      FormLicensePermitController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SelectFormField(
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Concepto',
            suffixIcon: const Icon(Icons.arrow_drop_down)),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600, color: ColorsApp.primary),
        type: SelectFormFieldType.dialog,
        controller: controller.inputFieldTypeConLicPerCtrl,
        changeIcon: true,
        dialogTitle: 'Seleccionar',
        dialogCancelBtn: 'Cancelar',
        enableSearch: false,
        dialogSearchHint: 'Buscar',
        items: controller.listTypeConceptLicensePermit
            .map((element) => <String, dynamic>{
                  'value': element.idConceptoPermLic,
                  'label': element.nombre,
                  'icon': null,
                })
            .toList(),
        enabled:
            controller.formData.value.idEstadoLicaPer != '01' ? false : true,
        onChanged: (val) {
          controller.formData.value.idConceptoPermLic = val;
          controller.inputFieldPeriodoCtrl.clear();
          controller.inputFieldTypeInstitutionCtrl.clear();
          controller.inputFieldDateToCtrl.clear();
          controller.inputFieldDateFromCtrl.clear();

          controller.showPeriodo.value = false;
          final findConcept = controller.listTypeConceptLicensePermit
              .firstWhere(
                  (element) => element.idConceptoPermLic == val.toString());
          if (findConcept.idConceptoPermLic != null) {
            controller.minDias.value =
                int.parse(findConcept.minDias.toString());
            controller.maxDias.value =
                int.parse(findConcept.maxDias.toString());
            controller.diasFijo.value =
                int.parse(findConcept.diasFijo.toString());
            controller.formData.value.engrupo = findConcept.engrupo.toString();
            controller.formData.value.codigoConcepto =
                findConcept.codigo.toString();
            controller.formData.value.goce =
                findConcept.tipoSuspension.toString();
            if (findConcept.periodo != 'DH') {
              controller.inputFieldPeriodoCtrl.text =
                  findConcept.periodo.toString();
              controller.formData.value.periodo =
                  findConcept.periodo.toString();
              controller.cleanFormCasos(findConcept.periodo.toString());
            } else {
              controller.formData.value.periodo = '';
              controller.showPeriodo.value = true;
              controller.cleanFormCasos(findConcept.periodo.toString());
            }
            if (findConcept.adjuntos == 'S') {
              controller.adjuntoText.value = '';
              controller.adjunto.value = '';
              controller.requiredAdjunto.value = true;
            } else {
              controller.adjuntoText.value = '';
              controller.adjunto.value = '';
              controller.requiredAdjunto.value = false;
            }
            if (findConcept.codigo == 'DESC_MED') {
              controller.showInstitution.value = true;
              controller.cleanTypeInstitution();
              controller.getTypeInstitution();
            } else {
              controller.cleanTypeInstitution();
              controller.showInstitution.value = false;
            }

            controller.showCodeCITT.value = false;
            controller.showCodeNitt.value = false;

            controller.loadingData.value = true;
            controller.loadingData.value = false;
          }
        },
        onSaved: (val) =>
            controller.formData.value.idConceptoPermLic = val ?? '',
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Container _createInputPeriodo(FormLicensePermitController controller) {
    List<Map<String, dynamic>> listPeriodo = [];
    listPeriodo.add({'value': 'D', 'label': 'Día', 'icon': null});
    listPeriodo.add({'value': 'H', 'label': 'Hora', 'icon': null});
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SelectFormField(
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Periodo',
            suffixIcon: const Icon(Icons.arrow_drop_down)),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600, color: ColorsApp.primary),
        type: SelectFormFieldType.dialog,
        controller: controller.inputFieldPeriodoCtrl,
        changeIcon: true,
        dialogTitle: 'Seleccionar',
        dialogCancelBtn: 'Cancelar',
        enableSearch: false,
        dialogSearchHint: 'Buscar',
        items: listPeriodo,
        enabled: controller.formData.value.idEstadoLicaPer != '01' ||
                !controller.showPeriodo.value
            ? false
            : true,
        onChanged: (val) {
          controller.formData.value.periodo = val;
          controller.formData.value.fechaDesde = null;
          controller.formData.value.fechaHasta = null;
          controller.formData.value.horaInicio = null;
          controller.formData.value.horaFin = null;
          controller.inputFieldDateToCtrl.clear();
          controller.inputFieldDateFromCtrl.clear();
          controller.loadingData.value = true;
          controller.loadingData.value = false;
        },
        onSaved: (val) => controller.formData.value.periodo = val ?? '',
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Widget _createInputDateFrom(
      BuildContext context, FormLicensePermitController controller) {
    final format = DateFormat("dd/MM/yyyy");
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DateTimeField(
        controller: controller.inputFieldDateFromCtrl,
        enabled:
            controller.formData.value.idEstadoLicaPer != '01' ? false : true,
        initialValue: controller.formData.value.fechaDesde != null
            ? DateTime.parse(controller.formData.value.fechaDesde.toString())
            : null,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText:
                controller.formData.value.periodo == 'H' ? 'Fecha' : 'Desde'),
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
          controller.formData.value.fechaDesde = val != null
              ? DateFormat('y-MM-dd').format(DateTime.parse(val.toString()))
              : null;
          if (controller.formData.value.periodo == 'H' &&
              controller.formData.value.horaInicio != null &&
              controller.formData.value.horaFin != null &&
              controller.formData.value.fechaDesde != null) {
          } else if (controller.formData.value.periodo == 'D' &&
              controller.formData.value.fechaDesde != null) {
            final fechaDesde = DateTime.parse(
                '${controller.formData.value.fechaDesde} 00:00:00');
            DateTime fechaHasta = fechaDesde;
            if (controller.diasFijo.value > 0) {
              fechaHasta = fechaDesde
                  .add(Duration(days: (controller.diasFijo.value - 1)));
            }
            controller.inputFieldDateToCtrl.text =
                DateFormat('dd/MM/yyyy').format(fechaHasta);
            controller.formData.value.fechaHasta =
                DateFormat('y-MM-dd').format(fechaHasta);
            if (controller.formData.value.fechaHasta != null) {
              final date1 = DateTime.parse(
                  controller.formData.value.fechaDesde.toString());
              final date2 = DateTime.parse(
                  controller.formData.value.fechaHasta.toString());
              final difference = date2.difference(date1).inHours;
              if (difference >= 0) {
                controller.formData.value.dias = (difference + 1).toString();
              }
              if (controller.formData.value.engrupo == 'N' &&
                  controller.formData.value.codigoConcepto == 'DESC_MED') {
                controller.validLicensePermit();
              }
            }
          }

          controller.loadingData.value = true;
          controller.loadingData.value = false;
        },
      ),
    );
  }

  Widget _createInputDateTo(
      BuildContext context, FormLicensePermitController controller) {
    final format = DateFormat("dd/MM/yyyy");
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DateTimeField(
        controller: controller.inputFieldDateToCtrl,
        enabled:
            controller.formData.value.idEstadoLicaPer != '01' ? false : true,
        initialValue: controller.formData.value.fechaHasta != null
            ? DateTime.parse(controller.formData.value.fechaHasta.toString())
            : null,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Hasta'),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        format: format,
        onShowPicker: (context, currentValue) async {
          DateTime firstdate = DateTime.parse(
              '${controller.formData.value.fechaDesde} 00:00:00');
          DateTime initialDate = DateTime.parse(
              '${controller.formData.value.fechaDesde} 00:00:00');
          DateTime lastDate = DateTime.parse(
              '${controller.formData.value.fechaDesde} 00:00:00');
          if (controller.diasFijo.value > 0) {
            firstdate =
                firstdate.add(Duration(days: (controller.diasFijo.value - 1)));
            initialDate = initialDate
                .add(Duration(days: (controller.diasFijo.value - 1)));
            lastDate =
                lastDate.add(Duration(days: (controller.diasFijo.value - 1)));
          } else if (controller.maxDias.value > 0) {
            initialDate = DateTime.parse(
                '${controller.formData.value.fechaHasta} 00:00:00');
            lastDate =
                lastDate.add(Duration(days: (controller.maxDias.value - 1)));
          } else {
            initialDate = DateTime.parse(
                '${controller.formData.value.fechaHasta} 00:00:00');
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
          controller.formData.value.fechaHasta = val != null
              ? DateFormat('y-MM-dd').format(DateTime.parse(val.toString()))
              : null;
          if (controller.formData.value.periodo == 'H' &&
              controller.formData.value.horaInicio != null &&
              controller.formData.value.horaFin != null &&
              controller.formData.value.fechaDesde != null) {
          } else if (controller.formData.value.periodo == 'D' &&
              controller.formData.value.fechaDesde != null &&
              controller.formData.value.fechaHasta != null) {
            final date1 =
                DateTime.parse(controller.formData.value.fechaDesde.toString());
            final date2 =
                DateTime.parse(controller.formData.value.fechaHasta.toString());
            final difference = date2.difference(date1).inDays;
            if (difference >= 0) {
              controller.formData.value.dias = (difference + 1).toString();
            }
            if (controller.formData.value.engrupo == 'N' &&
                controller.formData.value.codigoConcepto == 'DESC_MED') {
              controller.validLicensePermit();
            }
          }

          controller.loadingData.value = true;
          controller.loadingData.value = false;
        },
      ),
    );
  }

  Widget _createInputHourFrom(
      BuildContext context, FormLicensePermitController controller) {
    final format = DateFormat("HH:mm");
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DateTimeField(
        enabled:
            controller.formData.value.idEstadoLicaPer != '01' ? false : true,
        initialValue: controller.formData.value.horaInicio != null
            ? DateTime.parse(
                '${DateFormat('y-MM-dd').format(DateTime.now())} ${controller.formData.value.horaInicio}')
            : null,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
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
          controller.formData.value.horaInicio = val != null
              ? DateFormat('HH:mm').format(DateTime.parse(val.toString()))
              : null;
          if (controller.formData.value.periodo == 'H' &&
              controller.formData.value.horaInicio != null &&
              controller.formData.value.horaFin != null &&
              controller.formData.value.fechaDesde != null) {
            final format = DateFormat("HH:mm");
            final hourFrom =
                format.parse(controller.formData.value.horaInicio.toString());
            final hourTo =
                format.parse(controller.formData.value.horaFin.toString());
            final differenceHour = hourTo.difference(hourFrom);
            controller.formData.value.horas = DateFormat('HH:mm:ss')
                .format(format.parse(differenceHour.toString()));
          }

          controller.loadingData.value = true;
          controller.loadingData.value = false;
        },
      ),
    );
  }

  Widget _createInputHourTo(
      BuildContext context, FormLicensePermitController controller) {
    final format = DateFormat("HH:mm");
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DateTimeField(
        enabled:
            controller.formData.value.idEstadoLicaPer != '01' ? false : true,
        initialValue: controller.formData.value.horaFin != null
            ? DateTime.parse(
                '${DateFormat('y-MM-dd').format(DateTime.now())} ${controller.formData.value.horaFin}')
            : null,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
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
          controller.formData.value.horaFin = val != null
              ? DateFormat('HH:mm').format(DateTime.parse(val.toString()))
              : null;
          if (controller.formData.value.periodo == 'H' &&
              controller.formData.value.horaInicio != null &&
              controller.formData.value.horaFin != null &&
              controller.formData.value.fechaDesde != null) {
            final format = DateFormat("HH:mm");
            final hourFrom =
                format.parse(controller.formData.value.horaInicio.toString());
            final hourTo =
                format.parse(controller.formData.value.horaFin.toString());
            final differenceHour = hourTo.difference(hourFrom);
            controller.formData.value.horas = DateFormat('HH:mm:ss')
                .format(format.parse(differenceHour.toString()));
          }

          controller.loadingData.value = true;
          controller.loadingData.value = false;
          //controller.formData.value.horas =
        },
      ),
    );
  }

  Container _createInputReason(FormLicensePermitController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled:
            controller.formData.value.idEstadoLicaPer != '01' ? false : true,
        initialValue: controller.formData.value.motivo,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          labelStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: ColorsApp.primary),
          labelText: 'Motivo',
        ),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        maxLines: 4,
        keyboardType: TextInputType.multiline,
        onSaved: (val) => controller.formData.value.motivo = val ?? '',
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Widget _createInputAdjunto(FormLicensePermitController controller) {
    return PdfImgInputUpload(
      title: 'Adjuntar sustento',
      subTitle: controller.adjuntoText.value,
      filePath: controller.adjunto.value,
      colorBorder: controller.validAdjunto.value ? Colors.black12 : Colors.red,
      onFile: (val) {
        if (val.path != null) {
          controller.adjunto.value = val.path.toString();
          controller.adjuntoText.value = val.name.toString();
        }
      },
      onTakePicture: (val) {
        if (val.path.isNotEmpty) {
          controller.adjunto.value = val.path.toString();
          controller.adjuntoText.value = val.name.toString();
        }
      },
      onDelete: () {
        controller.adjunto.value = '';
        controller.adjuntoText.value = '';
      },
    );
  }

  Container _createInputTypeInstitution(
      FormLicensePermitController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SelectFormField(
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Tipo institución',
            suffixIcon: const Icon(Icons.arrow_drop_down)),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600, color: ColorsApp.primary),
        type: SelectFormFieldType.dialog,
        controller: controller.inputFieldTypeInstitutionCtrl,
        changeIcon: true,
        dialogTitle: 'Seleccionar',
        dialogCancelBtn: 'Cancelar',
        enableSearch: false,
        dialogSearchHint: 'Buscar',
        items: controller.listTypeInstitution
            .map((element) => <String, dynamic>{
                  'value': element.idTipoInstAtencion,
                  'label': element.nombre,
                  'icon': null,
                })
            .toList(),
        enabled:
            controller.formData.value.idEstadoLicaPer != '01' ? false : true,
        onChanged: (val) {
          controller.formData.value.idTipoInstAtencion = val;
          final findConcept = controller.listTypeInstitution.firstWhere(
              (element) => element.idTipoInstAtencion == val.toString());
          if (findConcept.idTipoInstAtencion != null) {
            if (findConcept.codigo == 'ESSA') {
              controller.showCodeCITT.value = true;
              controller.showCodeNitt.value = false;
            } else if (findConcept.codigo == 'PART') {
              controller.showCodeCITT.value = false;
              controller.showCodeNitt.value = true;
            }
          }

          controller.loadingData.value = true;
          controller.loadingData.value = false;
        },
        onSaved: (val) =>
            controller.formData.value.idTipoInstAtencion = val ?? '',
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Container _createInputNameInstitution(
      FormLicensePermitController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled: controller.formData.value.idEstadoLicaPer != '01' ||
                controller.formData.value.idTipoInstAtencion == null
            ? false
            : true,
        initialValue: controller.formData.value.nombreInst,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          labelStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: ColorsApp.primary),
          labelText: 'Nombre institución',
        ),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        onSaved: (val) => controller.formData.value.nombreInst = val ?? '',
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

  Container _createInputCodeCITT(FormLicensePermitController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled:
            controller.formData.value.idEstadoLicaPer != '01' ? false : true,
        initialValue: controller.formData.value.codigocitt,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Código N°. de CITT',
            hintText: '0-000-00000000-00'),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        onSaved: (val) => controller.formData.value.codigocitt = val ?? '',
        validator: (value) {
          if (value!.isEmpty && controller.showCodeCITT.value) {
            return 'Campo requerido.';
          } else if (value.isEmpty &&
              controller.showCodeCITT.value &&
              value.length >= 17 &&
              value.length <= 18) {
            return 'Debe ingresar mínimo 17 caracteres y máximo 18 caracteres.';
          }
          return null;
        },
      ),
    );
  }

  Container _createInputCodeNITT(FormLicensePermitController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled:
            controller.formData.value.idEstadoLicaPer != '01' ? false : true,
        initialValue: controller.formData.value.codigocitt,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Código N°. de NITT',
            hintText: '0-000-00000000-00'),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        onSaved: (val) => controller.formData.value.codigocitt = val ?? '',
        validator: (value) {
          if (value!.isEmpty &&
              controller.showCodeNitt.value &&
              controller.diasSumados.value > 20) {
            return 'Campo requerido.';
          } else if (value.isEmpty &&
              controller.showCodeNitt.value &&
              value.length >= 12 &&
              value.length <= 13 &&
              controller.diasSumados.value > 20) {
            return 'Debe ingresar mínimo 12 caracteres y máximo 13 caracteres.';
          }
          return null;
        },
      ),
    );
  }

  Widget _createInputAdjuntoCITT(FormLicensePermitController controller) {
    return PdfImgInputUpload(
      title: 'Adjuntar CITT',
      subTitle: controller.adjuntoCITTText.value,
      colorBorder:
          controller.validAdjuntoCITT.value ? Colors.black12 : Colors.red,
      filePath: controller.adjuntoCITT.value,
      onFile: (val) {
        if (val.path != null) {
          controller.adjuntoCITT.value = val.path.toString();
          controller.adjuntoCITTText.value = val.name.toString();
        }
      },
      onTakePicture: (val) {
        if (val.path.isNotEmpty) {
          controller.adjuntoCITT.value = val.path.toString();
          controller.adjuntoCITTText.value = val.name.toString();
        }
      },
      onDelete: () {
        controller.adjuntoCITT.value = '';
        controller.adjuntoCITTText.value = '';
      },
    );
  }

  Widget _createInputAdjuntoNITT(FormLicensePermitController controller) {
    return PdfImgInputUpload(
      title: 'Adjuntar NITT',
      subTitle: controller.adjuntoNITTText.value,
      colorBorder:
          controller.validAdjuntoNITT.value ? Colors.black12 : Colors.red,
      filePath: controller.adjuntoNITT.value,
      onFile: (val) {
        if (val.path != null) {
          controller.adjuntoNITT.value = val.path.toString();
          controller.adjuntoNITTText.value = val.name.toString();
        }
      },
      onTakePicture: (val) {
        if (val.path.isNotEmpty) {
          controller.adjuntoNITT.value = val.path.toString();
          controller.adjuntoNITTText.value = val.name.toString();
        }
      },
      onDelete: () {
        controller.adjuntoNITT.value = '';
        controller.adjuntoNITTText.value = '';
      },
    );
  }

  Container _createInputCodeVIVA(FormLicensePermitController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled:
            controller.formData.value.idEstadoLicaPer != '01' ? false : true,
        initialValue: controller.formData.value.codigoviva,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 18.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400, color: ColorsApp.primary),
            labelText: 'Código N°. de VIVA',
            hintText: 'A9DA9S8KK9D7'),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400, color: ColorsApp.primary),
        onSaved: (val) => controller.formData.value.codigoviva = val ?? '',
        validator: (value) {
          if (value!.isNotEmpty && value.length >= 12 && value.length <= 13) {
            return 'Debe ingresar mínimo 12 caracteres y máximo 13 caracteres.';
          }
          return null;
        },
      ),
    );
  }

  Widget _createInputAdjuntoVIVA(FormLicensePermitController controller) {
    return PdfImgInputUpload(
      title: 'Adjuntar VIVA',
      subTitle: controller.adjuntoVIVAText.value,
      filePath: controller.adjuntoVIVA.value,
      onFile: (val) {
        if (val.path != null) {
          controller.adjuntoVIVA.value = val.path.toString();
          controller.adjuntoVIVAText.value = val.name.toString();
        }
      },
      onTakePicture: (val) {
        if (val.path.isNotEmpty) {
          controller.adjuntoVIVA.value = val.path.toString();
          controller.adjuntoVIVAText.value = val.name.toString();
        }
      },
      onDelete: () {
        controller.adjuntoVIVA.value = '';
        controller.adjuntoVIVAText.value = '';
      },
    );
  }

  Widget _createInputAdjuntoVoucher(FormLicensePermitController controller) {
    return PdfImgInputUpload(
      title: 'Adjuntar voucher',
      subTitle: controller.adjuntoVoucherText.value,
      colorBorder:
          controller.validAdjuntoVoucher.value ? Colors.black12 : Colors.red,
      filePath: controller.adjuntoVoucher.value,
      onFile: (val) {
        if (val.path != null) {
          controller.adjuntoVoucher.value = val.path.toString();
          controller.adjuntoVoucherText.value = val.name.toString();
        }
      },
      onTakePicture: (val) {
        if (val.path.isNotEmpty) {
          controller.adjuntoVoucher.value = val.path.toString();
          controller.adjuntoVoucherText.value = val.name.toString();
        }
      },
      onDelete: () {
        controller.adjuntoVoucher.value = '';
        controller.adjuntoVoucherText.value = '';
      },
    );
  }
}
