import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/general/date_model.dart';
import 'package:upn_financiero_mobil/src/models/models.dart'
    show ActionModule, PaginationModel, Person, Survey;
import 'package:upn_financiero_mobil/src/pages/quiz/components/quiz_detail.dart';
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/providers/utils/functions/capitalize.dart';
import 'package:upn_financiero_mobil/src/services/auth/auth.dart';
import 'package:upn_financiero_mobil/src/services/general/person_service.dart';
import 'package:upn_financiero_mobil/src/services/quiz/quiz_service.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/app_screen.dart';
import 'package:intl/intl.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/loading_indicator.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/search_delegate.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/year_month_datepicker.dart';

import 'components/form_quiz.dart';
import 'components/list_quiz.dart';

class QuizPage extends StatefulWidget {
  QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController _scrollController = ScrollController();
  DateModel dateModel = new DateModel(
      year: DateTime.now().year,
      month: DateTime.now().month,
      nameMonth: capitalize(DateFormat.MMMM('es').format(DateTime.now())));
  bool loading = false;
  int page = 1;
  int perPage = 10;
  bool isSearching = false;
  PaginationModel pagination = new PaginationModel();
  QuizService _quizService = QuizService();
  AuthService _authService = AuthService();
  PersonService _personService = PersonService();
  UserPreferences _preferences = UserPreferences();
  List<Survey> listData = [];
  String idPerson = '';
  Person _personSelect = new Person();
  String codeModule = '16100003';
  List<ActionModule> actions = [];
  bool activeButtonAddQuiz = false;
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
      initialIndex: 2,
      refreshController: _refreshController,
      scrollController: _scrollController,
      enablePullDown: true,
      enablePullUp: true,
      showTabs: true,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            SizedBox(height: 8.0),
            AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              actions: [
                actions.where((element) => element.clave == 'search').length > 0
                    ? Transform.translate(
                        offset: Offset(-15, -8),
                        child: Tooltip(
                          message: 'Buscar persona',
                          child: IconButton(
                            iconSize: 30,
                            onPressed: () async {
                              final searchResult = await showSearch(
                                context: context,
                                delegate: SearchDelgateCustom(
                                    listData: (query) async {
                                      dynamic listPersons = [];
                                      isSearching = true;
                                      Map<String, String> params = {
                                        'id_entidad':
                                            _preferences.idEntity.toString(),
                                        'search': query.toString()
                                      };
                                      listPersons = await _personService
                                          .getPersonsYear(params);
                                      isSearching = false;
                                      return listPersons;
                                    },
                                    fieldLabel: 'Buscar persona',
                                    nameTitle: 'name',
                                    nameSubTitle: 'doc_number',
                                    nameImg: 'foto_url'),
                                //query: 'Hola'
                              );
                              if (searchResult != null) {
                                idPerson = searchResult['id'];
                                _personSelect = Person.fromJson(searchResult);
                                getListDataInitialOtherPerson(
                                    builContext: context);
                              }
                            },
                            icon: Icon(Icons.person_search,
                                color: ColorsApp.primary),
                          ),
                        ),
                      )
                    : Container()
              ],
              elevation: 0,
              backgroundColor: Colors.white,
              toolbarHeight: 40.0,
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Auto reporte diario',
                  style: GoogleFonts.montserrat(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: ColorsApp.primary),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            _widgetFilters(context),
            SizedBox(height: 8.0),
            _widgetBody(constraints, context)
          ],
        );
      }),
      floatingActionButton: actions
                  .where((element) => element.clave == 'add')
                  .length >
              0
          ? TextButton(
              style: ButtonStyle(
                alignment: Alignment.center,
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return ColorsApp.success; // Use the component's default.
                  },
                ),
                shape:
                    MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                  (Set<MaterialState> states) {
                    return RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            25)); // Use the component's default.
                  },
                ),
              ),
              onPressed: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FormQuiz(idPerson: idPerson)));
                if (result != null) {
                  if (result['change'] == 'true' || result['change'] == true) {
                    setState(() {
                      loading = true;
                    });
                    await getListMoreData();
                    setState(() {
                      loading = false;
                    });
                  }
                }
              },
              child: Container(
                width: 180.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    activeButtonAddQuiz
                        ? Icon(Icons.person, color: Colors.white)
                        : Icon(Icons.person_add, color: Colors.white),
                    Text(
                      activeButtonAddQuiz
                          ? 'Realizar encuesta'
                          : 'Nueva encuesta',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ))
          : null,
    );
  }

  Container _widgetBody(BoxConstraints constraints, BuildContext builContext) {
    return Container(
      width: constraints.maxWidth,
      child: Column(
        children: [
          idPerson.isNotEmpty
              ? Chip(
                  avatar: CircleAvatar(
                    child: _personSelect.fotoUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: _personSelect.fotoUrl,
                            placeholder: (context, url) => CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/img/user-default.png'),
                            ),
                            errorWidget: (context, url, error) {
                              return CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/img/user-default.png'));
                            },
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              backgroundImage: imageProvider,
                            ),
                          )
                        : CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/img/user-default.png'),
                          ),
                  ),
                  label: Text(_personSelect.name,
                      style: GoogleFonts.montserrat(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: ColorsApp.primary)),
                  deleteIcon: Icon(Icons.close),
                  onDeleted: () {
                    idPerson = '';
                    _personSelect = Person();
                    listData = [];
                    activeButtonAddQuiz = false;
                    setState(() {
                    });
                    getListData(builContext);
                  },
                )
              : Container(),
          ListQuiz(
            constraints: constraints,
            listData: listData,
            loading: loading,
            onPressed: (Survey survey) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuizDetail(
                            fecha: Jiffy(survey.fecha, 'yyyy-MM-dd')
                                .format('yyyy-MM-dd')
                                .toString(),
                            idPerson: idPerson.isNotEmpty
                                ? idPerson
                                : _preferences.idPerson.toString(),
                            idEncuesta: survey.idEncuesta.toString(),
                            idEntidad: _preferences.idEntity.toString(),
                          )));
            },
            onChangeList: () {
              // getListData(context);
            },
          ),
        ],
      ),
    );
  }

  Container _widgetFilters(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: ColorsApp.primary, width: 1.5),
            borderRadius: BorderRadius.circular(25.0)),
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(''),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                              dateModel.nameMonth +
                                  ', ' +
                                  dateModel.year.toString(),
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: ColorsApp.primary)),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }

  void _selectDate(BuildContext context) async {
    final dateResult = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return YearMonthPicker(
              selectedDate: DateTime(dateModel.year, dateModel.month, 1));
        });
    if (dateResult != null) {
      dateModel.month = int.parse(DateFormat.M().format(dateResult));
      dateModel.nameMonth =
          capitalize(DateFormat.MMMM('es').format(dateResult));
      dateModel.year = int.parse(DateFormat.y().format(dateResult));
      setState(() {});
      getListData(context);
    }
  }

  Future getActions() async {
    final Map<String, String> params = {'id_modulo': codeModule};
    actions = await _authService.getActionsByModule(params);
  }

  void getListData(BuildContext builContext) async {
    final Map<String, String> params = {
      'id_persona':
          idPerson.isNotEmpty ? idPerson : _preferences.idPerson.toString(),
      'id_entidad': _preferences.idEntity.toString(),
      'id_anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'per_page': perPage.toString(),
      'page': '1'
    };
    ShowLoadingIndicator.showLoadingIndicator(
        context: builContext, onlyLoading: true, opacity: false);
    pagination = await _quizService.getSurveyAnswers(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<Survey> list =
        jsonList.map((jsonElement) => Survey.fromJson(jsonElement)).toList();
    listData = list;
    if (pagination.total <= perPage) {
      _refreshController.refreshCompleted();
      _refreshController.loadNoData();
    } else {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    }
    page = 2;
    Navigator.pop(builContext);
    setState(() {});
  }

  void getListDataInitialOtherPerson(
      {required BuildContext builContext}) async {
    final Map<String, String> params = {
      'id_persona':
          idPerson.isNotEmpty ? idPerson : _preferences.idPerson.toString(),
      'id_entidad': _preferences.idEntity.toString(),
      'id_anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'per_page': perPage.toString(),
      'page': '1'
    };
    ShowLoadingIndicator.showLoadingIndicator(
        context: builContext, onlyLoading: true, opacity: false);
    pagination = await _quizService.getSurveyAnswers(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<Survey> list =
        jsonList.map((jsonElement) => Survey.fromJson(jsonElement)).toList();
    listData = list;
    if (pagination.total <= perPage) {
      _refreshController.refreshCompleted();
      _refreshController.loadNoData();
    } else {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    }
    page = 2;
    Navigator.pop(builContext);
    setState(() {});
    final listToday = listData.where((element) =>
        element.fecha!.day == DateTime.now().day &&
        element.fecha!.month == DateTime.now().month &&
        element.fecha!.year == DateTime.now().year);
    if (listToday.length <= 0) {
      activeButtonAddQuiz = true;
      setState(() {});
    }
  }

  void getListDataInitial() async {
    setState(() {
      loading = true;
    });
    await getActions();
    await getListMoreData();
    setState(() {
      loading = false;
    });
    final listToday = listData.where((element) =>
        element.fecha!.day == DateTime.now().day &&
        element.fecha!.month == DateTime.now().month &&
        element.fecha!.year == DateTime.now().year);
    if (listToday.length <= 0) {
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FormQuiz(
                  idPerson: idPerson.isNotEmpty
                      ? idPerson
                      : _preferences.idPerson.toString())));
      if (result != null) {
        if (result['change'] == 'true' || result['change'] == true) {
          setState(() {
            loading = true;
          });
          await getListMoreData();
          setState(() {
            loading = false;
          });
        }
      }
    }
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    await getListMoreData();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    await getActions();
    final Map<String, String> params = {
      'id_persona':
          idPerson.isNotEmpty ? idPerson : _preferences.idPerson.toString(),
      'id_entidad': _preferences.idEntity.toString(),
      'id_anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'per_page': perPage.toString(),
      'page': '1'
    };
    pagination = await _quizService.getSurveyAnswers(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<Survey> list =
        jsonList.map((jsonElement) => Survey.fromJson(jsonElement)).toList();
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

  Future getListMoreData() async {
    final Map<String, String> params = {
      'id_persona':
          idPerson.isNotEmpty ? idPerson : _preferences.idPerson.toString(),
      'id_entidad': _preferences.idEntity.toString(),
      'id_anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'per_page': perPage.toString(),
      'page': page.toString()
    };
    pagination = await _quizService.getSurveyAnswers(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;
    if (jsonList.isNotEmpty) {
      List<Survey> list =
          jsonList.map((jsonElement) => Survey.fromJson(jsonElement)).toList();
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
