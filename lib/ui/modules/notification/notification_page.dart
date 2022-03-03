import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/notification/notification_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';

import 'components/list_notification.dart';

class NotificationPage extends StatelessWidget {
  final controller = Get.put(NotificationController());
  NotificationPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
        init: NotificationController(),
        didUpdateWidget: (_, _stateBuilder) {
          _stateBuilder.controller!.onInit();
        },
        builder: (_) {
          return Obx(() => controller.loadingData.value
              ? AppScreen(
                  codePage: '16120104',
                  principalPage: true,
                  refreshController: controller.refreshController,
                  scrollController: controller.scrollController,
                  enablePullDown: true,
                  enablePullUp: true,
                  showTabs: true,
                  onRefresh: controller.onRefresh,
                  onLoading: controller.onLoading,
                  colorLoading: ColorsApp.white,
                  child: Column(
                    children: [
                      controller.listData.isNotEmpty
                          ? ListNotification(
                              listData: controller.listData,
                              onPressed: (arguments) {
                                controller.goToDetail(arguments);
                              },
                              onPressedLike: (arguments, index) {
                                if (!controller.userPreferences.isWorkerChild) {
                                  controller.fnSaveLike(arguments, index);
                                }
                              },
                              onPressedComment:
                                  (arguments, autofocus, indexOrigen) {
                                controller.goToComents(
                                    arguments, autofocus, indexOrigen);
                              },
                              onPressedShare: (arguments) {
                                controller.shareFileImage(arguments);
                              },
                              onPressedLink: (link) {
                                controller.goToLinkUrl(link);
                              },
                              onPressedPhoto: (photo) {
                                controller.showPhoto(photo);
                              })
                          : controller.listData.isEmpty &&
                                  controller.finishConsults
                              ? Container(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Center(
                                      child: Column(
                                    children: [
                                      Text('No hay información para mostrar',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.0,
                                              color: ColorsApp.white)),
                                    ],
                                  )),
                                )
                              : Container(),
                    ],
                  ))
              : Container());
        });
  }
}
