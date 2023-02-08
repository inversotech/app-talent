import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/overtime/overtime.dart';
import 'package:lamb_talent/resources/models/overtime/overtime_group.dart';
import 'package:lamb_talent/resources/models/overtime/type_overtime.dart';
import 'package:lamb_talent/resources/services/overtime/overtime_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/models.dart';

import '../../resources/providers/api.provider.dart';
import '../../resources/services/auth/auth_service.dart';
import '../../shared/components/year_month_datepicker.dart';

class OvertimeController extends GetxController {
  OvertimeController({required this.approve});
  final bool approve;
  final scrollController = ScrollController();
  final refreshController = RefreshController(initialRefresh: false);
  final userPreferences = UserPreferences();
  PaginationModel pagination = PaginationModel();
  var dateModel = DateModel(
          year: DateTime.now().year,
          month: DateTime.now().month,
          nameMonth: capitalize(DateFormat.MMMM('es').format(DateTime.now())))
      .obs;
  List<OvertimeGroup> listData = [];
  bool changeApprove = false;
  RxString valueStateOver = ''.obs;
  RxBool loadingDataInit = false.obs;
  RxInt page = 1.obs;
  RxInt perPage = 10.obs;

  RxString codeModule = '16120101'.obs;
  RxBool isJefeArea = false.obs;
  RxBool isWorker = false.obs;
  RxBool isDth = false.obs;

  @override
  void onReady() {
    if (userPreferences.isWorkerChild && approve) {
    } else {
      initValues();
      getListDataInitial();
    }
    super.onReady();
  }

  void initValues() {
    page.value = 1;
    perPage.value = 10;
    listData = [];
    valueStateOver.value = '';
  }

  void getListDataInitial() async {
    Get.until((route) => !Get.isDialogOpen!);
    loadingIndicator(onlyLoading: true, opacity: false);
    await getActions();
    await getListMoreData();
    Get.until((route) => !Get.isDialogOpen!);
  }

  Future getActions() async {
    final Map<String, String> params = {'id_modulo': codeModule.value};
    final authService = AuthService();
    final actions = await authService.getActionsByModule(params);

    isJefeArea.value = actions
        .where((element) =>
            element.clave.toString().toUpperCase() == 'APPROVE_OVERTIME_AREA')
        .isNotEmpty;
    isDth.value = actions
        .where((element) =>
            element.clave.toString().toUpperCase() == 'APPROVE_OVERTIME_DTH')
        .isNotEmpty;
    if (isDth.value && approve) {
      valueStateOver.value = '01,04';
    } else if (isJefeArea.value && approve) {
      valueStateOver.value = '01';
    }
  }

  Future getListMoreData() async {
    final Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker.toString(),
      'id_entidad': userPreferences.idEntity.toString(),
/*       'id_depto': userPreferences.idDeparment.toString(),
 */
      'id_anho': dateModel.value.year.toString(),
      'id_mes': dateModel.value.month.toString(),
      'id_estado_sobretiempo_in': valueStateOver.toString(),
      'per_page': perPage.value.toString(),
      'page': page.value.toString(),
      'id_acceso_nivel': userPreferences.idNivelAcceso.isNotEmpty
          ? userPreferences.idNivelAcceso.toString()
          : '',
      'restringido': approve ? 'S' : 'U'
    };
    final overtimeService = OvertimeService();
    pagination = await overtimeService.getOvertimes(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;
    if (jsonList.isNotEmpty) {
      List<OvertimeModel> list = jsonList
          .map((jsonElement) => OvertimeModel.fromJson(jsonElement))
          .toList();
      final newlist = groupBy(list, (OvertimeModel obj) => obj.idTrabajador);
      List<OvertimeGroup> listDataNew = [];
      newlist.forEach((key, value) {
        listDataNew.add(OvertimeGroup(
            idTrabajador: value[0].idTrabajador,
            apellidonombre: value[0].apellidonombre,
            children: value));
      });
      listData.addAll(listDataNew);
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

  Future getListData() async {
    final Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker.toString(),
      'id_entidad': userPreferences.idEntity.toString(),
/*       'id_depto': userPreferences.idDeparment.toString(),
 */
      'id_anho': dateModel.value.year.toString(),
      'id_mes': dateModel.value.month.toString(),
      'id_estado_sobretiempo_in': valueStateOver.toString(),
      'per_page': perPage.value.toString(),
      'page': '1',
      'id_acceso_nivel': userPreferences.idNivelAcceso.isNotEmpty
          ? userPreferences.idNivelAcceso.toString()
          : '',
      'restringido': approve ? 'S' : 'U'
    };
    loadingIndicator(onlyLoading: true, opacity: false);

    final overtimeService = OvertimeService();
    pagination = await overtimeService.getOvertimes(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<OvertimeModel> list = jsonList
        .map((jsonElement) => OvertimeModel.fromJson(jsonElement))
        .toList();
    final newlist = groupBy(list, (OvertimeModel obj) => obj.idTrabajador);
    List<OvertimeGroup> listDataNew = [];
    newlist.forEach((key, value) {
      listDataNew.add(OvertimeGroup(
          idTrabajador: value[0].idTrabajador,
          apellidonombre: value[0].apellidonombre,
          children: value));
    });
    listData = listDataNew;

    if (pagination.total <= perPage.value) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
    page.value = 2;
    loadingDataInit.value = false;
    loadingDataInit.value = true;
    Get.until((route) => !Get.isDialogOpen!);
  }

  Future onRefresh() async {
    final Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker.toString(),
      'id_entidad': userPreferences.idEntity.toString(),
/*       'id_depto': userPreferences.idDeparment.toString(),
 */
      'id_anho': dateModel.value.year.toString(),
      'id_mes': dateModel.value.month.toString(),
      'id_estado_sobretiempo_in': valueStateOver.toString(),
      'per_page': perPage.value.toString(),
      'page': '1',
      'id_acceso_nivel': userPreferences.idNivelAcceso.isNotEmpty
          ? userPreferences.idNivelAcceso.toString()
          : '',
      'restringido': approve ? 'S' : 'U'
    };

    final overtimeService = OvertimeService();
    pagination = await overtimeService.getOvertimes(params);
    List<dynamic> jsonList;
    if (pagination.data == null || pagination.data.runtimeType == String) {
      jsonList = [];
    } else {
      jsonList = pagination.data as List<dynamic>;
    }

    List<OvertimeModel> list = jsonList
        .map((jsonElement) => OvertimeModel.fromJson(jsonElement))
        .toList();
    final newlist = groupBy(list, (OvertimeModel obj) => obj.idTrabajador);
    List<OvertimeGroup> listDataNew = [];
    newlist.forEach((key, value) {
      listDataNew.add(OvertimeGroup(
          idTrabajador: value[0].idTrabajador,
          apellidonombre: value[0].apellidonombre,
          children: value));
    });
    listData = listDataNew;

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

  void selectDate() async {
    final dateResult = await Get.bottomSheet(YearMonthPicker(
        selectedDate:
            DateTime(dateModel.value.year, dateModel.value.month, 1)));
    if (dateResult != null) {
      dateModel.value.month = int.parse(DateFormat.M().format(dateResult));
      dateModel.value.nameMonth =
          capitalize(DateFormat.MMMM('es').format(dateResult));
      dateModel.value.year = int.parse(DateFormat.y().format(dateResult));
      dateModel.refresh();
      getListData();
    }
  }

  void onLoading() async {
    await getListMoreData();
  }

  void goToBack() {
    final result = {'change': changeApprove, 'data': null};
    Get.back(result: result);
  }
}
