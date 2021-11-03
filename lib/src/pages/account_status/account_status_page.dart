import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:upn_financiero_mobil/src/models/models.dart' show DateModel;
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/providers/utils/functions/capitalize.dart';
import 'package:upn_financiero_mobil/src/services/account_status/account_status_service.dart';
import 'package:upn_financiero_mobil/src/shared/components/components.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/widgets.dart'
    show AppScreen, ToastCustom, YearMonthPicker;
import 'package:intl/intl.dart';

import 'components/carousel_slider_item.dart';
import 'components/deposited_help_travel.dart';
import 'components/deposited_salary.dart';
import 'components/detail.dart';

class AccountStatusPage extends StatefulWidget {
  const AccountStatusPage({Key? key}) : super(key: key);

  @override
  State<AccountStatusPage> createState() => _AccountStatusPageState();
}

class _AccountStatusPageState extends State<AccountStatusPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController _scrollController = ScrollController();
  CarouselController _controllerCarousel = CarouselController();
  bool loading = false;
  DateModel _dateModel = new DateModel(
      year: DateTime.now().year,
      month: DateTime.now().month,
      nameMonth: capitalize(DateFormat.MMMM('es').format(DateTime.now())));
  int selectSlider = 0;
  AccountStatusService _accountStatusService = new AccountStatusService();
  UserPreferences _userPreferences = new UserPreferences();
  Map? dataDetail;
  List listDataDetail = [];
  String urlBoleta = '';
  Map dataGeneral = {};
  @override
  void initState() {
    super.initState();
    _listData();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      initialIndex: 1,
      principalPage: true,
      refreshController: _refreshController,
      scrollController: _scrollController,
      enablePullDown: true,
      enablePullUp: false,
      showTabs: true,
      onRefresh: _onRefresh,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            Column(
              children: [
                CarouselSlider(
                    items: [
                      CarouselSliderItem(
                        showBoleta: true,
                        title: 'Sueldo',
                        titleContinue: 'depositado',
                        amount: dataGeneral.containsKey('sueldo_depositado')
                            ? dataGeneral['sueldo_depositado'].toString()
                            : '0',
                        dateModel: _dateModel,
                        indexItem: 0,
                        itemCount: 5,
                        onPressed: () {
                          _getTicketPayment(context);
                        },
                        onPressedDate: () {
                          _selectDate(context);
                        },
                      ),
                      CarouselSliderItem(
                        title: 'Ayudas',
                        titleContinue: 'depositado',
                        amount: dataGeneral.containsKey('ayudas')
                            ? (double.parse(dataGeneral['ayudas'].toString()) >
                                    0
                                ? dataGeneral['ayudas'].toString()
                                : (dataGeneral.containsKey('ayudas_saldo')
                                    ? dataGeneral['ayudas_saldo'].toString()
                                    : '0'))
                            : '0',
                        dateModel: _dateModel,
                        indexItem: 1,
                        itemCount: 5,
                        onPressed: () {
                          _getTicketPayment(context);
                        },
                        onPressedDate: () {
                          _selectDate(context);
                        },
                      ),
                      CarouselSliderItem(
                        title: 'Viajes',
                        titleContinue: 'depositado',
                        amount: dataGeneral.containsKey('viajes')
                            ? (double.parse(dataGeneral['viajes'].toString()) >
                                    0
                                ? dataGeneral['viajes'].toString()
                                : (dataGeneral.containsKey('viajes_saldo')
                                    ? dataGeneral['viajes_saldo'].toString()
                                    : '0'))
                            : '0',
                        dateModel: _dateModel,
                        indexItem: 2,
                        itemCount: 5,
                        onPressed: () {
                          _getTicketPayment(context);
                        },
                        onPressedDate: () {
                          _selectDate(context);
                        },
                      ),
                      CarouselSliderItem(
                        title: 'Convenios',
                        titleContinue: 'personales',
                        amount: dataGeneral.containsKey('adelanto_ayudas')
                            ? dataGeneral['adelanto_ayudas'].toString()
                            : '0',
                        dateModel: _dateModel,
                        indexItem: 3,
                        itemCount: 5,
                        onPressed: () {
                          _getTicketPayment(context);
                        },
                        onPressedDate: () {
                          _selectDate(context);
                        },
                      ),
                      CarouselSliderItem(
                        title: 'A rendir',
                        amount: dataGeneral.containsKey('a_rendir')
                            ? dataGeneral['a_rendir'].toString()
                            : '0',
                        dateModel: _dateModel,
                        indexItem: 4,
                        itemCount: 5,
                        onPressed: () {
                          _getTicketPayment(context);
                        },
                        onPressedDate: () {
                          _selectDate(context);
                        },
                      )
                    ],
                    carouselController: _controllerCarousel,
                    options: CarouselOptions(
                      onPageChanged:
                          (val, CarouselPageChangedReason reason) async {
                        selectSlider = val;
                        loading = true;
                        setState(() {});
                        await _listDataDetail();
                        setState(() {
                          loading = false;
                        });
                      },
                      height: 260,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      scrollDirection: Axis.horizontal,
                    )),
                _bodySlect()
              ],
            ),
            if (loading) ...[
              Positioned(
                  left: 0,
                  top: 100,
                  child: Container(
                    width: constraints.maxWidth,
                    height: 80,
                    child: Center(child: CircularProgressIndicator()),
                  ))
            ]
          ],
        );
      }),
    );
  }

  Widget _bodySlect() {
    Widget widgetResp = Container();
    switch (selectSlider) {
      case 0:
        widgetResp = DepositedSalary(
          dateModel: _dateModel,
          data: dataDetail,
          onChange: (val) {
            loading = val;
            setState(() {});
          },
        );
        break;
      case 1:
        widgetResp = DepositedHelpTravel(
          code: 'help',
          dateModel: _dateModel,
          onChange: (val) {
            loading = val;
            setState(() {});
          },
          data: dataDetail,
          title: 'Ayudas depositado',
        );
        break;
      case 2:
        widgetResp = DepositedHelpTravel(
          code: 'travel',
          dateModel: _dateModel,
          onChange: (val) {
            loading = val;
            setState(() {});
          },
          data: dataDetail,
          title: 'Viajes depositado',
        );
        break;
      case 3:
        widgetResp = Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: Detail(
                listData: listDataDetail,
                isModal: false,
                title: 'Convenios personales'),
          ),
        );
        break;
      case 4:
        widgetResp = Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: Detail(
                listData: listDataDetail, isModal: false, title: 'A rendir'),
          ),
        );
        break;
      default:
        widgetResp = Container();
    }
    return widgetResp;
  }

  void _selectDate(BuildContext context) async {
    final dateResult = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return YearMonthPicker(
              selectedDate: DateTime(_dateModel.year, _dateModel.month, 1));
        });
    if (dateResult != null) {
      _dateModel.month = int.parse(DateFormat.M().format(dateResult));
      _dateModel.nameMonth =
          capitalize(DateFormat.MMMM('es').format(dateResult));
      _dateModel.year = int.parse(DateFormat.y().format(dateResult));
      _listData();
      // Navigator.pushReplacementNamed(context, 'login');
    }
  }

  Future _getTicketPayment(BuildContext context) async {
    setState(() {
      loading = true;
    });
    final Map<String, String> params = {
      'id_anho': _dateModel.year.toString(),
      'id_mes': _dateModel.month.toString(),
      'id_entidad': _userPreferences.idEntity.toString(),
    };
    final listTicketsPayment =
        await _accountStatusService.gePaymentstTicket(params);
    if (listTicketsPayment.length == 1) {
      final fileName = listTicketsPayment[0].archivo;
      final clave = listTicketsPayment[0].clave.toString();
      urlBoleta = listTicketsPayment[0].urls.toString() + '?type=S&p=' + clave;
      final file = await _accountStatusService.createFileOfPdfUrl(
          urlBoleta, fileName.toString());
      setState(() {
        loading = false;
      });
      if (file.path.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFScreen(
                clave: clave,
                file: file,
                showDownload: true,
                path: file.path,
                titlePdf: fileName.toString()),
          ),
        );
      } else {
        ToastCustom()
            .warningContext(context: context, message: 'Ocurrió un error al abrir la boleta', time: 8);
      }
    } else if (listTicketsPayment.length == 0) {
      ToastCustom().warningContext(context: context,
          message: 'No se encontró boleta del mes ' + _dateModel.nameMonth,
          time: 8);
      setState(() {
        loading = false;
      });
    }
  }

  Future _listDataGeneral() async {
    final String params = 'p_id_entidad=' +
        _userPreferences.idEntity.toString() +
        ';p_id_anho=' +
        _dateModel.year.toString() +
        ';p_id_mes=' +
        _dateModel.month.toString() +
        ';p_id_persona=' +
        _userPreferences.idPerson.toString() +
        ';p_id_cta_cte=' +
        _userPreferences.nroDocument.toString();
    dataGeneral = await _accountStatusService.getAccountStatus(params);
  }

  Future _listDataDetail() async {
    final Map<String, String> params = {
      'id_entidad': _userPreferences.idEntity.toString(),
      'id_anho': _dateModel.year.toString(),
      'id_mes': _dateModel.month.toString(),
    };
    switch (selectSlider) {
      case 0:
        params['id_cta_cte'] = _userPreferences.nroDocument.toString();
        params['id_persona'] = _userPreferences.idPerson.toString();
        dataDetail = await _accountStatusService.getItems(params);
        break;
      case 1:
        dataDetail = {
          'ingresos': dataGeneral.containsKey('ayudas_ingresos')
              ? dataGeneral['ayudas_ingresos']
              : '0',
          'descuentos': dataGeneral.containsKey('ayudas_descuentos')
              ? dataGeneral['ayudas_descuentos']
              : '0',
          'sub_total':
              dataGeneral.containsKey('ayudas') ? dataGeneral['ayudas'] : '0',
          'total': dataGeneral.containsKey('ayudas_saldo')
              ? dataGeneral['ayudas_saldo']
              : '0'
        };
        break;
      case 2:
        dataDetail = {
          'ingresos': dataGeneral.containsKey('viajes_ingresos')
              ? dataGeneral['viajes_ingresos']
              : '0',
          'descuentos': dataGeneral.containsKey('viajes_descuentos')
              ? dataGeneral['viajes_descuentos']
              : '0',
          'sub_total':
              dataGeneral.containsKey('viajes') ? dataGeneral['viajes'] : '0',
          'total': dataGeneral.containsKey('viajes_saldo')
              ? dataGeneral['viajes_saldo']
              : '0'
        };
        break;
      case 3:
        params['id_cuentaaasi'] = '1135061';
        params['id_cta_cte'] = _userPreferences.nroDocument.toString();
        dataDetail = await _accountStatusService.getDetailsAccount(params);
        final resp = await _accountStatusService.getDetailsAccount(params);
        List detail = [];
        Map data = {};
        if (resp != null) {
          data = resp as Map;
          if (data.containsKey('total') && data.containsKey('items')) {
            detail.add({
              'title': 'Total ingresos',
              'total': data['total'],
              'items': data['items']
            });
          } else {
            detail.add({'title': 'Total ingresos', 'total': '0', 'items': []});
          }
        }
        listDataDetail = detail;
        break;
      case 4:
        params['id_cuentaaasi'] = '1135007';
        params['id_cta_cte'] = _userPreferences.nroDocument.toString();
        final resp = await _accountStatusService.getDetailsAccount(params);
        List detail = [];
        Map data = {};
        if (resp != null) {
          data = resp as Map;
          if (data.containsKey('total') && data.containsKey('items')) {
            detail.add({
              'title': 'Total ingresos',
              'total': data['total'],
              'items': data['items']
            });
          } else {
            detail.add({'title': 'Total ingresos', 'total': '0', 'items': []});
          }
        }
        listDataDetail = detail;
        break;
      default:
    }
  }

  void _listData() async {
    setState(() {
      loading = true;
    });
    await _listDataGeneral();
    await _listDataDetail();
    setState(() {
      loading = false;
    });
  }

  void _onRefresh() async {
    await _listDataGeneral();
    // await _listDataDetail();
    _refreshController.refreshCompleted();
    _refreshController.loadNoData();
    setState(() {});
  }
}
