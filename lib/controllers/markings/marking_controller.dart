import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:lamb_talent/shared/components/year_month_datepicker.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/resources/services/assistance/marking_service.dart';

class MarkingController extends GetxController {
  final scrollController = ScrollController();
  final refreshController = RefreshController(initialRefresh: false);
  final userPreferences = UserPreferences();
  PaginationModel pagination = PaginationModel();
  DateModel dateModel = DateModel(
      date: DateFormat('y-MM-dd').format(
          DateTime.now().subtract(Duration(days: DateTime.now().weekday))),
      dateTo: DateFormat('y-MM-dd').format(DateTime.now()),
      year: DateTime.now().year,
      month: DateTime.now().month,
      nameMonth: capitalize(DateFormat.MMMM('es').format(DateTime.now())));
  List<MarkingModel> listData = [];
  RxBool loadingDataInit = false.obs;
  RxInt perPage = 7.obs;
  RxInt page = 1.obs;
  RxInt selectOption = 2.obs;
  RxString selectOptionTitle =
      ('${DateTime.now().subtract(Duration(days: DateTime.now().weekday)).day} al ${DateTime.now().day} de ${DateFormat.MMM('es').format(DateTime.now())}')
          .obs;
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
  }

  void selectMonthYear() async {
    final dateResult = await Get.bottomSheet(YearMonthPicker(
        selectedDate: DateTime(dateModel.year, dateModel.month, 1)));
    if (dateResult != null) {
      dateModel.date = '';
      dateModel.month = int.parse(DateFormat.M().format(dateResult));
      dateModel.nameMonth =
          capitalize(DateFormat.MMMM('es').format(dateResult));
      dateModel.year = int.parse(DateFormat.y().format(dateResult));
      selectOptionTitle.value =
          ('${dateModel.nameMonth} del ${dateModel.year}').toString();
      getListData();
    }
  }

  void selectDate() async {
    final date = await showDatePicker(
        context: Get.context!,
        firstDate: DateTime(1900),
        initialDate: dateModel.date.isNotEmpty
            ? DateTime.parse(dateModel.date)
            : DateTime.now(),
        lastDate: DateTime.now());
    if (date != null) {
      dateModel.date = DateFormat('y-MM-dd').format(date).toString();
      selectOptionTitle.value =
          '${date.day} de ${DateFormat.MMMM('es').format(date)} del ${date.year}';
      getListData();
    }
  }

  void getListDataInitial() async {
    loadingIndicator(onlyLoading: true, opacity: false);
    await getListMoreData();
    Get.until((route) => !Get.isDialogOpen!);
    loadingDataInit.value = true;
  }

  String getOptionName(int option) {
    String name = '';
    switch (option) {
      case 1:
        name = 'Hoy';
        break;
      case 2:
        name = 'Última semana';
        break;
      case 3:
        name = 'Último mes';
        break;
      case 4:
        name = 'Mensual';
        break;
      case 5:
        name = 'Fecha';
        break;
      default:
    }
    return name;
  }

  void onRefresh() async {
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity != null
          ? userPreferences.idEntity.toString()
          : '',
      /*  'id_depto': userPreferences.idDeparment != null
          ? userPreferences.idDeparment.toString()
          : '', */
      'id_trabajador': userPreferences.idWorker != null
          ? userPreferences.idWorker.toString()
          : '',
      'id_motivo_asist': 'A',
      'orden_fecha': 'desc',
      'per_page': perPage.value.toString(),
      'page': '1'
    };
    if (selectOption < 3) {
      params['fecha_desde'] = dateModel.date;
      params['fecha_hasta'] = dateModel.dateTo;
    } else if (selectOption < 5) {
      params['id_anho'] = dateModel.year.toString();
      params['id_mes'] = dateModel.month.toString();
    } else if (selectOption.value == 5) {
      params['fecha'] = dateModel.date;
    }
    final markingService = MarkingService();
    pagination = await markingService.assistMarkings(params);
    List<dynamic> jsonList;
    if (pagination.data == null || pagination.data.runtimeType == String) {
      jsonList = [];
    } else {
      jsonList = pagination.data as List<dynamic>;
    }
    List<MarkingModel> list = jsonList
        .map((jsonElement) => MarkingModel.fromJson(jsonElement))
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

  void getListData() async {
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity != null
          ? userPreferences.idEntity.toString()
          : '',
      /* 'id_depto': userPreferences.idDeparment != null
          ? userPreferences.idDeparment.toString()
          : '', */
      'id_trabajador': userPreferences.idWorker != null
          ? userPreferences.idWorker.toString()
          : '',
      'id_motivo_asist': 'A',
      'orden_fecha': 'desc',
      'per_page': perPage.value.toString(),
      'page': '1'
    };
    if (selectOption < 3) {
      params['fecha_desde'] = dateModel.date;
      params['fecha_hasta'] = dateModel.dateTo;
    } else if (selectOption.value < 5) {
      params['id_anho'] = dateModel.year.toString();
      params['id_mes'] = dateModel.month.toString();
    } else if (selectOption.value == 5) {
      params['fecha'] = dateModel.date;
    }

    loadingIndicator(onlyLoading: true, opacity: false);

    final markingService = MarkingService();
    pagination = await markingService.assistMarkings(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<MarkingModel> list = jsonList
        .map((jsonElement) => MarkingModel.fromJson(jsonElement))
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
    Get.until((route) => !Get.isDialogOpen!);
  }

  Future getListMoreData() async {
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity != null
          ? userPreferences.idEntity.toString()
          : '',
      /* 'id_depto': userPreferences.idDeparment != null
          ? userPreferences.idDeparment.toString()
          : '', */
      'id_trabajador': userPreferences.idWorker != null
          ? userPreferences.idWorker.toString()
          : '',
      'id_motivo_asist': 'A',
      'orden_fecha': 'desc',
      'per_page': perPage.value.toString(),
      'page': page.value.toString()
    };
    if (selectOption.value < 3) {
      params['fecha_desde'] = dateModel.date;
      params['fecha_hasta'] = dateModel.dateTo;
    } else if (selectOption.value < 5) {
      params['id_anho'] = dateModel.year.toString();
      params['id_mes'] = dateModel.month.toString();
    } else if (selectOption.value == 5) {
      params['fecha'] = dateModel.date;
    }

    final markingService = MarkingService();
    pagination = await markingService.assistMarkings(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;
    if (jsonList.isNotEmpty) {
      List<MarkingModel> list = jsonList
          .map((jsonElement) => MarkingModel.fromJson(jsonElement))
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

  void bottomOptions() {
    Get.bottomSheet(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              selectedTileColor: ColorsApp.primaryVariant,
              leading: selectOption.value == 1
                  ? const Icon(Icons.check, color: Colors.white)
                  : const Icon(Icons.today, color: ColorsApp.primary),
              title: Text(getOptionName(1),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selectOption.value == 1
                          ? Colors.white
                          : ColorsApp.primary)),
              onTap: () {
                dateModel.date = DateFormat('y-MM-dd').format(DateTime.now());
                dateModel.dateTo = DateFormat('y-MM-dd').format(DateTime.now());
                dateModel.month = DateTime.now().month;
                selectOption.value = 1;
                selectOptionTitle.value = '';
                Get.back();
                getListData();
              },
              selected: selectOption.value == 1,
            ),
            ListTile(
              selectedTileColor: ColorsApp.primaryVariant,
              leading: selectOption.value == 2
                  ? const Icon(Icons.check, color: Colors.white)
                  : const Icon(Icons.calendar_today, color: ColorsApp.primary),
              title: Text(getOptionName(2),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selectOption.value == 2
                          ? Colors.white
                          : ColorsApp.primary)),
              onTap: () {
                dateModel.date = DateFormat('y-MM-dd').format(DateTime.now()
                    .subtract(Duration(days: DateTime.now().weekday)));
                dateModel.dateTo = DateFormat('y-MM-dd').format(DateTime.now());
                selectOption.value = 2;
                selectOptionTitle.value =
                    '${DateTime.now().subtract(Duration(days: DateTime.now().weekday)).day} al ${DateTime.now().day} de ${DateFormat.MMM('es').format(DateTime.now())}';
                Get.back();
                getListData();
              },
              selected: selectOption.value == 2,
            ),
            ListTile(
              selectedTileColor: ColorsApp.primaryVariant,
              leading: selectOption.value == 3
                  ? const Icon(Icons.check, color: Colors.white)
                  : const Icon(Icons.calendar_today, color: ColorsApp.primary),
              title: Text(getOptionName(3),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selectOption.value == 3
                          ? Colors.white
                          : ColorsApp.primary)),
              onTap: () {
                dateModel.year = DateTime.now().year;
                dateModel.month = DateTime.now().month;
                dateModel.nameMonth =
                    capitalize(DateFormat.MMMM('es').format(DateTime.now()));
                selectOption.value = 3;
                selectOptionTitle.value =
                    '${dateModel.nameMonth} del ${dateModel.year}';
                Get.back();
                getListData();
              },
              selected: selectOption.value == 3,
            ),
            ListTile(
              selectedTileColor: ColorsApp.primaryVariant,
              leading: selectOption.value == 4
                  ? const Icon(Icons.check, color: Colors.white)
                  : const Icon(Icons.calendar_today, color: ColorsApp.primary),
              title: Text(getOptionName(4),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selectOption.value == 4
                          ? Colors.white
                          : ColorsApp.primary)),
              onTap: () {
                selectOption.value = 4;
                Get.back();
                selectMonthYear();
              },
              selected: selectOption.value == 4,
            ),
            ListTile(
              selectedTileColor: ColorsApp.primaryVariant,
              leading: selectOption.value == 5
                  ? const Icon(Icons.check, color: Colors.white)
                  : const Icon(Icons.date_range, color: ColorsApp.primary),
              title: Text(getOptionName(5),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selectOption.value == 5
                          ? Colors.white
                          : ColorsApp.primary)),
              onTap: () {
                selectOption.value = 5;
                Get.back();
                selectDate();
              },
              selected: selectOption.value == 5,
            ),
          ],
        ),
        backgroundColor: ColorsApp.white);
  }
}
