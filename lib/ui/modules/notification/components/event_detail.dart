import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/controllers/notification/event_detail_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/enviroment/enviroment.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';
import 'package:lamb_talent/shared/components/expanded_text.dart';

class EventDetail extends StatelessWidget {
  final String id;
  final bool loadBack;
  final String token;
  const EventDetail(
      {Key? key, required this.id, this.loadBack = false, required this.token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventDetailController>(
        init: EventDetailController(id: id),
        didUpdateWidget: (_, stateBuilder) {
          stateBuilder.controller!.onInit();
        },
        builder: (controller) {
          return AppScreen(
            codePage: '16120104',
            principalPage: false,
            refreshController: controller.refreshController,
            scrollController: controller.scrollController,
            enablePullDown: true,
            enablePullUp: false,
            showTabs: true,
            onRefresh: controller.onRefresh,
            paddingBottom: 4,
            paddingLeft: 4,
            paddingRight: 4,
            paddingTop: 4,
            backgroundColor: Colors.transparent,
            floatingActionButton: Obx(() => controller.buttonAssitance.value &&
                    !controller.userPreferences.isWorkerChild
                ? Container(
                    width: 120,
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
                                  .danger; // Use the component's default.
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
                              Icon(Icons.check, color: Colors.white, size: 30),
                              Text(
                                'Asistir',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )),
                  )
                : Container()),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Obx(() => !controller.loadingData.value
                  ? Column(
                      children: [
                        Container(
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              controller.goToBack(loadBack);
                            },
                            child: const Icon(Icons.chevron_left,
                                color: ColorsApp.primary, size: 40),
                          ),
                        ),
                        _cardEventPrincipal(controller),
                        const SizedBox(height: 4.0),
                        _cardEventDetail(controller),
                        const SizedBox(height: 50.0)
                      ],
                    )
                  : Container());
            }),
          );
        });
  }

  Widget _cardEventPrincipal(EventDetailController controller) {
    return Container(
      color: ColorsApp.white,
      child: Column(
        children: [
          controller.event.imagenUrl!.isNotEmpty &&
                  !controller.event.imagenUrl!.contains('empty')
              ? GestureDetector(
                  child: controller.event.imagenUrl!.contains('http')
                      ? CachedNetworkImage(
                          imageUrl: controller.event.imagenUrl.toString(),
                          placeholder: (context, url) => Container(),
                          errorWidget: (context, url, error) {
                            return Container();
                          },
                        )
                      : CachedNetworkImage(
                          imageUrl: Env.api.apiMessengerShell.toString() +
                              'storage/file?fileName='.toString() +
                              controller.event.imagenUrl.toString(),
                          httpHeaders: {'Authorization': token},
                          placeholder: (context, url) => Container(),
                          errorWidget: (context, url, error) {
                            return Container();
                          },
                        ),
                  onTap: () {
                    controller.showPhoto(controller.event.imagenUrl.toString());
                  },
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: ColorsApp.primary,
                  radius: 25,
                  child: Text(controller.event.nombreEntidad!.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          color: ColorsApp.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0)),
                ),
                const SizedBox(width: 12.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${capitalize(DateFormat.EEEE('es').format(controller.event.fechaInicio!).substring(0, 3))}, ${DateFormat.d('es').format(controller.event.fechaInicio!)} de ${capitalize(DateFormat.MMM('es').format(controller.event.fechaInicio!))} a las ${Jiffy.parse(controller.event.fechaInicio.toString(), pattern: 'yyyy-MM-dd HH:mm').format(pattern: 'hh:mm a').toLowerCase()}',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400, fontSize: 14.0)),
                      ExpandableText(
                        text: controller.event.nombre.toString(),
                        style: GoogleFonts.montserrat(
                            color: ColorsApp.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0),
                        trimLines: 2,
                        trimCollapsedText: '...más',
                        trimExpandedText: ' menos',
                        styleClickableText: GoogleFonts.montserrat(
                            color: ColorsApp.neutral500,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12.0),
        ],
      ),
    );
  }

  Widget _cardEventDetail(EventDetailController controller) {
    return Container(
        color: ColorsApp.white,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/icons/datetime.png',
                    height: 35, width: 35, color: ColorsApp.primary),
                const SizedBox(width: 8.0),
                Text(
                    '${DateFormat.MMMMd('es').format(controller.event.fechaInicio!)} a las ${Jiffy.parse(controller.event.fechaInicio.toString(), pattern: 'yyyy-MM-dd HH:mm').format(pattern: 'hh:mm a')}')
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 35),
                const SizedBox(width: 8.0),
                Text(controller.event.lugar.toString())
              ],
            ),
            const SizedBox(height: 12.0),
            controller.event.informacion != null &&
                    controller.event.informacion!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(controller.event.informacion.toString(),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400, fontSize: 14.0)),
                  )
                : Container(),
            controller.event.archivoUrl != null &&
                    controller.event.archivoUrl!.isNotEmpty
                ? GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/file.png',
                            height: 35, width: 35, color: ColorsApp.primary),
                        const SizedBox(width: 12.0),
                        Flexible(
                          child: Text('Ver pdf',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: ColorsApp.primary,
                                  fontSize: 14.0),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    onTap: () {
                      controller
                          .goToLinkUrl(controller.event.archivoUrl.toString());
                    },
                  )
                : Container(),
            controller.event.addLink != null &&
                    controller.event.addLink == '1' &&
                    controller.event.link != null &&
                    controller.event.link!.isNotEmpty
                ? GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/link.png',
                            height: 35, width: 35, color: ColorsApp.primary),
                        const SizedBox(width: 12.0),
                        Text('Ver enlace',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w400,
                                color: ColorsApp.primary,
                                fontSize: 14.0),
                            overflow: TextOverflow.ellipsis)
                      ],
                    ),
                    onTap: () {
                      controller.goToLinkUrl(controller.event.link.toString());
                    },
                  )
                : Container(),
            controller.event.addVideo != null &&
                    controller.event.addVideo == '1' &&
                    controller.event.videoUrl != null &&
                    controller.event.videoUrl!.isNotEmpty
                ? GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/video.png',
                            height: 35, width: 35, color: ColorsApp.primary),
                        const SizedBox(width: 12.0),
                        Text('Ver video',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w400,
                                color: ColorsApp.primary,
                                fontSize: 14.0),
                            overflow: TextOverflow.ellipsis)
                      ],
                    ),
                    onTap: () {
                      controller
                          .goToLinkUrl(controller.event.videoUrl.toString());
                    })
                : Container(),
          ],
        ));
  }
}
