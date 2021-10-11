import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/models.dart'
    show
        DateModel,
        LicensePermitModel,
        PaginationModel,
        StateLicensePermitModel;
import 'package:upn_financiero_mobil/src/pages/license_permit/components/form_license_permit.dart';
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/providers/utils/functions/capitalize.dart';
import 'package:upn_financiero_mobil/src/services/services.dart'
    show LicensePermitService, StateLicensePermitService;
import 'package:upn_financiero_mobil/src/shared/widgets/widgets.dart'
    show AppScreen, ShowLoadingIndicator, YearMonthPicker;
import 'package:intl/intl.dart';

import 'components/list_license_permit.dart';

class LicensePermitPage extends StatefulWidget {
  const LicensePermitPage({Key? key}) : super(key: key);

  @override
  State<LicensePermitPage> createState() => _LicensePermitPageState();
}

class _LicensePermitPageState extends State<LicensePermitPage> {
  DateModel dateModel = new DateModel(
      year: DateTime.now().year,
      month: DateTime.now().month,
      nameMonth: capitalize(DateFormat.MMMM('es').format(DateTime.now())));
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController _scrollController = ScrollController();
  LicensePermitService licensePermitService = LicensePermitService();
  UserPreferences userPreferences = UserPreferences();
  List<LicensePermitModel> listData = [];
  List<StateLicensePermitModel> listStateLicenPer = [];
  String? valueStateLicenPer = '';
  bool loading = false;
  int page = 1;
  int perPage = 10;
  PaginationModel pagination = new PaginationModel();
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
                  'Permisos y licencias',
                  style: GoogleFonts.montserrat(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: ColorsApp.primary),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            _widgetFilters(context),
            SizedBox(height: 12.0),
            _widgetBody(constraints, context),
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
          ListLicensePermit(
              constraints: constraints,
              listData: listData,
              loading: loading,
              onChangeList: () {
                getListData(context);
              }),
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

  void goToForm(LicensePermitModel arguments, BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FormLicensePermit(
                  arguments: arguments,
                )));
    if (result != null) {
      if (result['change'] == 'true' || result['change'] == true) {
        getListData(context);
      }
    }
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

  void getDataFilters() async {
    StateLicensePermitService stateLicensePermitModel =
        StateLicensePermitService();
    listStateLicenPer
        .add(new StateLicensePermitModel(nombre: 'Todos', idEstadoLicaPer: ''));
    setState(() {
      loading = true;
    });
    final result = await stateLicensePermitModel.getStateLicensePermit();
    listStateLicenPer.addAll(result);
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

  void getListData(BuildContext context) async {
    final Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker.toString(),
      'anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'id_estado_lica_per': valueStateLicenPer.toString(),
      'per_page': perPage.toString(),
      'page': '1'
    };
    ShowLoadingIndicator.showLoadingIndicator(
        context: context, onlyLoading: true, opacity: false);
    pagination = await licensePermitService.getLicensesPermits(params);

    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<LicensePermitModel> list = jsonList
        .map((jsonElement) => LicensePermitModel.fromJson(jsonElement))
        .toList();
    listData = list;
    if (pagination.total <= perPage) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
    page = 2;
    Navigator.pop(context);
    setState(() {});
  }

  void _onRefresh() async {
    final Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker.toString(),
      'anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'id_estado_lica_per': valueStateLicenPer.toString(),
      'per_page': perPage.toString(),
      'page': '1'
    };
    pagination = await licensePermitService.getLicensesPermits(params);

    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<LicensePermitModel> list = jsonList
        .map((jsonElement) => LicensePermitModel.fromJson(jsonElement))
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
    await getListMoreData();
  }

  Future getListMoreData() async {
    final Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker.toString(),
      'anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'id_estado_lica_per': valueStateLicenPer.toString(),
      'per_page': perPage.toString(),
      'page': page.toString()
    };
    pagination = await licensePermitService.getLicensesPermits(params);

    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;
    if (jsonList.isNotEmpty) {
      List<LicensePermitModel> list = jsonList
          .map((jsonElement) => LicensePermitModel.fromJson(jsonElement))
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
