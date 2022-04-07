import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/general/pagination.dart';
import 'package:lamb_talent/resources/models/holiday/worker_holiday.dart';
import 'package:lamb_talent/resources/services/auth/auth_service.dart';
import 'package:lamb_talent/resources/services/holiday/holiday_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HolidayApproveController extends GetxController {
  final scrollController = ScrollController();
  final refreshController = RefreshController(initialRefresh: false);
  final userPreferences = UserPreferences();
  List<WorkerHolidayModel> listData = [];
  PaginationModel pagination = PaginationModel();
  String idEstadoVacTrab = '01,03';
  RxBool loadingDataInit = false.obs;
  RxInt page = 1.obs;
  RxInt perPage = 10.obs;
  RxInt totalPro = 0.obs;
  RxInt totalGo = 0.obs;

  RxString codeModule = '16120101'.obs;
  RxBool isDth = false.obs;

  @override
  void onReady() {
    if (userPreferences.isWorkerChild) {
      //no ase nada
    } else {
      isDth.value = false;
      listData = [];
      getListDataInitial();
    }
    super.onReady();
  }

  @override
  void dispose() {
    scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  void getListDataInitial() async {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    loadingIndicator(onlyLoading: true, opacity: false);
    await getActions();
    await getListMoreData();
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  Future getListMoreData() async {
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity.toString(),
      'id_depto': userPreferences.idDeparment.toString(),
      'estado': idEstadoVacTrab.toString(),
      'per_page': perPage.value.toString(),
      'page': page.value.toString(),
      'id_acceso_nivel': userPreferences.idNivelAcceso.isNotEmpty
          ? userPreferences.idNivelAcceso.toString()
          : '',
      'restringido': 'S',
      'is_app': 'S'
    };
    final _holidayService = HolidayService();
    pagination = await _holidayService.getWorkersHoliday(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;
    if (jsonList.isNotEmpty) {
      List<WorkerHolidayModel> list = jsonList
          .map((jsonElement) => WorkerHolidayModel.fromJson(jsonElement))
          .toList();
      listData.addAll(list);
      page.value++;
    }
    if (pagination.total <= perPage.value ||
        jsonList.length < perPage.value ||
        jsonList.isEmpty) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }

    loadingDataInit.value = false;
    loadingDataInit.value = true;
  }

  Future getActions() async {
    final Map<String, String> params = {'id_modulo': codeModule.value};
    final _authService = AuthService();
    final actions = await _authService.getActionsByModule(params);
    isDth.value = actions
        .where((element) =>
            element.clave.toString().toUpperCase() == 'APPROVE_VAC')
        .isNotEmpty;
  }

  void getListData() async {
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity.toString(),
      'id_depto': userPreferences.idDeparment.toString(),
      'estado': idEstadoVacTrab.toString(),
      'per_page': perPage.value.toString(),
      'page': '1',
      'id_acceso_nivel': userPreferences.idNivelAcceso.isNotEmpty
          ? userPreferences.idNivelAcceso.toString()
          : '',
      'restringido': 'S',
      'is_app': 'S'
    };
    loadingIndicator(onlyLoading: true, opacity: false);

    final _holidayService = HolidayService();
    pagination = await _holidayService.getWorkersHoliday(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<WorkerHolidayModel> list = jsonList
        .map((jsonElement) => WorkerHolidayModel.fromJson(jsonElement))
        .toList();
    listData = list;
    if (pagination.total <= perPage.value) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
    page.value = 2;
    loadingDataInit.value = false;
    loadingDataInit.value = true;
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  void onRefresh() async {
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity.toString(),
      'id_depto': userPreferences.idDeparment.toString(),
      'estado': idEstadoVacTrab.toString(),
      'per_page': perPage.value.toString(),
      'page': '1',
      'id_acceso_nivel': userPreferences.idNivelAcceso.isNotEmpty
          ? userPreferences.idNivelAcceso.toString()
          : '',
      'restringido': 'S',
      'is_app': 'S'
    };
    final _holidayService = HolidayService();
    pagination = await _holidayService.getWorkersHoliday(params);
    List<dynamic> jsonList;
    if (pagination.data == null || pagination.data.runtimeType == String) {
      jsonList = [];
    } else {
      jsonList = pagination.data as List<dynamic>;
    }
    List<WorkerHolidayModel> list = jsonList
        .map((jsonElement) => WorkerHolidayModel.fromJson(jsonElement))
        .toList();
    listData = list;
    if (pagination.total <= perPage.value) {
      refreshController.refreshCompleted();
      refreshController.loadNoData();
    } else {
      refreshController.refreshCompleted();
      refreshController.loadComplete();
    }
    page.value = 2;
    loadingDataInit.value = false;
    loadingDataInit.value = true;
  }

  void onLoading() async {
    await getListMoreData();
  }

  void changeRequestStatus(BuildContext buildContext, String text,
      String idEstado, String idWorker, String idPeriodoVacTrab) async {
    final _holidayService = HolidayService();
    Map<String, String> params = {
      'id_trabajador': idWorker,
      'estado': idEstado,
      'comentario': text
    };
    loadingIndicator(onlyLoading: false, text: 'Guardando ...');
    final create =
        await _holidayService.changeStatusHoliday(idPeriodoVacTrab, params);
    if (Get.isDialogOpen!) {
      Get.back();
    }
    if (create.success) {
      if (Get.isSnackbarOpen!) {
        Get.back();
      }
      Navigator.pop(buildContext);
      Navigator.pop(buildContext);
      getListData();
    }
  }
}
