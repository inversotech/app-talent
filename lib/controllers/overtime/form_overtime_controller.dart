import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:lamb_talent/resources/models/overtime/overtime.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/overtime/process_overtime.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/resources/models/overtime/type_overtime.dart';
import 'package:lamb_talent/resources/services/overtime/overtime_service.dart';

import '../../core/colors.dart';
import '../../core/routers_names.dart';
import '../../resources/models/models.dart';
import '../../shared/components/loading.dart';

class FormOvertimeController extends GetxController {
  RxBool showwidget = false.obs;
  RxBool showwidget2 = false.obs;
  RxBool showwidget3 = false.obs;
  bool button = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final userPreferences = UserPreferences();
  final OvertimeModel arguments;
  List<Map<String, dynamic>> listReasons = [];
  List<ScheduleWorkerModel> listSchedule = [];
  List<MarkingWorkerModel> listMarkings = [];
  List<MarkingModel> listAssistance = [];
  List<MarkingWorkerModel> listMarkingsSelected = [];
  List<DescriptionMarkingModel> listDescripMarkings = [];
  List<DescriptionMarkingModel> listDescriptionsMarking = [];
  List<ProcessOvertimeModel> listProcessOvertime = [];
  List<Color> listColorsMarkingSelected = [];
  List<TypeOvertimeModel> listTypeOvertime = [];
  TextEditingController inputFieldTypeOvertimeCtrl = TextEditingController(),
      inputFieldPeriodoCtrl = TextEditingController(),
      inputFieldHourFromCtrl = TextEditingController(),
      inputFieldHourToCtrl = TextEditingController(),
      inputFieldMaxHourCtrl = TextEditingController(),
      inputFieldHourTotalCtrl = TextEditingController(),
      inputFieldDateCtrl = TextEditingController(),
      inputFieldMotivoCtrl = TextEditingController(),
      inputFieldCompensarCtrl = TextEditingController(),
      inputFieldFechaCompensarCtrl = TextEditingController(),
      inputFieldcomentarioCompensarCtrl = TextEditingController();

  var formData = OvertimeModel().obs;
  RxBool loadMarking = false.obs;
  RxBool loadDescripMarking = false.obs;
  RxBool loadingDescriptionsMarking = false.obs;
  RxString idDescripMarcacion = ''.obs;
  RxBool validForm = false.obs;
  ScheduleWorkerModel? scheduleData;
  FormOvertimeController({required this.arguments});

  RxBool loadingData = false.obs, showPeriodo = true.obs;

  @override
  void onReady() {
    formData.value = arguments;
    if (formData.value.idSobretiempo != null) {
      inputFieldTypeOvertimeCtrl.text =
          formData.value.idTipoSobretiempo.toString();
    } else {
      formData.value.idEstadoSobretiempo = '01';
    }
    _getDatheader();
    super.onReady();
  }

  void _getDatheader() async {
    Get.until((route) => !Get.isDialogOpen!);
    loadingIndicator(onlyLoading: true, opacity: false);

    final overtimeService = OvertimeService();
    listTypeOvertime = await overtimeService.getTypeOvertime();
    loadingData.value = true;
    loadingData.value = false;
    Get.until((route) => !Get.isDialogOpen!);
  }

  @override
  void onClose() {
    scrollController.dispose();
    inputFieldTypeOvertimeCtrl.dispose();
    inputFieldPeriodoCtrl.dispose();

    inputFieldHourFromCtrl.dispose();
    inputFieldHourToCtrl.dispose();
    inputFieldMaxHourCtrl.dispose();
    inputFieldHourTotalCtrl.dispose();
    inputFieldMotivoCtrl.dispose();
    inputFieldCompensarCtrl.dispose();
    inputFieldFechaCompensarCtrl.dispose();
    inputFieldcomentarioCompensarCtrl.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    scrollController.dispose();
    inputFieldTypeOvertimeCtrl.dispose();
    inputFieldPeriodoCtrl.dispose();
    inputFieldHourFromCtrl.dispose();
    inputFieldHourToCtrl.dispose();
    inputFieldMaxHourCtrl.dispose();
    inputFieldHourTotalCtrl.dispose();
    inputFieldMotivoCtrl.dispose();
    inputFieldCompensarCtrl.dispose();
    inputFieldFechaCompensarCtrl.dispose();
    inputFieldcomentarioCompensarCtrl.dispose();

    super.dispose();
  }

