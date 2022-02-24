import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/controllers/notification/event_detail_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';

class EventDetail extends StatelessWidget {
  final String id;
  final bool loadBack;
  const EventDetail({Key? key, required this.id, this.loadBack = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventDetailController>(
        init: EventDetailController(id: id),
        didUpdateWidget: (_, _stateBuilder) {
          _stateBuilder.controller!.onInit();
        },
        builder: (controller) {
          return AppScreen(
            codePage: '16120104',
            principalPage: false,
            refreshController: controller.refreshController,
            scrollController: controller.scrollController,
            enablePullDown: true,
            enablePullUp: false,
            showTabs: false,
            onRefresh: controller.onRefresh,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Obx(() => !controller.loadingData.value
                  ? Column(
                      children: [
                        const SizedBox(height: 8.0),
                        AppBar(
                          centerTitle: true,
                          leading: Transform.translate(
                            offset: const Offset(-15, -8),
                            child: IconButton(
                              onPressed: () {
                                controller.goToBack(loadBack);
                              },
                              iconSize: 40,
                              icon: const Icon(Icons.chevron_left,
                                  color: ColorsApp.primary),
                            ),
                          ),
                          elevation: 0,
                          backgroundColor: Colors.white,
                          toolbarHeight: 40.0,
                          title: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Detalle del evento',
                              style: GoogleFonts.montserrat(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                  color: ColorsApp.primary),
                            ),
                          ),
                        ),
                        _cardEventPrincipal(controller),
                        _cardEventDetail(controller),
                        const SizedBox(height: 50.0)
                      ],
                    )
                  : Container());
            }),
            floatingActionButton: Obx(() => controller.buttonAssitance.value
                ? Container(
                    width: 100,
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () {
                          controller.registerAssistance();
                        },
                        style: ButtonStyle(
                          alignment: Alignment.center,
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return ColorsApp
                                  .success; // Use the component's default.
                            },
                          ),
                          shape: MaterialStateProperty.resolveWith<
                              RoundedRectangleBorder>(
                            (Set<MaterialState> states) {
                              return RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      25)); // Use the component's default.
                            },
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: const [
                              Icon(Icons.check, color: Colors.white),
                              Text(
                                'Asistir',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )),
                  )
                : Container()),
          );
        });
  }

  Widget _cardEventPrincipal(EventDetailController controller) {
    final month =
        capitalize(DateFormat.MMM('es').format(controller.event.fechaInicio!));
    final monthAbbreviation = month.substring(0, month.length - 1);
    List<Widget> groupsWidget = [];
    for (var val in controller.listGroups) {
      groupsWidget.add(Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: ColorsApp.primary),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 4.0, bottom: 4.0, right: 8.0, left: 8.0),
          child: Text(val.nombre.toString(),
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  color: ColorsApp.white,
                  fontSize: 14.0)),
        ),
      ));
    }
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              controller.event.imagenUrl != null && !controller.event.imagenUrl!.contains('empty')
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: controller.event.imagenUrl.toString(),
                        placeholder: (context, url) => Container(),
                        errorWidget: (context, url, error) {
                          return Container();
                        },
                      ),
                    )
                  : Container(),
              Padding(
                padding:
                    const EdgeInsets.only(right: 12.0, left: 12.0, top: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.event.showFechaHora == '1'
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(monthAbbreviation,
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 25.0)),
                              Text(controller.event.fechaInicio!.day.toString(),
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 25.0))
                            ],
                          )
                        : Container(),
                    const SizedBox(width: 12.0),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.event.nombre.toString(),
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400, fontSize: 16.0)),
                          controller.event.showFechaHora == '1'
                              ? Text(
                                  DateFormat.MMMMd('es').format(
                                          controller.event.fechaInicio!) +
                                      ' ' +
                                      Jiffy(
                                              controller.event.fechaInicio
                                                  .toString(),
                                              'yyyy-MM-dd HH:mm')
                                          .format('hh:mm a'),
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0))
                              : Container(),
                          const SizedBox(height: 8.0),
                          Row(
                            children: groupsWidget,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardEventDetail(EventDetailController controller) {
    return SizedBox(
        width: double.infinity,
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.date_range),
                        const SizedBox(width: 8.0),
                        Text(DateFormat.MMMMd('es')
                                .format(controller.event.fechaInicio!) +
                            ' a las ' +
                            Jiffy(controller.event.fechaInicio.toString(),
                                    'yyyy-MM-dd HH:mm')
                                .format('hh:mm a'))
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.location_on),
                        const SizedBox(width: 8.0),
                        Text(controller.event.lugar.toString())
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    controller.event.informacion != null &&
                            controller.event.informacion!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text('Información',
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0)),
                          )
                        : Container(),
                    controller.event.informacion != null &&
                            controller.event.informacion!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(controller.event.informacion.toString(),
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0)),
                          )
                        : Container(),
                    controller.event.archivoUrl != null &&
                            controller.event.archivoUrl!.isNotEmpty
                        ? GestureDetector(
                            child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  color: ColorsApp.info),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        color: ColorsApp.danger),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0,
                                          bottom: 0,
                                          right: 16.0,
                                          left: 16.0),
                                      child: Text('PDF'.toString(),
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w400,
                                              color: ColorsApp.white,
                                              fontSize: 20.0)),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4.0,
                                          bottom: 4.0,
                                          right: 8.0,
                                          left: 8.0),
                                      child: Text(
                                          controller.event.archivoName
                                              .toString(),
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w400,
                                              color: ColorsApp.white,
                                              fontSize: 14.0),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              controller.goToLinkUrl(
                                  controller.event.archivoUrl.toString());
                            },
                          )
                        : Container()
                  ],
                ))));
  }
}
