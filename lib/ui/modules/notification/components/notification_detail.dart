import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/controllers/notification/notification_detail_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';
import 'package:video_player/video_player.dart';

class NotificationDetail extends StatelessWidget {
  final String id;
  final bool loadBack;
  const NotificationDetail({Key? key, required this.id, this.loadBack = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationDetailController>(
        init: NotificationDetailController(id: id),
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
                              'Detalle de la notificación',
                              style: GoogleFonts.montserrat(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                  color: ColorsApp.primary),
                            ),
                          ),
                        ),
                        _cardEventPrincipal(controller),
                        _cardEventDetail(controller),
                      ],
                    )
                  : Container());
            }),
          );
        });
  }

  Widget _cardEventPrincipal(NotificationDetailController controller) {
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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: groupsWidget,
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      controller.notification.fecha != null
                          ? DateFormat.MMMMd('es')
                              .format(controller.notification.fecha!)
                          : '',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500, fontSize: 16.0)),
                  Text(
                      controller.notification.fecha != null
                          ? Jiffy.parse(controller.notification.fecha.toString(),
                                  pattern: 'yyyy-MM-dd HH:mm')
                              .format(pattern: 'hh:mm a')
                          : '',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400, fontSize: 12.0)),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(controller.notification.mensaje.toString(),
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400, fontSize: 16.0)),
              const SizedBox(height: 8.0),
              controller.notification.imagenUrl != null &&
                      !controller.notification.imagenUrl!.contains('empty')
                  ? ClipRRect(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: controller.notification.imagenUrl.toString(),
                        placeholder: (context, url) => Container(),
                        errorWidget: (context, url, error) {
                          return Container();
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardEventDetail(NotificationDetailController controller) {
    return SizedBox(
        width: double.infinity,
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.notification.addArchivo != null &&
                            controller.notification.addArchivo == '1' &&
                            controller.notification.archivoUrl != null &&
                            controller.notification.archivoUrl!.isNotEmpty
                        ? InkWell(
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
                                          controller.notification.archivoName
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
                              controller.goToLinkUrl(controller
                                  .notification.archivoUrl
                                  .toString());
                            },
                          )
                        : Container(),
                    controller.notification.addLink != null &&
                            controller.notification.addLink == '1' &&
                            controller.notification.link != null &&
                            controller.notification.link!.isNotEmpty
                        ? Row(
                            children: [
                              const Icon(Icons.link),
                              TextButton(
                                  onPressed: () {
                                    controller.goToLinkUrl(controller
                                        .notification.link
                                        .toString());
                                  },
                                  child: Text('Ingresar a ver el enlace',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                          color: ColorsApp.primary,
                                          fontSize: 14.0)))
                            ],
                          )
                        : Container(),
                    controller.notification.addVideo != null &&
                            controller.notification.addVideo == '1' &&
                            controller.notification.videoUrl != null &&
                            controller.notification.videoUrl!.isNotEmpty
                        ? Row(
                            children: [
                              const Icon(Icons.videocam),
                              TextButton(
                                  onPressed: () {
                                    controller.goToLinkUrl(controller
                                        .notification.videoUrl
                                        .toString());
                                  },
                                  child: Text('Ingresar a ver el video',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                          color: ColorsApp.primary,
                                          fontSize: 14.0)))
                            ],
                          )
                        : Container(),
                  ],
                ))));
  }
}

// ignore: unused_element
class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const _exampleCaptionOffsets = [
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration(milliseconds: 0),
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (context) {
              return [
                for (final offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return [
                for (final speed in _examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
