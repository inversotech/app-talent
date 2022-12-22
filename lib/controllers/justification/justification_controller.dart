import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import "package:collection/collection.dart";
import 'package:lamb_talent/resources/models/justification/justification_group.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/resources/services/auth/auth_service.dart';
import 'package:lamb_talent/resources/services/justification/justification_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:lamb_talent/shared/components/year_month_datepicker.dart';
import 'package:lamb_talent/ui/modules/justification/components/form_justification.dart';

class JustificationController extends GetxController {
  JustificationController({required this.approve});
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
  List<JustificationGroup> listData = [];
  bool changeApprove = false;
  RxString valueStateJustif = ''.obs;
  RxBool loadingDataInit = false.obs;
  RxInt page = 1.obs;
  RxInt perPage = 10.obs;

  RxString codeModule = '16120101'.obs;
  RxBool isJefeArea = false.obs;
  RxBool isDth = false.obs;

  @override
  void onReady() {
    if (userPreferences.isWorkerChild && approve) {
      //no ase nada
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
    valueStateJustif.value = '';
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
    final _authService = AuthService();
    final actions = await _authService.getActionsByModule(params);
    isJefeArea.value = actions
        .where((element) =>
            element.clave.toString().toUpperCase() == 'APPROVE_JUST_AREA')
        .isNotEmpty;
    isDth.value = actions
        .where((element) =>
            element.clave.toString().toUpperCase() == 'APPROVE_JUST_DTH')
        .isNotEmpty;
    if (isDth.value && approve) {
      valueStateJustif.value = '01,02';
    } else if (isJefeArea.value && approve) {
      valueStateJustif.value = '01';
    }
  }

  void getListData() async {
    final Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker.toString(),
      'id_entidad': userPreferences.idEntity.toString(),
      'id_depto': userPreferences.idDeparment.toString(),
      'id_anho': dateModel.value.year.toString(),
      'id_mes': dateModel.value.month.toString(),
      'id_estado_justif_in': valueStateJustif.toString(),
      'per_page': perPage.value.toString(),
      'page': '1',
      'id_acceso_nivel': userPreferences.idNivelAcceso.isNotEmpty
          ? userPreferences.idNivelAcceso.toString()
          : '',
      'restringido': approve ? 'S' : 'U'
    };
    loadingIndicator(onlyLoading: true, opacity: false);

    final justificationService = JustificationService();
    pagination = await justificationService.getJustifications(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<JustificationModel> list = jsonList
        .map((jsonElement) => JustificationModel.fromJson(jsonElement))
        .toList();
    final newlist = groupBy(list, (JustificationModel obj) => obj.idTrabajador);
    List<JustificationGroup> listDataNew = [];
    newlist.forEach((key, value) {
      listDataNew.add(JustificationGroup(
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

  Future getListMoreData() async {
    final Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker.toString(),
      'id_entidad': userPreferences.idEntity.toString(),
      'id_depto': userPreferences.idDeparment.toString(),
      'id_anho': dateModel.value.year.toString(),
      'id_mes': dateModel.value.month.toString(),
      'id_estado_justif_in': valueStateJustif.toString(),
      'per_page': perPage.value.toString(),
      'page': page.value.toString(),
      'id_acceso_nivel': userPreferences.idNivelAcceso.isNotEmpty
          ? userPreferences.idNivelAcceso.toString()
          : '',
      'restringido': approve ? 'S' : 'U'
    };
    final justificationService = JustificationService();
    pagination = await justificationService.getJustifications(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;
    if (jsonList.isNotEmpty) {
      List<JustificationModel> list = jsonList
          .map((jsonElement) => JustificationModel.fromJson(jsonElement))
          .toList();
      final newlist =
          groupBy(list, (JustificationModel obj) => obj.idTrabajador);
      List<JustificationGroup> listDataNew = [];
      newlist.forEach((key, value) {
        listDataNew.add(JustificationGroup(
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

  void onRefresh() async {
    final Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker.toString(),
      'id_entidad': userPreferences.idEntity.toString(),
      'id_depto': userPreferences.idDeparment.toString(),
      'id_anho': dateModel.value.year.toString(),
      'id_mes': dateModel.value.month.toString(),
      'id_estado_justif_in': valueStateJustif.toString(),
      'per_page': perPage.toString(),
      'page': '1',
      'id_acceso_nivel': userPreferences.idNivelAcceso.isNotEmpty
          ? userPreferences.idNivelAcceso.toString()
          : '',
      'restringido': approve ? 'S' : 'U'
    };
    final justificationService = JustificationService();
    pagination = await justificationService.getJustifications(params);
    List<dynamic> jsonList;
    if (pagination.data == null || pagination.data.runtimeType == String) {
      jsonList = [];
    } else {
      jsonList = pagination.data as List<dynamic>;
    }
    List<JustificationModel> list = jsonList
        .map((jsonElement) => JustificationModel.fromJson(jsonElement))
        .toList();
    final newlist = groupBy(list, (JustificationModel obj) => obj.idTrabajador);
    List<JustificationGroup> listDataNew = [];
    newlist.forEach((key, value) {
      listDataNew.add(JustificationGroup(
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

  void onLoading() async {
    await getListMoreData();
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

  void goToForm(JustificationModel arguments) async {
    final result = await Get.to(() => FormJustification(arguments: arguments));
    if (result != null) {
      if (result['change'] == 'true' || result['change'] == true) {
        getListData();
      }
    }
  }

  void goToBack() {
    final result = {'change': changeApprove, 'data': null};
    Get.back(result: result);
  }
}
