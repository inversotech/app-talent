import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import 'package:lamb_talent/controllers/home/home_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/resources/models/assistance/assistance_summary.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';

import 'components/carousel_slider_item.dart';
import 'components/time_dynamic.dart';

/// Códigos de estado de vacaciones
class VacationCodes {
  static const String startingSoon = '04';
  static const String endingSoon = '03';
  static const String noVacation = '05';
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      didUpdateWidget: (_, stateBuilder) {
        stateBuilder.controller!.onInit();
      },
      builder: (_) {
        return Obx(() => !controller.loadingData.value
            ? AppScreen(
                codePage: '16120101',
                principalPage: true,
                refreshController: controller.refreshController,
                scrollController: controller.scrollController,
                enablePullDown: true,
                enablePullUp: false,
                showTabs: true,
                onRefresh: controller.onRefresh,
                leftBeforeBackground: 0,
                rightBeforeBackground: 0,
                bottomBeforeBackground: 0,
                child: LayoutBuilder(builder:
                    (BuildContext layoutContext, BoxConstraints constraints) {
                  return Column(
                    children: [
                      _widgetAssistance(),
                      _widgetSlider(constraints, context),
                    ],
                  );
                }),
              )
            : const SizedBox.shrink());
      },
    );
  }

  Widget _widgetAssistance() {
    final theme = Theme.of(Get.context!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        color: theme.colorScheme.surfaceContainerLowest,
        child: Column(
          children: [
            // Marking Widget Section
            if (controller.showButton.value == '1' &&
                controller.hourMarking.value.isNotEmpty &&
                controller.loadingData.value == false &&
                !controller.userPreferences.isWorkerChild)
              MarkingWidget(
                onPressed: () {
                  controller.markingAssistance();
                },
                hourMarking: controller.hourMarking.value,
                minutosTolerancia: controller.minutosTolerancia.value,
                descripcionMarcacion: controller.textButton.value,
                idDescripcionMarcacion: controller.idDescripMarcacion.value,
              ),

            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Column(
                children: [
                  // Action Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Schedule Button
                      IconButton.filledTonal(
                        onPressed: () {
                          controller.fnShowModalSchedule();
                        },
                        icon: const Icon(Icons.calendar_month_outlined),
                        style: IconButton.styleFrom(
                          backgroundColor:
                              ColorsApp.info.withValues(alpha: 0.3),
                          foregroundColor: ColorsApp.primary,
                        ),
                      ),
                      // QR Button
                      FilledButton.tonal(
                        onPressed: () {
                          controller.fnShowModalQr();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              ColorsApp.info.withValues(alpha: 0.3),
                          foregroundColor: ColorsApp.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.qr_code_2, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Ver QR',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // List Button
                      IconButton.filledTonal(
                        onPressed: () {
                          controller.goToMarkings();
                        },
                        icon: const Icon(Icons.format_list_numbered_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor:
                              ColorsApp.info.withValues(alpha: 0.3),
                          foregroundColor: ColorsApp.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  // Title
                  Text(
                    'Asistencia',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: ColorsApp.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Chart Section
            Obx(() => _createChartPie()),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _widgetSlider(BoxConstraints constraints, BuildContext buildContext) {
    if (controller.loadingData.value) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Indicadores fijos
        Obx(() => Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(4, (index) {
                  final isActive = index == controller.carouselIndex.value;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            )),
        // Carrusel
        CarouselSlider(
          items: [
            _buildJustificationSlider(constraints),
            _buildLicensePermitSlider(constraints),
            _buildVacationSlider(constraints, buildContext),
            _buildOvertimeSlider(constraints),
          ],
          carouselController: controller.controllerCarousel,
          options: CarouselOptions(
            height: 267,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              controller.carouselIndex.value = index;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildJustificationSlider(BoxConstraints constraints) {
    return CarouselSliderItem(
      cantidadAprobar: _getCarouselCount('justificacion'),
      showButtonRequest: !controller.userPreferences.isWorkerChild,
      title: 'Justificaciones',
      indexItem: 0,
      itemCount: 4,
      textButton: [
        Icon(Icons.edit_note_rounded, size: 20, color: ColorsApp.primary),
        const SizedBox(width: 8),
        Text(
          'Solicitar justificación',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            color: ColorsApp.primary,
            fontSize: 13,
          ),
        ),
      ],
      detail: _getCarouselList('justificacion'),
      constraints: constraints,
      onPressedList: controller.goToJustification,
      onPressedRequest: controller.goToFormJustification,
      onPressedNotify: controller.goToJustificationApprove,
    );
  }

  Widget _buildLicensePermitSlider(BoxConstraints constraints) {
    return CarouselSliderItem(
      cantidadAprobar: _getCarouselCount('licenciapermiso'),
      showButtonRequest: !controller.userPreferences.isWorkerChild,
      title: 'Permisos y licencias',
      indexItem: 1,
      itemCount: 4,
      textButton: [
        Icon(Icons.assignment_outlined, size: 20, color: ColorsApp.primary),
        const SizedBox(width: 8),
        Text(
          'Solicitar permiso',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            color: ColorsApp.primary,
            fontSize: 13,
          ),
        ),
      ],
      detail: _getCarouselList('licenciapermiso'),
      constraints: constraints,
      onPressedList: controller.goToLicensePermit,
      onPressedRequest: controller.goToFormLicenPerm,
      onPressedNotify: controller.goToLicensePermitApprove,
    );
  }

  Widget _buildVacationSlider(
      BoxConstraints constraints, BuildContext buildContext) {
    return CarouselSliderItem(
      cantidadAprobar: _getCarouselCount('vacacion'),
      showButtonRequest: !controller.userPreferences.isWorkerChild,
      title: 'Vacaciones',
      indexItem: 2,
      itemCount: 4,
      textButton: [_buildVacationButtonText()],
      isDetailWidget: true,
      detailWidget: [_buildVacationDetail()],
      constraints: constraints,
      onPressedList: controller.goToHoliday,
      onPressedRequest: () async {
        controller.fnVacation(buildContext);
      },
      onPressedNotify: controller.goToHolidayApprove,
    );
  }

  Widget _buildOvertimeSlider(BoxConstraints constraints) {
    return CarouselSliderItem(
      cantidadAprobar: _getCarouselCount('sobretiempo'),
      showButtonRequest: !controller.userPreferences.isWorkerChild,
      title: 'Sobretiempos',
      indexItem: 3,
      itemCount: 4,
      textButton: [
        Icon(Icons.more_time_rounded, size: 20, color: ColorsApp.primary),
        const SizedBox(width: 8),
        Text(
          'Solicitar sobretiempo',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            color: ColorsApp.primary,
            fontSize: 13,
          ),
        ),
      ],
      detail: _getCarouselList('sobretiempo'),
      constraints: constraints,
      onPressedList: controller.goToOvertimes,
      onPressedRequest: controller.goToFormOvertime,
      onPressedNotify: controller.goToOvertimeApprove,
    );
  }

  int _getCarouselCount(String key) {
    if (controller.dataCarousel == null ||
        !controller.dataCarousel!.containsKey(key)) {
      return 0;
    }
    return int.parse(controller.dataCarousel![key]['total_aprobar'].toString());
  }

  dynamic _getCarouselList(String key) {
    if (controller.dataCarousel == null ||
        !controller.dataCarousel!.containsKey(key)) {
      return [];
    }
    return controller.dataCarousel![key]['lista'];
  }

  Widget _buildVacationButtonText() {
    final vacationData = controller.dataCarousel?['vacacion'];
    if (vacationData == null || vacationData.isEmpty) {
      return Text(
        '...',
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400, color: ColorsApp.primary),
      );
    }

    final descripcion = vacationData['descripcion']?.toString();
    return Text(
      descripcion ?? '...',
      style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400, color: ColorsApp.primary),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildVacationDetail() {
    final vacationData = controller.dataCarousel?['vacacion'];
    if (vacationData == null || vacationData.isEmpty) {
      return const SizedBox.shrink();
    }

    final codigo = vacationData['codigo']?.toString();
    final vacacionInfo = vacationData['vacacion'];
    if (codigo == null || vacacionInfo == null || vacacionInfo.isEmpty) {
      return const SizedBox.shrink();
    }
    final hasFechas = vacacionInfo.containsKey('fecha_ini') &&
        vacacionInfo.containsKey('fecha_fin');

    if (!hasFechas) {
      return const SizedBox.shrink();
    }

    final isCountdown = codigo == VacationCodes.startingSoon ||
        codigo == VacationCodes.endingSoon;

    if (isCountdown) {
      return _buildVacationCountdown(codigo, vacacionInfo);
    }

    if (codigo != VacationCodes.noVacation) {
      return _buildVacationDateRange(vacacionInfo);
    }

    return const SizedBox.shrink();
  }

  Widget _buildVacationCountdown(String code, dynamic vacacionInfo) {
    final isStarting = code == VacationCodes.startingSoon;
    final text = isStarting
        ? ' para salir de vacaciones'
        : ' para regresar de vacaciones';
    final dateKey = isStarting ? 'fecha_ini' : 'fecha_fin';
    final dateVacation =
        DateTime.parse(vacacionInfo[dateKey].toString()).millisecondsSinceEpoch;

    return CountdownTimer(
      endTime: dateVacation,
      onEnd: () {},
      widgetBuilder: (context, time) {
        if (time == null) {
          return const SizedBox.shrink();
        }

        final textTime = _formatCountdownTime(time);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Te quedan ',
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0),
              children: <TextSpan>[
                TextSpan(
                    text: textTime,
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0)),
                TextSpan(
                    text: ' $text',
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0)),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatCountdownTime(CurrentRemainingTime time) {
    final parts = <String>[];
    if (time.days != null) parts.add('${time.days}d');
    if (time.hours != null)
      parts.add('${time.hours.toString().padLeft(2, '0')}h');
    if (time.min != null) parts.add('${time.min.toString().padLeft(2, '0')}m');
    parts.add('${(time.sec ?? 0).toString().padLeft(2, '0')}s');
    return parts.join('-');
  }

  Widget _buildVacationDateRange(dynamic vacacionInfo) {
    final fechaIni = Jiffy.parse(vacacionInfo['fecha_ini'].toString())
        .format(pattern: 'dd-MM-yyyy');
    final fechaFin = Jiffy.parse(vacacionInfo['fecha_fin'].toString())
        .format(pattern: 'dd-MM-yyyy');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Desde ',
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w400, fontSize: 16.0, color: Colors.white),
        ),
        Text(
          fechaIni,
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, fontSize: 18.0, color: Colors.white),
        ),
        Text(
          ' hasta ',
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w400, fontSize: 16.0, color: Colors.white),
        ),
        Text(
          fechaFin,
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, fontSize: 18.0, color: Colors.white),
        ),
      ],
    );
  }

  Widget _createChartPie() {
    if (controller.loadingData.value) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 220,
      child: SfCircularChart(
        margin: EdgeInsets.zero,
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
            widget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('dd').format(DateTime.now()),
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: ColorsApp.primary,
                    fontSize: 22,
                  ),
                ),
                Text(
                  capitalize(DateFormat.MMMM('es').format(DateTime.now())),
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    color: ColorsApp.primary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          )
        ],
        legend: Legend(
          alignment: ChartAlignment.center,
          isResponsive: true,
          padding: 0,
          itemPadding: 6,
          textStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: ColorsApp.primary,
          ),
          position: LegendPosition.bottom,
          overflowMode: LegendItemOverflowMode.wrap,
          isVisible: true,
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <RadialBarSeries<AssistanceSummaryModel, String>>[
          RadialBarSeries<AssistanceSummaryModel, String>(
            cornerStyle: CornerStyle.bothCurve,
            legendIconType: LegendIconType.circle,
            radius: '85%',
            gap: '3%',
            innerRadius: '40%',
            dataSource: controller.listData,
            xValueMapper: (AssistanceSummaryModel data, _) =>
                capitalize(data.nombre),
            yValueMapper: (AssistanceSummaryModel data, _) => data.cantidad,
            dataLabelMapper: (AssistanceSummaryModel data, _) =>
                data.cantidad.toString(),
            pointColorMapper: (AssistanceSummaryModel data, _) =>
                controller.colorAssistance(data.code),
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
