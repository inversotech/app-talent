import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lamb_talent/resources/services/auth/auth_service.dart';
import 'package:lamb_talent/resources/services/survey/survey_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:lamb_talent/shared/components/year_month_datepicker.dart';
import 'package:lamb_talent/ui/modules/survey/components/detail_survey.dart';
import 'package:lamb_talent/ui/modules/survey/components/form_survey.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/general/action.dart';
import 'package:lamb_talent/resources/models/general/date_model.dart';
import 'package:lamb_talent/resources/models/general/pagination.dart';
import 'package:lamb_talent/resources/models/general/person.dart';
import 'package:lamb_talent/resources/models/quiz/quiz.dart';

class SurveyController extends GetxController {
  final refreshController = RefreshController(initialRefresh: false);
  final scrollController = ScrollController();
  final preferences = UserPreferences();
  PaginationModel pagination = PaginationModel();
  Person personSelect = Person();
  List<ActionModule> actions = [];
  List<Survey> listData = [];
  var dateModel = DateModel(
          year: DateTime.now().year,
          month: DateTime.now().month,
          nameMonth: capitalize(DateFormat.MMMM('es').format(DateTime.now())))
      .obs;
  RxBool loadingDataInit = true.obs;
  RxInt page = 1.obs;
  RxInt perPage = 10.obs;
  RxBool isSearching = false.obs;
  RxString idPerson = ''.obs;
  RxString codeModule = '16120103'.obs;
  RxBool activeButtonAddQuiz = false.obs;

  @override
  void onReady() {
    initValues();
    getListDataInitial();
    super.onReady();
  }

  void initValues() {
    page.value = 1;
    perPage.value = 7;
    listData = [];
    isSearching.value = false;
    idPerson.value = '';
  }