  void clear() {
    formData.value.idEstadoSobretiempo = "01";
    formData.value.periodo = null;
    formData.value.fecha = null;
    formData.value.codigoPeriodo = null;
    formData.value.horaDesde = null;
    formData.value.horaHasta = null;
    formData.value.horas = null;
    formData.value.maxHoraExt = null;
    formData.value.motivo = null;
    formData.value.compensado = null;
    formData.value.fechaCompensar = null;
    formData.value.comentarioCompensar = null;
    inputFieldTypeOvertimeCtrl.clear();
    inputFieldPeriodoCtrl.clear();
    inputFieldDateCtrl.clear();
    inputFieldHourFromCtrl.clear();
    inputFieldHourToCtrl.clear();
    inputFieldMaxHourCtrl.clear();
    inputFieldHourTotalCtrl.clear();
    inputFieldMotivoCtrl.clear();
    inputFieldCompensarCtrl.clear();
    inputFieldFechaCompensarCtrl.clear();
    inputFieldcomentarioCompensarCtrl.clear();
    loadingData.value = true;
    loadingData.value = false;
  }

  void submit() async {
    bool isValid = formKey.currentState!.validate();

    if (formData.value.horaDesde != null && formData.value.horaHasta != null) {
      final format = DateFormat("HH:mm");
      final hourFrom = format.parse(formData.value.horaDesde.toString());
      final hourTo = format.parse(formData.value.horaHasta.toString());
      final differenceHour = hourTo.difference(hourFrom);
      if (differenceHour.inMinutes <= 0) {
        Get.snackbar('Error', 'Hora hasta es menor a hora desde',
            duration: const Duration(seconds: 8),
            colorText: ColorsApp.white,
            backgroundColor: ColorsApp.danger);
        isValid = false;
        return;
      }
      if (formData.value.codigoSobretiempo == 'HE') {
        final total = differenceHour.inMinutes;
        final max = int.parse(formData.value.maxHoraExt.toString()) * 60;
        if (total > max) {
          Get.snackbar('Error', 'Maximo de horas superado controller',
              duration: const Duration(seconds: 8),
              colorText: ColorsApp.white,
              backgroundColor: ColorsApp.danger);
          isValid = false;
          return;
        }
      }
    }

    if (!isValid) {
      Get.snackbar('Mensaje:', 'Corriga los campos marcados de rojo',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.warning);
      return;
    }
    formKey.currentState!.save();
    loadingIndicator(onlyLoading: false, text: 'Guardando ...');
    final Map<String, String> params = {
      'id_sobretiempo': '0',
      'id_entidad': userPreferences.idEntity.toString(),
      'id_trabajador': userPreferences.idWorker.toString(),
      'id_depto': userPreferences.idDeparment.toString(),
      'id_tipo_sobretiempo': formData.value.idTipoSobretiempo.toString(),
      'fecha':
          formData.value.fecha != null ? formData.value.fecha.toString() : '',
      'motivo': formData.value.motivo.toString(),
      'hora_desde': formData.value.horaDesde != null
          ? formData.value.horaDesde.toString()
          : '',
      'hora_hasta': formData.value.horaHasta != null
          ? formData.value.horaHasta.toString()
          : '',
      'no_validar': '1',
      'horas':
          formData.value.horas != null ? formData.value.horas.toString() : '',
      'periodo': formData.value.codigoPeriodo != null
          ? formData.value.codigoPeriodo.toString()
          : 'H',
      'compensado': formData.value.compensado != null
          ? formData.value.compensado.toString()
          : '',
      'fecha_compensar': formData.value.fechaCompensar != null
          ? formData.value.fechaCompensar.toString()
          : '',
      'comentario_compensar': formData.value.comentarioCompensar != null
          ? formData.value.comentarioCompensar.toString()
          : '',
    };
    final overtimeService = OvertimeService();
    final create = await overtimeService.createOvertime(params);
    Get.until((route) => !Get.isDialogOpen!);
    if (create.success) {
      clear();
      Get.offAllNamed(RoutesName.home);
    }
  }

  void getSchedule() async {
    Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker.toString(),
      'fecha': DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(formData.value.fecha.toString()))
    };
    loadingIndicator(onlyLoading: true, opacity: false);
    final overtimeService = OvertimeService();
    final scheduleWorker = await overtimeService.getScheduleWorker(params);

    if (formData.value.codigoSobretiempo == 'HE') {
      formData.value.horaDesde = scheduleWorker.horaSalida;
      formData.value.maxHoraExt = scheduleWorker.maxHoraExt;
      inputFieldHourFromCtrl.text = scheduleWorker.horaSalida ?? '';
      inputFieldMaxHourCtrl.text = scheduleWorker.maxHoraExt ?? '';
    }

    Get.until((route) => !Get.isDialogOpen!);
    loadingData.value = true;
    loadingData.value = false;
  }
}
