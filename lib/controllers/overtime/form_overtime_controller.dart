import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:lamb_talent/resources/models/overtime/overtime.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/overtime/process_overtime.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/resources/models/overtime/schedule_worker_overtime.dart';
import 'package:lamb_talent/resources/models/overtime/type_overtime.dart';
import 'package:lamb_talent/resources/services/overtime/overtime_service.dart';

import '../../resources/models/models.dart';
import '../../shared/components/loading.dart';

class FormOvertimeController extends GetxController {
  RxBool showwidget = false.obs;
  RxBool showwidget2 = false.obs;
  RxBool showwidget3 = false.obs;

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
  ScheduleWorkerOvertimeModel scheduleWorker = ScheduleWorkerOvertimeModel();
  TextEditingController inputFieldReasonCtrl = TextEditingController(),
      inputFieldPeriodoCtrl = TextEditingController();

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
      inputFieldReasonCtrl.text = formData.value.idTipoSobretiempo.toString();
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
    print(listTypeOvertime);
    loadingData.value = true;
    loadingData.value = false;
    Get.until((route) => !Get.isDialogOpen!);
  }

  @override
  void dispose() {
    scrollController.dispose();
    inputFieldReasonCtrl.dispose();

    inputFieldPeriodoCtrl.dispose();

    super.dispose();
  }

  void submit() async {
    formKey.currentState!.save();
    loadingIndicator(onlyLoading: false, text: 'Guardando ...');
    final Map<String, dynamic> params = {};
  }

  void getSchedule() async {
    print('ASDASD');
    Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker.toString(),
      'fecha': DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(formData.value.fecha.toString()))
    };

    loadingIndicator(onlyLoading: true, opacity: false);
    final overtimeService = OvertimeService();
    scheduleWorker = await overtimeService.getScheduleWorker(params);
    formData.value.horaDesde = scheduleWorker.horaSalida;
    formData.value.maxHoraExt = scheduleWorker.maxHoraExt;

    Get.until((route) => !Get.isDialogOpen!);
    loadingData.value = true;
    loadingData.value = false;
    print(formData.value.horaDesde);
  }
}
