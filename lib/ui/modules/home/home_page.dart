import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import 'package:lamb_talent/controllers/home/home_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/resources/models/assistance/assistance_summary.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';

import 'components/carousel_slider_item.dart';
import 'components/time_dynamic.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      didUpdateWidget: (_, _stateBuilder) {
        _stateBuilder.controller!.onInit();
      },
      builder: (_) {
        return Obx(() => !controller.loadingData.value
            ? AppScreen(
                initialIndex: 0,
                principalPage: true,
                refreshController: controller.refreshController,
                scrollController: controller.scrollController,
                enablePullDown: true,
                enablePullUp: false,
                showTabs: true,
                onRefresh: controller.onRefresh,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Column(
                      children: [
                        _widgetAssistance(),
                        _widgetSlider(constraints),
                      ],
                    );
                  }),
                ),
              )
            : Container());
      },
    );
  }

  Widget _widgetAssistance() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Card(
          margin: const EdgeInsets.all(0.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Column(
            children: [
              controller.showButton.value == '1' &&
                      controller.hourMarking.value.isNotEmpty &&
                      controller.loadingData.value == false &&
                      !controller.userPreferences.isWorkerChild
                  ? MarkingWidget(
                      onPressed: () {
                        controller.markingAssistance();
                      },
                      hourMarking: controller.hourMarking.value,
                      minutosTolerancia: controller.minutosTolerancia.value,
                      descripcionMarcacion: controller.textButton.value,
                      idDescripcionMarcacion:
                          controller.idDescripMarcacion.value,
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
                          controller.fnShowModalSchedule();
                        },
                        child: Image.asset('assets/icons/datetime.png',
                            height: 35, width: 35, color: ColorsApp.primary)),
                    Flexible(
                      child: Column(
                        children: [
                          controller.showButton.value == '1' &&
                                  controller.hourMarking.isNotEmpty
                              ? Container()
                              : const SizedBox(height: 35.0),
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
                          controller.goToMarkings();
                        },
                        child:
                            const Icon(Icons.format_list_numbered, size: 30)),
                  ],
                ),
              ),
              Obx(() => _createChartPie()),
              const SizedBox(
                height: 8.0,
              ),
            ],
          )),
    );
  }

  Widget _widgetSlider(BoxConstraints constraints) {
    return controller.loadingData.value == false
        ? CarouselSlider(
            items: [
              CarouselSliderItem(
                cantidadAprobar: controller.dataCarousel != null &&
                        controller.dataCarousel!.containsKey('justificacion')
                    ? int.parse(controller.dataCarousel!['justificacion']
                            ['total_aprobar']
                        .toString())
                    : 0,
                showButtonRequest: !controller.userPreferences.isWorkerChild,
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
                detail: controller.dataCarousel != null &&
                        controller.dataCarousel!.containsKey('justificacion')
                    ? controller.dataCarousel!['justificacion']['lista']
                    : [],
                constraints: constraints,
                onPressedList: () {
                  controller.goToJustification();
                },
                onPressedRequest: () {
                  controller.goToFormJustification();
                },
                onPressedNotify: () {
                  controller.goToJustificationApprove();
                },
              ),
              CarouselSliderItem(
                  cantidadAprobar: controller.dataCarousel != null &&
                          controller.dataCarousel!
                              .containsKey('licenciapermiso')
                      ? int.parse(controller.dataCarousel!['licenciapermiso']
                              ['total_aprobar']
                          .toString())
                      : 0,
                  showButtonRequest: !controller.userPreferences.isWorkerChild,
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
                  detail: controller.dataCarousel != null &&
                          controller.dataCarousel!
                              .containsKey('licenciapermiso')
                      ? controller.dataCarousel!['licenciapermiso']['lista']
                      : [],
                  constraints: constraints,
                  onPressedList: () {
                    controller.goToLicensePermit();
                  },
                  onPressedRequest: () {
                    controller.goToFormLicenPerm();
                  },
                  onPressedNotify: () {
                    controller.goToLicensePermitApprove();
                  }),
              CarouselSliderItem(
                  cantidadAprobar: controller.dataCarousel != null &&
                          controller.dataCarousel!.containsKey('vacacion')
                      ? int.parse(controller.dataCarousel!['vacacion']
                              ['total_aprobar']
                          .toString())
                      : 0,
                  showButtonRequest: !controller.userPreferences.isWorkerChild,
                  title: 'Vacaciones',
                  indexItem: 2,
                  itemCount: 3,
                  textButton: [
                    controller.dataCarousel != null &&
                            controller.dataCarousel!.containsKey('vacacion')
                        ? controller.dataCarousel!['vacacion']
                                .containsKey('descripcion')
                            ? Text(
                                controller.dataCarousel!['vacacion']
                                        ['descripcion']
                                    .toString(),
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                                textAlign: TextAlign.center)
                            : Text(
                                '...',
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              )
                        : Text(
                            '...',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          )
                  ],
                  constraints: constraints,
                  onPressedList: () {
                    controller.goToHoliday();
                  },
                  onPressedRequest: () async {
                    controller.fnVacation();
                  },
                  onPressedNotify: () {
                    controller.goToHolidayApprove();
                  })
            ],
            carouselController: controller.controllerCarousel,
            options: CarouselOptions(
              height: 175,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: false,
              scrollDirection: Axis.horizontal,
            ),
          )
        : Container();
  }

  Widget _createChartPie() {
    return controller.loadingData.value == false
        ? /* Container(
            child: AnimatedCircularChart(
            size: const Size(300.0, 300.0),
            initialChartData: <CircularStackEntry>[
              CircularStackEntry(
                <CircularSegmentEntry>[
                  CircularSegmentEntry(
                    0,
                    Colors.blue[400]!,
                    rankKey: 'completed',
                  ),
                  CircularSegmentEntry(
                    40,
                    Colors.blueGrey[600]!,
                    rankKey: 'remaining',
                  ),
                  CircularSegmentEntry(
                    60,
                    Colors.red[600]!,
                    rankKey: 'remaining',
                  ),
                ],
                rankKey: 'progress',
              ),
              CircularStackEntry(
                <CircularSegmentEntry>[
                  CircularSegmentEntry(
                    33.40,
                    Colors.blue[400]!,
                    rankKey: 'completed1',
                  ),
                  CircularSegmentEntry(
                    66.60,
                    Colors.blueGrey[600]!,
                    rankKey: 'remaining1',
                  ),
                ],
                rankKey: 'progress1',
              ),
            ],
            chartType: CircularChartType.Radial,
            percentageValues: true,
            holeLabel: '1/3',
            labelStyle:  TextStyle(
              color: Colors.blueGrey[600],
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ) */
        SfCircularChart(
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
                    Text(
                        capitalize(
                            DateFormat.MMMM('es').format(DateTime.now())),
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
                  dataSource: controller.listData,
                  xValueMapper: (AssistanceSummaryModel data, _) =>
                      capitalize(data.nombre),
                  yValueMapper: (AssistanceSummaryModel data, _) =>
                      data.cantidad,
                  dataLabelMapper: (AssistanceSummaryModel data, _) =>
                      data.cantidad.toString(),
                  pointColorMapper: (AssistanceSummaryModel data, _) =>
                      controller.colorAssistance(data.code),
                  dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle:
                          GoogleFonts.montserrat(fontWeight: FontWeight.w400))),
            ])
        : Container();
  }
}
