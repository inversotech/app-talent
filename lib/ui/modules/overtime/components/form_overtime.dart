import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:lamb_talent/controllers/overtime/form_overtime_controller.dart';
import 'package:lamb_talent/resources/models/overtime/overtime.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:select_form_field/select_form_field.dart';

import '../../../../resources/models/overtime/type_overtime.dart';

class FormOvertime extends StatelessWidget {
  final OvertimeModel arguments;
  const FormOvertime({Key? key, required this.arguments}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormOvertimeController>(
      init: FormOvertimeController(arguments: arguments),
      builder: (controller) {
        return AppScreen(
            codePage: '16120101',
            scrollController: controller.scrollController,
            enablePullDown: false,
            enablePullUp: false,
            floatingActionButton: controller.formData.value.idSobretiempo !=
                        null &&
                    controller.formData.value.idEstadoSobretiempo == '01'
                ? Container(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: SingleChildScrollView(
                      child: Row(
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
                              onPressed: () {},
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
                    ),
                  )
                : controller.formData.value.idSobretiempo == null
                    ? Container(
                        padding: const EdgeInsets.only(left: 32.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/icons/save.png',
                                          height: 30,
                                          width: 30,
                                          color: Colors.white),
                                      const Text(
                                        'Enviar solicitud',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      )
                    : null,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Obx(() => !controller.loadingData.value
                  ? Form(
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
                                    controller.formData.value
                                                .idEstadoSobretiempo ==
                                            '01'
                                        ? controller.formData.value
                                                    .idSobretiempo ==
                                                null
                                            ? 'Nuevo Sobretiempo'
                                            : 'Actualizar Sobretiempo'
                                        : 'Detalle Sobretiempo',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w700,
                                        color: ColorsApp.primary),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  _createInputTypeOvertime(controller),
                                  controller.formData.value.codigoSobretiempo ==
                                          'FE'
                                      ? _createInputPeriodo(controller)
                                      : Container(),
                                  _createInputDate(context, controller),
                                  controller.formData.value.codigoSobretiempo ==
                                              'HE' ||
                                          controller.formData.value
                                                  .codigoPeriodo ==
                                              'H'
                                      ? _createInputHourFrom(
                                          context, controller)
                                      : Container(),
                                  controller.formData.value.codigoSobretiempo ==
                                              'HE' ||
                                          controller.formData.value
                                                  .codigoPeriodo ==
                                              'H'
                                      ? _createInputHourTo(context, controller)
                                      : Container(),
                                  controller.formData.value.codigoSobretiempo ==
                                              'HE' ||
                                          controller.formData.value
                                                  .codigoPeriodo ==
                                              'H'
                                      ? _createInputTotalHours(controller)
                                      : Container(),
                                  controller.formData.value.codigoSobretiempo ==
                                          'HE'
                                      ? _createInputMaxHours(controller)
                                      : Container(),
                                  _createInputReason(controller),
                                  controller.formData.value.codigoSobretiempo ==
                                          'FE'
                                      ? _createImputCompensado(controller)
                                      : Container(),
                                  controller.formData.value.compensado == 'S'
                                      ? _createInputDateCompensado(
                                          context, controller)
                                      : Container(),
                                  controller.formData.value.compensado == 'S'
                                      ? _createInputReasonCompensado(controller)
                                      : Container()
                                ],
                              )
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
      },
    );
  }

  Container _createInputTypeOvertime(FormOvertimeController controller) {
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
        changeIcon: true,
        dialogTitle: 'Seleccionar',
        dialogCancelBtn: 'Cancelar',
        enableSearch: false,
        dialogSearchHint: 'Buscar',
        items: controller.listTypeOvertime
            .map((element) => <String, dynamic>{
                  'value': element.idTipoSobretiempo,
                  'label': element.nombre,
                  'enable': element.codigo == 'BH' || element.codigo == 'DJ'
                      ? false
                      : true,
                  'icon': null,
                })
            .toList(),
        onSaved: (val) =>
            controller.formData.value.idTipoSobretiempo = val ?? '',
        onChanged: (val) {
          controller.formData.value.idTipoSobretiempo = val;
          TypeOvertimeModel model = controller.listTypeOvertime
              .where((element) => element.idTipoSobretiempo == val)
              .first;
          controller.formData.value.codigoSobretiempo = model.codigo;

          controller.formData.value.fecha = null;
          controller.formData.value.horaDesde = null;
          controller.formData.value.horaHasta = null;
          controller.formData.value.horas = null;
          controller.formData.value.maxHoraExt = null;
          controller.formData.value.codigoPeriodo = null;

          controller.formData.value.motivo = null;
          controller.formData.value.compensado = 'N';
          controller.formData.value.fechaCompensar = null;
          controller.formData.value.comentarioCompensar = null;

          controller.inputFieldDateCtrl.clear();
          controller.inputFieldPeriodoCtrl.clear();
          controller.inputFieldHourFromCtrl.clear();
          controller.inputFieldHourToCtrl.clear();
          controller.inputFieldHourTotalCtrl.clear();
          controller.inputFieldMaxHourCtrl.clear();
          controller.inputFieldMotivoCtrl.clear();
          controller.inputFieldCompensarCtrl.clear();
          controller.inputFieldFechaCompensarCtrl.clear();
          controller.inputFieldcomentarioCompensarCtrl.clear();

          controller.loadingData.value = true;
          controller.loadingData.value = false;
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

  Widget _createInputPeriodo(FormOvertimeController controller) {
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
        onChanged: (val) {
          controller.formData.value.codigoPeriodo = val;
          controller.formData.value.horaDesde = null;
          controller.formData.value.horaHasta = null;
          controller.formData.value.horas = null;
          controller.formData.value.maxHoraExt = null;
          controller.inputFieldHourFromCtrl.clear();
          controller.inputFieldHourToCtrl.clear();
          controller.inputFieldHourTotalCtrl.clear();
          controller.inputFieldMaxHourCtrl.clear();
          controller.inputFieldCompensarCtrl.clear();
          controller.loadingData.value = true;
          controller.loadingData.value = false;
        },
        onSaved: (val) => controller.formData.value.codigoPeriodo = val ?? '',
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Widget _createInputDate(
      BuildContext context, FormOvertimeController controller) {
    final format = DateFormat("dd/MM/yyyy");
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DateTimeField(
        controller: controller.inputFieldDateCtrl,
        enabled: controller.formData.value.idEstadoSobretiempo != '01'
            ? false
            : true,
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
          controller.formData.value.fecha = val != null
              ? DateFormat('y-MM-dd HH:mm:ss')
                  .format(DateTime.parse(val.toString()))
              : null;

          controller.getSchedule();
        },
      ),
    );
  }

  Widget _createInputHourFrom(
      BuildContext context, FormOvertimeController controller) {
    final format = DateFormat("HH:mm");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DateTimeField(
        controller: controller.inputFieldHourFromCtrl,
        enabled: controller.formData.value.idEstadoSobretiempo != '01'
            ? false
            : true,
        /* initialValue: controller.formData.value.horaDesde != null
            ? DateTime.parse(
                '${DateFormat('y-MM-dd').format(DateTime.now())} ${controller.formData.value.horaDesde}')
            : null, */
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Hora Desde'),
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
          controller.formData.value.horaDesde = val != null
              ? DateFormat('HH:mm').format(DateTime.parse(val.toString()))
              : null;
          if (controller.formData.value.horaDesde != null &&
              controller.formData.value.horaHasta != null) {
            final format = DateFormat("HH:mm");
            final hourFrom =
                format.parse(controller.formData.value.horaDesde.toString());
            final hourTo =
                format.parse(controller.formData.value.horaHasta.toString());
            final differenceHour = hourTo.difference(hourFrom);
            /*  controller.formData.value.horas = DateFormat('HH:mm')
                .format(format.parse(differenceHour.toString())); */
            controller.inputFieldHourTotalCtrl.text =
                controller.formData.value.horas ?? '';

            final total = differenceHour.inMinutes;
            final max =
                int.parse(controller.formData.value.maxHoraExt.toString()) * 60;
            if (total > max) {
              Get.snackbar('Error', 'Maximo de horas superado',
                  duration: const Duration(seconds: 8),
                  colorText: ColorsApp.white,
                  backgroundColor: ColorsApp.danger);
            }
          }

          controller.loadingData.value = true;
          controller.loadingData.value = false;
        },
      ),
    );
  }

  Widget _createInputHourTo(
      BuildContext context, FormOvertimeController controller) {
    final format = DateFormat("HH:mm");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DateTimeField(
        controller: controller.inputFieldHourToCtrl,
        enabled: controller.formData.value.idEstadoSobretiempo != '01'
            ? false
            : true,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Hora hasta'),
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
          controller.formData.value.horaHasta = val != null
              ? DateFormat('HH:mm').format(DateTime.parse(val.toString()))
              : null;
          if (controller.formData.value.horaDesde != null &&
              controller.formData.value.horaHasta != null) {
            final format = DateFormat("HH:mm");
            final hourFrom =
                format.parse(controller.formData.value.horaDesde.toString());
            final hourTo =
                format.parse(controller.formData.value.horaHasta.toString());
            final differenceHour = hourTo.difference(hourFrom);
            if (differenceHour.inMinutes > 0) {
              controller.formData.value.horas = DateFormat('HH:mm')
                  .format(format.parse(differenceHour.toString()));
            } else {
              Get.snackbar('Error', 'Hora hasta es menor a hora desde',
                  duration: const Duration(seconds: 4),
                  colorText: ColorsApp.white,
                  backgroundColor: ColorsApp.danger);
              controller.formData.value.horas = '';
            }

            controller.inputFieldHourTotalCtrl.text =
                controller.formData.value.horas ?? '';

            if (controller.formData.value.codigoSobretiempo == 'HE') {
              final total = differenceHour.inMinutes;
              final max =
                  int.parse(controller.formData.value.maxHoraExt.toString()) *
                      60;
              if (total > max) {
                Get.snackbar('Error', 'Maximo de horas superado',
                    duration: const Duration(seconds: 4),
                    colorText: ColorsApp.white,
                    backgroundColor: ColorsApp.danger);
              }
            }
          }

          controller.loadingData.value = true;
          controller.loadingData.value = false;
          //controller.formData.value.horas =
        },
      ),
    );
  }

  Widget _createInputTotalHours(FormOvertimeController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller.inputFieldHourTotalCtrl,
        enabled: false,
        /* initialValue: controller.formData.value.horas ?? "", */
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          labelStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: ColorsApp.primary),
          labelText: 'Total Horas',
        ),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        maxLines: 1,
        keyboardType: TextInputType.multiline,
        onSaved: (val) => controller.formData.value.horas = val ?? '',
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Widget _createInputMaxHours(FormOvertimeController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller.inputFieldMaxHourCtrl,
        enabled: false,
        /* initialValue: controller.formData.value.maxHoraExt, */
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          labelStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: ColorsApp.primary),
          labelText: 'Max. Horas a programar',
        ),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        maxLines: 1,
        keyboardType: TextInputType.multiline,
        onSaved: (val) => controller.formData.value.maxHoraExt = val ?? '',
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Container _createInputReason(FormOvertimeController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller.inputFieldMotivoCtrl,
        enabled: controller.formData.value.idEstadoSobretiempo != '01'
            ? false
            : true,
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

  Widget _createImputCompensado(FormOvertimeController controller) {
    List<Map<String, dynamic>> listPeriodo = [];
    listPeriodo.add({'value': 'S', 'label': ' Si', 'icon': null});
    listPeriodo.add({'value': 'N', 'label': 'No', 'icon': null});

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
            labelText: 'Compensado',
            suffixIcon: const Icon(Icons.arrow_drop_down)),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600, color: ColorsApp.primary),
        type: SelectFormFieldType.dialog,
        controller: controller.inputFieldCompensarCtrl,
        changeIcon: true,
        dialogTitle: 'Seleccionar',
        dialogCancelBtn: 'Cancelar',
        enableSearch: false,
        dialogSearchHint: 'Buscar',
        items: listPeriodo,
        onChanged: (val) {
          controller.formData.value.compensado = val;

          if (val == 'N') {
            controller.formData.value.fechaCompensar = null;
            controller.formData.value.comentarioCompensar = null;
          }
          controller.loadingData.value = true;
          controller.loadingData.value = false;
        },
        onSaved: (val) => controller.formData.value.compensado = val ?? '',
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Widget _createInputDateCompensado(
      BuildContext context, FormOvertimeController controller) {
    final format = DateFormat("dd/MM/yyyy");
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DateTimeField(
        controller: controller.inputFieldFechaCompensarCtrl,
        enabled: controller.formData.value.idEstadoSobretiempo != '01'
            ? false
            : true,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: 'Fecha Compensado'),
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
          controller.formData.value.fechaCompensar = val != null
              ? DateFormat('y-MM-dd HH:mm:ss')
                  .format(DateTime.parse(val.toString()))
              : null;
        },
      ),
    );
  }

  Container _createInputReasonCompensado(FormOvertimeController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller.inputFieldcomentarioCompensarCtrl,
        enabled: controller.formData.value.idEstadoSobretiempo != '01'
            ? false
            : true,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          labelStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: ColorsApp.primary),
          labelText: 'Motivo Compensado',
        ),
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: ColorsApp.primary),
        maxLines: 4,
        keyboardType: TextInputType.multiline,
        onSaved: (val) =>
            controller.formData.value.comentarioCompensar = val ?? '',
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }
}
