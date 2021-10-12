import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/general/date_model.dart';
import 'package:upn_financiero_mobil/src/models/models.dart'
    show PaginationModel, Survey;
import 'package:upn_financiero_mobil/src/providers/utils/functions/capitalize.dart';
import 'package:upn_financiero_mobil/src/services/quiz/quiz_service.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/app_screen.dart';
import 'package:intl/intl.dart';
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
  PaginationModel pagination = new PaginationModel();
  QuizService _quizService = QuizService();
  List<Survey> listData = [];
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
                Transform.translate(
                  offset: Offset(-15, -8),
                  child: IconButton(
                    iconSize: 30,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FormQuiz()));
                    },
                    icon: Icon(Icons.person_add, color: ColorsApp.primary),
                  ),
                )
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
    );
  }

  Container _widgetBody(BoxConstraints constraints, BuildContext context) {
    return Container(
      width: constraints.maxWidth,
      child: Column(
        children: [
          ListQuiz(
            constraints: constraints,
            listData: listData,
            loading: loading,
            onPressed: (arguments) {
              // goToForm(arguments, context);
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
      // getListData(context);
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

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    await getListMoreData();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    final Map<String, String> params = {
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