  @override
  void dispose() {
    scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  void getListDataInitial() async {
    loadingIndicator(onlyLoading: true, opacity: false);
    await _getAccessNivel();
    await getActions();
    await getListMoreData();
    if (Get.isDialogOpen!) {
      Get.back();
    }
    final listToday = listData.where((element) =>
        element.fecha!.day == DateTime.now().day &&
        element.fecha!.month == DateTime.now().month &&
        element.fecha!.year == DateTime.now().year);
    loadingDataInit.value = false;
    loadingDataInit.value = true;
    if (listToday.isEmpty) {
      goToFormSurvey(idPerson.value.isNotEmpty
          ? idPerson.value.toString()
          : preferences.idPerson.toString());
    }
  }

  Future _getAccessNivel() async {
    final Map<String, String> params = {
      'codigo_acceso': codeModule.value.toString()
    };
    final _authService = AuthService();
    final resp = await _authService.getAccessNivel(params);
    preferences.idNivelAcceso = resp.accesoNivel!.idAccesoNivel != null
        ? resp.accesoNivel!.idAccesoNivel.toString()
        : '';
    if (resp.accesoNivel!.idTipoNivelVista != null &&
        resp.accesoNivel!.idTipoNivelVista != '5') {
      preferences.searchPerson = true;
    } else {
      preferences.searchPerson = false;
    }
  }

  void goToFormSurvey(String idPerson) async {
    final result =
        await Get.to(() => FormSurveyPerson(idPerson: idPerson.toString()));
    if (result != null) {
      if (result['change'] == 'true' || result['change'] == true) {
        loadingIndicator(onlyLoading: true, opacity: false);
        await getListMoreData();
        if (Get.isDialogOpen!) {
          Get.back();
        }
      }
    }
  }

  Future getActions() async {
    final Map<String, String> params = {'id_modulo': codeModule.value};
    final _authService = AuthService();
    actions = await _authService.getActionsByModule(params);
  }

  Future getListMoreData() async {
    final Map<String, String> params = {
      'id_persona': idPerson.value.isNotEmpty
          ? idPerson.value
          : preferences.idPerson.toString(),
      'id_entidad': preferences.idEntity.toString(),
      'id_anho': dateModel.value.year.toString(),
      'id_mes': dateModel.value.month.toString(),
      'per_page': perPage.value.toString(),
      'page': page.value.toString()
    };
    final _surveyService = SurveyService();
    pagination = await _surveyService.getSurveyAnswers(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;
    if (jsonList.isNotEmpty) {
      List<Survey> list =
          jsonList.map((jsonElement) => Survey.fromJson(jsonElement)).toList();
      listData.addAll(list);
      page++;
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
    await getActions();
    final Map<String, String> params = {
      'id_persona': idPerson.value.isNotEmpty
          ? idPerson.value
          : preferences.idPerson.toString(),
      'id_entidad': preferences.idEntity.toString(),
      'id_anho': dateModel.value.year.toString(),
      'id_mes': dateModel.value.month.toString(),
      'per_page': perPage.value.toString(),
      'page': '1'
    };
    final _surveyService = SurveyService();
    pagination = await _surveyService.getSurveyAnswers(params);
   List<dynamic> jsonList;
    if (pagination.data == null || pagination.data.runtimeType == String) {
      jsonList = [];
    } else {
      jsonList = pagination.data as List<dynamic>;
    }
    List<Survey> list =
        jsonList.map((jsonElement) => Survey.fromJson(jsonElement)).toList();
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

  void getListDataInitialOtherPerson() async {
    final Map<String, String> params = {
      'id_persona': idPerson.value.isNotEmpty
          ? idPerson.value
          : preferences.idPerson.toString(),
      'id_entidad': preferences.idEntity.toString(),
      'id_anho': dateModel.value.year.toString(),
      'id_mes': dateModel.value.month.toString(),
      'per_page': perPage.value.toString(),
      'page': '1'
    };
    loadingIndicator(onlyLoading: true, opacity: false);
    final _surveyService = SurveyService();
    pagination = await _surveyService.getSurveyAnswers(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<Survey> list =
        jsonList.map((jsonElement) => Survey.fromJson(jsonElement)).toList();
    listData = list;
    if (pagination.total <= perPage.value) {
      refreshController.refreshCompleted();
      refreshController.loadNoData();
    } else {
      refreshController.refreshCompleted();
      refreshController.loadComplete();
    }
    page.value = 2;
    final listToday = listData.where((element) =>
        element.fecha!.day == DateTime.now().day &&
        element.fecha!.month == DateTime.now().month &&
        element.fecha!.year == DateTime.now().year);
    if (listToday.isEmpty) {
      activeButtonAddQuiz.value = true;
    }
    loadingDataInit.value = false;
    loadingDataInit.value = true;
    if (Get.isDialogOpen!) {
      Get.back();
    }
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

  void getListData() async {
    final Map<String, String> params = {
      'id_persona': idPerson.value.isNotEmpty
          ? idPerson.value
          : preferences.idPerson.toString(),
      'id_entidad': preferences.idEntity.toString(),
      'id_anho': dateModel.value.year.toString(),
      'id_mes': dateModel.value.month.toString(),
      'per_page': perPage.value.toString(),
      'page': '1'
    };
    loadingIndicator(onlyLoading: true, opacity: false);
    final _surveyService = SurveyService();
    pagination = await _surveyService.getSurveyAnswers(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<Survey> list =
        jsonList.map((jsonElement) => Survey.fromJson(jsonElement)).toList();
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
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  void goToDetail(Survey survey) {
    Get.to(() => DetailSurvey(
          fecha:
              Jiffy(survey.fecha, 'yyyy-MM-dd').format('yyyy-MM-dd').toString(),
          idPerson: idPerson.value.isNotEmpty
              ? idPerson.value
              : preferences.idPerson.toString(),
          idEncuesta: survey.idEncuesta.toString(),
          idEntidad: preferences.idEntity.toString(),
        ));
  }
}
