import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/models.dart'
    show DateModel, MarkingModel, PaginationModel;
import 'package:upn_financiero_mobil/src/pages/markings/components/list_markings.dart';
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/providers/utils/functions/capitalize.dart';
import 'package:upn_financiero_mobil/src/services/assistance/index.dart'
    show MarkingService;
import 'package:upn_financiero_mobil/src/shared/widgets/widgets.dart'
    show AppScreen, ShowLoadingIndicator, YearMonthPicker;
import 'package:intl/intl.dart';

class MyMarkingsPage extends StatefulWidget {
  MyMarkingsPage({Key? key}) : super(key: key);

  @override
  _MyMarkingsPageState createState() => _MyMarkingsPageState();
}

class _MyMarkingsPageState extends State<MyMarkingsPage> {
  ScrollController _scrollController = ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  UserPreferences userPreferences = UserPreferences();
  DateModel dateModel = new DateModel(
      date: DateFormat('y-MM-dd').format(
          DateTime.now().subtract(Duration(days: DateTime.now().weekday))),
      dateTo: DateFormat('y-MM-dd').format(DateTime.now()),
      year: DateTime.now().year,
      month: DateTime.now().month,
      nameMonth: capitalize(DateFormat.MMMM('es').format(DateTime.now())));
  PaginationModel pagination = new PaginationModel();
  MarkingService markingService = MarkingService();
  List<MarkingModel> listData = [];
  bool loading = false;
  int perPage = 7;
  int page = 1;
  int selectOption = 2;
  String selectOptionTitle = DateTime.now()
          .subtract(Duration(days: DateTime.now().weekday))
          .day
          .toString() +
      ' al ' +
      DateTime.now().day.toString() +
      ' de ' +
      DateFormat.MMM('es').format(DateTime.now());
  @override
  void initState() {
    super.initState();
    getListDataInitial();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      refreshController: _refreshController,
      scrollController: _scrollController,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      initialIndex: 0,
      showTabs: true,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              SizedBox(height: 8.0),
              AppBar(
                centerTitle: true,
                leading: Transform.translate(
                  offset: Offset(-15, -8),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    iconSize: 40,
                    icon: Icon(Icons.chevron_left, color: ColorsApp.primary),
                  ),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
                toolbarHeight: 40.0,
                title: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Marcaciones',
                    style: GoogleFonts.montserrat(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: ColorsApp.primary),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorsApp.primary, width: 1.5),
                      borderRadius: BorderRadius.circular(25.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              if (selectOption == 4) {
                                _selectMonthYear(context);
                              } else if (selectOption == 5) {
                                _selectDate(context);
                              }
                            },
                            child: Row(
                              children: [
                                selectOptionTitle.isNotEmpty && selectOption > 3
                                    ? Icon(Icons.arrow_drop_down)
                                    : Container(),
                                Text(
                                  selectOptionTitle,
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      color: ColorsApp.primary),
                                ),
                              ],
                            )),
                        InkWell(
                            onTap: () {
                              _bottomOptions(context);
                            },
                            child: Row(
                              children: [
                                Text(_getOptionName(selectOption),
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w400,
                                        color: ColorsApp.primary)),
                                Icon(Icons.arrow_drop_down)
                              ],
                            )),
                      ],
                    ),
                  )),
              SizedBox(height: 12.0),
              Container(
                  child: Column(
                children: [
                  ListMarking(
                      constraints: constraints,
                      listData: listData,
                      loading: loading,
                      onPressed: (arguments) {}),
                ],
              )),
            ],
          ),
        );
      }),
    );
  }

  void _bottomOptions(BuildContext buildContext) {
    showModalBottomSheet(
        context: buildContext,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                selectedTileColor: ColorsApp.primaryVariant,
                leading: selectOption == 1
                    ? Icon(Icons.check, color: Colors.white)
                    : Icon(Icons.today, color: ColorsApp.primary),
                title: new Text(_getOptionName(1),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectOption == 1
                            ? Colors.white
                            : ColorsApp.primary)),
                onTap: () {
                  dateModel.date = DateFormat('y-MM-dd').format(DateTime.now());
                  dateModel.dateTo =
                      DateFormat('y-MM-dd').format(DateTime.now());
                  dateModel.month = DateTime.now().month;
                  selectOption = 1;
                  selectOptionTitle = '';
                  setState(() {});
                  Navigator.pop(context);
                  getListData(buildContext);
                },
                selected: selectOption == 1,
              ),
              ListTile(
                selectedTileColor: ColorsApp.primaryVariant,
                leading: selectOption == 2
                    ? Icon(Icons.check, color: Colors.white)
                    : Icon(Icons.calendar_today, color: ColorsApp.primary),
                title: new Text(_getOptionName(2),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectOption == 2
                            ? Colors.white
                            : ColorsApp.primary)),
                onTap: () {
                  dateModel.date = DateFormat('y-MM-dd').format(DateTime.now()
                      .subtract(Duration(days: DateTime.now().weekday)));
                  dateModel.dateTo =
                      DateFormat('y-MM-dd').format(DateTime.now());
                  selectOption = 2;
                  selectOptionTitle = DateTime.now()
                          .subtract(Duration(days: DateTime.now().weekday))
                          .day
                          .toString() +
                      ' al ' +
                      DateTime.now().day.toString() +
                      ' de ' +
                      DateFormat.MMM('es').format(DateTime.now());
                  setState(() {});
                  Navigator.pop(context);
                  getListData(buildContext);
                },
                selected: selectOption == 2,
              ),
              ListTile(
                selectedTileColor: ColorsApp.primaryVariant,
                leading: selectOption == 3
                    ? Icon(Icons.check, color: Colors.white)
                    : Icon(Icons.calendar_today, color: ColorsApp.primary),
                title: new Text(_getOptionName(3),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectOption == 3
                            ? Colors.white
                            : ColorsApp.primary)),
                onTap: () {
                  dateModel.year = DateTime.now().year;
                  dateModel.month = DateTime.now().month;
                  dateModel.nameMonth =
                      capitalize(DateFormat.MMMM('es').format(DateTime.now()));
                  selectOption = 3;
                  selectOptionTitle =
                      dateModel.nameMonth + ' del ' + dateModel.year.toString();
                  setState(() {});
                  Navigator.pop(context);
                  getListData(buildContext);
                },
                selected: selectOption == 3,
              ),
              ListTile(
                selectedTileColor: ColorsApp.primaryVariant,
                leading: selectOption == 4
                    ? Icon(Icons.check, color: Colors.white)
                    : Icon(Icons.calendar_today, color: ColorsApp.primary),
                title: new Text(_getOptionName(4),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectOption == 4
                            ? Colors.white
                            : ColorsApp.primary)),
                onTap: () {
                  setState(() {
                    selectOption = 4;
                  });
                  Navigator.pop(context);
                  _selectMonthYear(buildContext);
                },
                selected: selectOption == 4,
              ),
              ListTile(
                selectedTileColor: ColorsApp.primaryVariant,
                leading: selectOption == 5
                    ? Icon(Icons.check, color: Colors.white)
                    : Icon(Icons.date_range, color: ColorsApp.primary),
                title: new Text(_getOptionName(5),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectOption == 5
                            ? Colors.white
                            : ColorsApp.primary)),
                onTap: () {
                  setState(() {
                    selectOption = 5;
                  });
                  Navigator.pop(context);
                  _selectDate(buildContext);
                },
                selected: selectOption == 5,
              ),
            ],
          );
        });
  }

  String _getOptionName(int option) {
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

  void _selectMonthYear(BuildContext buildContext) async {
    final dateResult = await showModalBottomSheet(
        context: buildContext,
        builder: (BuildContext context) {
          return YearMonthPicker(
              selectedDate: DateTime(dateModel.year, dateModel.month, 1));
        });
    if (dateResult != null) {
      dateModel.date = '';
      dateModel.month = int.parse(DateFormat.M().format(dateResult));
      dateModel.nameMonth =
          capitalize(DateFormat.MMMM('es').format(dateResult));
      dateModel.year = int.parse(DateFormat.y().format(dateResult));
      selectOptionTitle =
          dateModel.nameMonth + ' del ' + dateModel.year.toString();
      setState(() {});
      getListData(buildContext);
    }
  }

  void _selectDate(BuildContext buildContext) async {
    final date = await showDatePicker(
        context: buildContext,
        firstDate: DateTime(1900),
        initialDate: dateModel.date.isNotEmpty
            ? DateTime.parse(dateModel.date)
            : DateTime.now(),
        lastDate: DateTime.now());
    if (date != null) {
      dateModel.date = DateFormat('y-MM-dd').format(date).toString();
      selectOptionTitle = date.day.toString() +
          ' de ' +
          DateFormat.MMMM('es').format(date) +
          ' del ' +
          date.year.toString();
      setState(() {});
      getListData(buildContext);
    }
  }

  void getListDataInitial() async {
    setState(() {
      loading = true;
    });
    await getListMoreData();
    setState(() {
      loading = false;
    });
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity != null
          ? userPreferences.idEntity.toString()
          : '',
      'id_depto': userPreferences.idDeparment != null
          ? userPreferences.idDeparment.toString()
          : '',
      'id_trabajador': userPreferences.idWorker != null
          ? userPreferences.idWorker.toString()
          : '',
      'id_motivo_asist': 'A',
      'orden_fecha': 'desc',
      'per_page': perPage.toString(),
      'page': '1'
    };
    if (selectOption < 3) {
      params['fecha_desde'] = dateModel.date;
      params['fecha_hasta'] = dateModel.dateTo;
    } else if (selectOption < 5) {
      params['id_anho'] = dateModel.year.toString();
      params['id_mes'] = dateModel.month.toString();
    } else if (selectOption == 5) {
      params['fecha'] = dateModel.date;
    }

    pagination = await markingService.assistMarkings(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<MarkingModel> list = jsonList
        .map((jsonElement) => MarkingModel.fromJson(jsonElement))
        .toList();
    listData = list;
    if (pagination.total <= perPage) {
      _refreshController.refreshCompleted();
      _refreshController.loadNoData();
    } else {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    }
    page = 2;
    setState(() {});
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    await getListMoreData();
  }

  void getListData(BuildContext alertContext) async {
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity != null
          ? userPreferences.idEntity.toString()
          : '',
      'id_depto': userPreferences.idDeparment != null
          ? userPreferences.idDeparment.toString()
          : '',
      'id_trabajador': userPreferences.idWorker != null
          ? userPreferences.idWorker.toString()
          : '',
      'id_motivo_asist': 'A',
      'orden_fecha': 'desc',
      'per_page': perPage.toString(),
      'page': '1'
    };
    if (selectOption < 3) {
      params['fecha_desde'] = dateModel.date;
      params['fecha_hasta'] = dateModel.dateTo;
    } else if (selectOption < 5) {
      params['id_anho'] = dateModel.year.toString();
      params['id_mes'] = dateModel.month.toString();
    } else if (selectOption == 5) {
      params['fecha'] = dateModel.date;
    }

    ShowLoadingIndicator.showLoadingIndicator(
        context: alertContext, onlyLoading: true, opacity: false);
    pagination = await markingService.assistMarkings(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<MarkingModel> list = jsonList
        .map((jsonElement) => MarkingModel.fromJson(jsonElement))
        .toList();
    listData = list;
    if (pagination.total <= perPage) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
    page = 2;
    Navigator.of(alertContext).pop();
    setState(() {});
  }

  Future getListMoreData() async {
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity != null
          ? userPreferences.idEntity.toString()
          : '',
      'id_depto': userPreferences.idDeparment != null
          ? userPreferences.idDeparment.toString()
          : '',
      'id_trabajador': userPreferences.idWorker != null
          ? userPreferences.idWorker.toString()
          : '',
      'id_motivo_asist': 'A',
      'orden_fecha': 'desc',
      'per_page': perPage.toString(),
      'page': page.toString()
    };
    if (selectOption < 3) {
      params['fecha_desde'] = dateModel.date;
      params['fecha_hasta'] = dateModel.dateTo;
    } else if (selectOption < 5) {
      params['id_anho'] = dateModel.year.toString();
      params['id_mes'] = dateModel.month.toString();
    } else if (selectOption == 5) {
      params['fecha'] = dateModel.date;
    }

    pagination = await markingService.assistMarkings(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;
    if (jsonList.isNotEmpty) {
      List<MarkingModel> list = jsonList
          .map((jsonElement) => MarkingModel.fromJson(jsonElement))
          .toList();
      listData.addAll(list);
      page++;
    }
    if (pagination.total <= perPage ||
        jsonList.length < perPage ||
        jsonList.isEmpty) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
    setState(() {});
  }
}
