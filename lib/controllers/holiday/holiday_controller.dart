import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/holiday/holiday.dart';
import 'package:lamb_talent/resources/services/auth/auth_service.dart';
import 'package:lamb_talent/resources/services/holiday/holiday_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HolidayController extends GetxController {
  final scrollController = ScrollController();
  final refreshController = RefreshController(initialRefresh: false);
  final userPreferences = UserPreferences();
  RxInt selectYear = DateTime.now().year.obs;
  RxBool loadingDataInit = false.obs;
  List<HolidayModel> listData = [];

  RxInt totalPro = 0.obs;
  RxInt totalGo = 0.obs;

  RxString codeModule = '16120101'.obs;
  RxBool isDth = false.obs;

  RxString idEstadoVacTrab = '01'.obs;
  RxString idPeriodoVacTrab = ''.obs;

  @override
  void onReady() {
    isDth.value = false;
    listData = [];
    getListDataInitial();
    super.onReady();
  }

  @override
  void dispose() {
    scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  void getListDataInitial() async {
    final Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker != null
          ? userPreferences.idWorker.toString()
          : '',
      'id_anho': selectYear.value.toString(),
      'id_persona': userPreferences.idPerson != null
          ? userPreferences.idPerson.toString()
          : ''
    };

    loadingIndicator(onlyLoading: true, opacity: false);
    await getActions();
    final holidayService = HolidayService();
    listData = await holidayService.getHolidays(params);
    totalPro.value = 0;
    totalGo.value = 0;
    for (var element in listData) {
      totalPro.value = totalPro.value + int.parse(element.dias.toString());
      totalGo.value = totalGo.value + int.parse(element.diasEfect.toString());
      idEstadoVacTrab.value = element.idEstadoVacTrab.toString();
      idPeriodoVacTrab.value = element.idPeriodoVacTrab.toString();
    }
    loadingDataInit.value = false;
    loadingDataInit.value = true;
    Get.until((route) => !Get.isDialogOpen!);
  }

  Future getActions() async {
    final Map<String, String> params = {'id_modulo': codeModule.value};
    final authService = AuthService();
    final actions = await authService.getActionsByModule(params);
    isDth.value = actions
        .where((element) =>
            element.clave.toString().toUpperCase() == 'APPROVE_VAC')
        .isNotEmpty;
  }

  void getListData() async {
    final Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker != null
          ? userPreferences.idWorker.toString()
          : '',
      'id_anho': selectYear.value.toString(),
      'id_persona': userPreferences.idPerson != null
          ? userPreferences.idPerson.toString()
          : ''
    };
    loadingIndicator(onlyLoading: true, opacity: false);
    final holidayService = HolidayService();
    listData = await holidayService.getHolidays(params);
    totalPro.value = 0;
    totalGo.value = 0;
    for (var element in listData) {
      totalPro.value = totalPro.value + int.parse(element.dias.toString());
      totalGo.value = totalGo.value + int.parse(element.diasEfect.toString());
      idEstadoVacTrab.value = element.idEstadoVacTrab.toString();
      idPeriodoVacTrab.value = element.idPeriodoVacTrab.toString();
    }
    loadingDataInit.value = false;
    loadingDataInit.value = true;
    Get.until((route) => !Get.isDialogOpen!);
  }

  void changeRequestStatus(
      BuildContext buildContext, String text, String idEstado) async {
    final holidayService = HolidayService();
    Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker.toString(),
      'estado': idEstado,
      'comentario': text
    };
    loadingIndicator(onlyLoading: false, text: 'Guardando ...');
    final create = await holidayService.changeStatusHoliday(
        idPeriodoVacTrab.toString(), params);
    Get.until((route) => !Get.isDialogOpen!);
    if (create.success) {
      Navigator.pop(buildContext);
      getListDataInitial();
    }
  }
}
