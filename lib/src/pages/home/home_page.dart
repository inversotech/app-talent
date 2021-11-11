import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/models.dart'
    show
        ApiResponse,
        AssistanceSummaryModel,
        HolidayModel,
        JustificationModel,
        LicensePermitModel;
import 'package:upn_financiero_mobil/src/pages/holiday/holiday_page.dart';
import 'package:upn_financiero_mobil/src/pages/justification/components/form_justification.dart';
import 'package:upn_financiero_mobil/src/pages/justification/justification_page.dart';
import 'package:upn_financiero_mobil/src/pages/license_permit/components/form_license_permit.dart';
import 'package:upn_financiero_mobil/src/pages/license_permit/license_permit_page.dart';
import 'package:upn_financiero_mobil/src/pages/markings/my_markings_page.dart';
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/providers/utils/functions/capitalize.dart';
import 'package:upn_financiero_mobil/src/services/services.dart'
    show AssistanceSummaryService, MarkingService;
import 'package:intl/intl.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/widgets.dart'
    show AppScreen, ShowLoadingIndicator;

import 'components/carousel_slider_item.dart';
import 'components/list_schedule.dart';
import 'components/sign.dart';
import 'components/time_dynamic.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocationData? currentLocation;
  Location location = new Location();
  MarkingService markingProvider = new MarkingService();
  UserPreferences userPreferences = UserPreferences();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController _scrollController = ScrollController();
  CarouselController _controllerCarousel = CarouselController();
  String showButton = '0';
  String textButton = '';
  String codeModality = '';
  String insidePolygon = '0';
  String namePolygon = '';
  String idDescripMarcacion = '';
  String hourMarking = '';
  int minutosTolerancia = 0;
  GlobalKey chart = GlobalKey();
  bool loading = false;
  List<AssistanceSummaryModel> listData = [];
  bool chartInit = false;
  Map<String, dynamic> chartData = {};
  Map<String, dynamic> dataCarousel = {};
  List<dynamic> series = [];
  @override
  initState() {
    super.initState();
    _listAllData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return AppScreen(
      initialIndex: 0,
      principalPage: true,
      refreshController: _refreshController,
      scrollController: _scrollController,
      enablePullDown: true,
      enablePullUp: false,
      showTabs: true,
      onRefresh: _onRefresh,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: [
              Column(
                children: [
                  _widgetAssistance(context),
                  _widgetSlider(constraints),
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
      ),
    );
  }

  Widget _widgetAssistance(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Card(
        margin: EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Column(
          children: [
            showButton == '1' && hourMarking.isNotEmpty
                ? MarkingWidget(
                    onPressed: () {
                      markingAssistance(context);
                    },
                    hourMarking: hourMarking,
                    minutosTolerancia: minutosTolerancia,
                    descripcionMarcacion: textButton,
                    idDescripcionMarcacion: idDescripMarcacion,
                  )
                : Container(),
            Padding(
              padding:
                  const EdgeInsets.only(left: 12.0, right: 12.0, top: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        showModalSchedule(context, DateTime.now());
                      },
                      child: Image.asset('assets/icons/datetime.png',
                          height: 35, width: 35, color: ColorsApp.primary)),
                  Flexible(
                    child: Column(
                      children: [
                        showButton == '1' && hourMarking.isNotEmpty
                            ? Container()
                            : SizedBox(height: 35.0),
                        Text(
                          'Asistencia',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600, fontSize: 25.0),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyMarkingsPage()));
                      },
                      child: Image.asset('assets/icons/search.png',
                          height: 35, width: 35, color: ColorsApp.primary)),
                ],
              ),
            ),
            _createChartPie(),
            SizedBox(
              height: 8.0,
            ),
          ],
        ),
      ),
    );
  }

  CarouselSlider _widgetSlider(BoxConstraints constraints) {
    return CarouselSlider(
        items: [
          CarouselSliderItem(
            title: 'Justificaciones',
            indexItem: 0,
            itemCount: 3,
            textButton: [
              Image.asset('assets/icons/edit.png',
                  height: 30, width: 30, color: Colors.white),
              Text(
                'solicitar justificación',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w400, color: Colors.white),
              )
            ],
            detail: dataCarousel.containsKey('justificacion')
                ? dataCarousel['justificacion']
                : [],
            constraints: constraints,
            onPressedList: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => JustificationPage()));
            },
            onPressedRequest: () {
              goToFormJustification(new JustificationModel());
            },
          ),
          CarouselSliderItem(
            title: 'Permisos y licencias',
            indexItem: 1,
            itemCount: 3,
            textButton: [
              Image.asset('assets/icons/edit.png',
                  height: 30, width: 30, color: Colors.white),
              Text(
                'solicitar permiso',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w400, color: Colors.white),
              )
            ],
            detail: dataCarousel.containsKey('licenciapermiso')
                ? dataCarousel['licenciapermiso']
                : [],
            constraints: constraints,
            onPressedList: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LicensePermitPage()));
            },
            onPressedRequest: () {
              goToFormLicenPerm(new LicensePermitModel());
            },
          ),
          CarouselSliderItem(
            title: 'Vacaciones',
            indexItem: 2,
            itemCount: 3,
            textButton: [
              dataCarousel.containsKey('vacacion')
                  ? dataCarousel['vacacion'].containsKey('descripcion')
                      ? Text(dataCarousel['vacacion']['descripcion'].toString(),
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400, color: Colors.white),
                          textAlign: TextAlign.center)
                      : Text(
                          '...',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400, color: Colors.white),
                        )
                  : Text(
                      '...',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400, color: Colors.white),
                    )
            ],
            constraints: constraints,
            onPressedList: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HolidayPage()));
            },
            onPressedRequest: () async {
              if (dataCarousel.containsKey('vacacion')) {
                if (dataCarousel['vacacion']['codigo'].toString() == '01' ||
                    dataCarousel['vacacion']['codigo'].toString() == '02') {
                  HolidayModel vacacion =
                      dataCarousel['vacacion']['vacacion'] as HolidayModel;
                  String type = vacacion.inihabilitar == '1'
                      ? 'S'
                      : vacacion.finhabilitar == '1'
                          ? 'R'
                          : '';
                  bool sign = await showModalSSign(context, vacacion, type);
                  if (sign) {
                    setState(() {
                      loading = true;
                    });
                    await _getListDataAndChart();
                    _refreshController.loadNoData();
                    setState(() {
                      loading = false;
                    });
                  }
                }
              }
            },
          )
        ],
        carouselController: _controllerCarousel,
        options: CarouselOptions(
          height: 175,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: false,
          scrollDirection: Axis.horizontal,
        ));
  }

  Widget _createChartPie() {
    listData.sort((a, b) => b.code.compareTo(a.code));
    return SfCircularChart(
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
            widget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(DateFormat('dd').format(DateTime.now()),
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        color: ColorsApp.primary,
                        fontSize: 25)),
                Text(capitalize(DateFormat.MMMM('es').format(DateTime.now())),
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        color: ColorsApp.primary,
                        fontSize: 12)),
              ],
            ),
          )
        ],
        legend: Legend(
            alignment: ChartAlignment.center,
            isResponsive: true,
            padding: 2.0,
            itemPadding: 8.0,
            textStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 10.0,
                color: ColorsApp.primary),
            position: LegendPosition.bottom,
            overflowMode: LegendItemOverflowMode.wrap,
            isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <RadialBarSeries<AssistanceSummaryModel, String>>[
          RadialBarSeries<AssistanceSummaryModel, String>(
              cornerStyle: CornerStyle.bothCurve,
              legendIconType: LegendIconType.circle,
              radius: '100%',
              gap: '2%',
              innerRadius: '40%',
              dataSource: listData,
              xValueMapper: (AssistanceSummaryModel data, _) =>
                  capitalize(data.nombre),
              yValueMapper: (AssistanceSummaryModel data, _) => data.cantidad,
              dataLabelMapper: (AssistanceSummaryModel data, _) =>
                  data.cantidad.toString(),
              pointColorMapper: (AssistanceSummaryModel data, _) =>
                  _colorAssistance(data.code),
              dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  textStyle:
                      GoogleFonts.montserrat(fontWeight: FontWeight.w400))),
        ]);
  }

  Color _colorAssistance(String code) {
    Color color = Colors.black12;
    switch (code) {
      case '01':
        color = ColorsApp.success;
        break;
      case '02':
        color = ColorsApp.primary;
        break;
      case '03':
        color = ColorsApp.warning;
        break;
      case '04':
        color = ColorsApp.danger;
        break;
      default:
        color = Colors.black12;
        break;
    }
    return color;
  }

  Future _verifyButtonAssistance() async {
    // a tener en cuenta el loading button
    var _serviceEnabled = await location.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }

    var _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }
    if (_serviceEnabled && _permissionGranted == PermissionStatus.granted) {
      currentLocation = await location.getLocation();
    }
    Map<String, String> params = {
      'lng':
          currentLocation != null ? currentLocation!.longitude.toString() : '0',
      'lat':
          currentLocation != null ? currentLocation!.latitude.toString() : '0',
    };
    final response = await markingProvider.showButtonAssistance(params);
    if (response.success) {
      showButton = response.data['show_button'] ?? '0';
      textButton = response.data['text_button'] ?? '';
      codeModality = response.data['code_modality'] ?? '';
      idDescripMarcacion = response.data['id_descrip_marcacion'] ?? '';
      hourMarking = response.data['fecha_hora'] ?? '';
      minutosTolerancia = response.data['minutos_tolerancia'] != null
          ? int.parse(response.data['minutos_tolerancia'].toString())
          : 0;
    }
  }

  void goToFormJustification(JustificationModel arguments) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FormJustification(
                  arguments: arguments,
                )));
    if (result != null) {
      if (result['change'] == 'true' || result['change'] == true) {
        setState(() {
          loading = true;
        });
        await _getListData();
        setState(() {
          loading = false;
        });
      }
    }
  }

  void goToFormLicenPerm(LicensePermitModel arguments) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FormLicensePermit(
                  arguments: arguments,
                )));
    if (result != null) {
      if (result['change'] == 'true' || result['change'] == true) {
        setState(() {
          loading = true;
        });
        await _getListData();
        setState(() {
          loading = false;
        });
      }
    }
  }

  void markingAssistance(BuildContext context) async {
    ShowLoadingIndicator.showLoadingIndicator(
        text: 'Guardando ...', context: context);
    final MarkingService markingProvider = new MarkingService();
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

    String uuid = '';
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      uuid = androidInfo.androidId; //UUID for Android
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      uuid = iosInfo.identifierForVendor; //UUID for iOS
    }

    var _serviceEnabled = await location.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }

    var _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }
    if (_serviceEnabled && _permissionGranted == PermissionStatus.granted) {
      currentLocation = await location.getLocation();
    }
    Map<String, String> params = {
      'uuid': uuid,
      'lng':
          currentLocation != null ? currentLocation!.longitude.toString() : '0',
      'lat':
          currentLocation != null ? currentLocation!.latitude.toString() : '0',
      'codigo_modalidad': codeModality.toString(),
      'id_descrip_marcacion': idDescripMarcacion.toString()
    };
    final marking = await markingProvider.workerMarking(params);
    Navigator.pop(context);
    if (marking.success) {
      if (!mounted) return;
      setState(() {
        loading = true;
      });
      await _verifyButtonAssistance();
      await _getListDataAndChart();
      setState(() {
        loading = false;
      });
    }
  }

  Future _getListDataAndChart() async {
    final Map<String, String> params = {
      'id_anho': DateTime.now().year.toString(),
      'id_mes': DateTime.now().month.toString(),
      'incluir_chart_data': '1'
    };
    AssistanceSummaryService assistanceSummaryService =
        AssistanceSummaryService();
    ApiResponse resp =
        await assistanceSummaryService.getAssistanceSummary(params);
    if (resp.success) {
      dataCarousel = resp.data;
      if (dataCarousel.containsKey('chart_data')) {
        List<dynamic> jsonList = resp.data['chart_data'] as List;
        List<AssistanceSummaryModel> list = jsonList
            .map((jsonElement) => AssistanceSummaryModel.fromJson(jsonElement))
            .toList();
        listData = list;
      }
    } else {
      dataCarousel = {};
    }
  }

/*   Future _getListDataChart() async {
    final Map<String, String> params = {
      'id_anho': DateTime.now().year.toString(),
      'id_mes': DateTime.now().month.toString()
    };
    AssistanceSummaryService assistanceSummaryService =
        AssistanceSummaryService();
    listData = await assistanceSummaryService.getAssistanceSummaryChart(params);
  }
 */
  Future _getListData() async {
    AssistanceSummaryService assistanceSummaryService =
        AssistanceSummaryService();
    ApiResponse resp = await assistanceSummaryService.getAssistanceSummary({});
    if (resp.success) {
      dataCarousel = resp.data;
    } else {
      dataCarousel = {};
    }
  }

  void _listAllData() async {
    setState(() {
      loading = true;
    });
    await _verifyButtonAssistance();
    await _getListDataAndChart();
    if (!mounted) return;
    _refreshController.loadNoData();
    setState(() {
      loading = false;
    });
  }

  void _onRefresh() async {
    await _verifyButtonAssistance();
    await _getListDataAndChart();
    if (!mounted) return;
    _refreshController.refreshCompleted();
    _refreshController.loadNoData();
    setState(() {});
  }
}
