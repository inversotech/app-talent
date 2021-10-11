import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/models.dart'
    show
        DateModel,
        JustificationModel,
        PaginationModel,
        ProcessJustifcationModel;
import 'package:upn_financiero_mobil/src/pages/justification/components/list_justificaton.dart';
import 'package:upn_financiero_mobil/src/providers/utils/functions/capitalize.dart';
import 'package:upn_financiero_mobil/src/shared//widgets/widgets.dart'
    show AppScreen, ShowLoadingIndicator, YearMonthPicker;
import 'package:upn_financiero_mobil/src/services/services.dart'
    show StateJustifService, JustificationService;
import 'package:intl/intl.dart';
import 'components/form_justification.dart';

class JustificationPage extends StatefulWidget {
  const JustificationPage({Key? key}) : super(key: key);

  @override
  State<JustificationPage> createState() => _JustificationPageState();
}

class _JustificationPageState extends State<JustificationPage> {
  String? valueStateJustif = '';
  DateModel dateModel = new DateModel(
      year: DateTime.now().year,
      month: DateTime.now().month,
      nameMonth: capitalize(DateFormat.MMMM('es').format(DateTime.now())));
  List<JustificationModel> listData = [];
  List<ProcessJustifcationModel> listStateJustif = [];
  bool loading = false;
  int page = 1;
  int perPage = 10;
  PaginationModel pagination = new PaginationModel();

  JustificationService justificationService = JustificationService();
  ScrollController _scrollController = ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    getDataFilters();
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
          return Column(
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
                    'Justificaciones',
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
        }));
  }

  Container _widgetBody(BoxConstraints constraints, BuildContext context) {
    return Container(
      width: constraints.maxWidth,
      child: Column(
        children: [
          ListJustification(
            constraints: constraints,
            listData: listData,
            loading: loading,
            onPressed: (arguments) {
              goToForm(arguments, context);
            },
            onChangeList: () {
              getListData(context);
            },
          ),
        ],
      ),
    );
  }

  Container _widgetFilters(BuildContext buildContext) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: ColorsApp.primary,width: 1.5),
            borderRadius: BorderRadius.circular(25.0)),
        child: Column(children: [
          InkWell(
              onTap: () {
                _selectDate(buildContext);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 12.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(''),
                        ],
                      ),
                      Row(children: [
                        Text(
                          dateModel.nameMonth + ', ' + dateModel.year.toString(),
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              color: ColorsApp.primary),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ])
                    ]),
              ))
        ]));
  }

  void goToForm(JustificationModel arguments, BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FormJustification(
                  arguments: arguments,
                )));
    if (result != null) {
      if (result['change'] == 'true' || result['change'] == true) {
        getListData(context);
      }
    }
  }

  void _selectDate(BuildContext builContext) async {
    final dateResult = await showModalBottomSheet(
        context: builContext,
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
      getListData(builContext);
    }
  }


  void getDataFilters() async {
    StateJustifService stateJustifService = StateJustifService();
    listStateJustif
        .add(new ProcessJustifcationModel(nombre: 'Todos', idEstadoJustif: ''));
    setState(() {
      loading = true;
    });
    final result = await stateJustifService.getStateJustification();
    listStateJustif.addAll(result);
    setState(() {
      loading = false;
    });
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

  void getListData(BuildContext builContext) async {
    final Map<String, String> params = {
      'id_anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'id_estado_justif': valueStateJustif.toString(),
      'per_page': perPage.toString(),
      'page': '1'
    };
    ShowLoadingIndicator.showLoadingIndicator(
        context: builContext, onlyLoading: true, opacity: false);
    pagination = await justificationService.getJustifications(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<JustificationModel> list = jsonList
        .map((jsonElement) => JustificationModel.fromJson(jsonElement))
        .toList();
    listData = list;
    if (pagination.total <= perPage) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
    page = 2;
    Navigator.pop(builContext);
    setState(() {});
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    final Map<String, String> params = {
      'id_anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'id_estado_justif': valueStateJustif.toString(),
      'per_page': perPage.toString(),
      'page': '1'
    };
    pagination = await justificationService.getJustifications(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<JustificationModel> list = jsonList
        .map((jsonElement) => JustificationModel.fromJson(jsonElement))
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

  Future getListMoreData() async {
    final Map<String, String> params = {
      'id_anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'id_estado_justif': valueStateJustif.toString(),
      'per_page': perPage.toString(),
      'page': page.toString()
    };
    pagination = await justificationService.getJustifications(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;
    if (jsonList.isNotEmpty) {
      List<JustificationModel> list = jsonList
          .map((jsonElement) => JustificationModel.fromJson(jsonElement))
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
