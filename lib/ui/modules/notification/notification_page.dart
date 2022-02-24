import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/notification/notification_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';

import 'components/list_notification.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({Key? key}) : super(key: key);

  final controller = Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
        init: NotificationController(),
        didUpdateWidget: (_, _stateBuilder) {
          _stateBuilder.controller!.onInit();
        },
        builder: (_) {
          return AppScreen(
            codePage: '16120104',
            principalPage: true,
            refreshController: controller.refreshController,
            scrollController: controller.scrollController,
            enablePullDown: true,
            enablePullUp: false,
            showTabs: true,
            onRefresh: controller.onRefresh,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Obx(() => Column(
                    children: [
                      controller.loadingData.value &&
                              controller.listData.isNotEmpty
                          ? ListNotification(
                              constraints: constraints,
                              listData: controller.listData,
                              onPressed: (arguments) {
                                controller.goToDetail(arguments);
                              },
                              onPressedLike: (arguments) {
                                controller.fnSaveLike(arguments);
                              },
                              onPressedComment: (arguments) {
                                controller.goToComents(arguments);
                              },
                              onPressedShare: (arguments) {
                                controller.shareFileImage(arguments);
                              })
                          : controller.loadingData.value &&
                                  controller.listData.isEmpty
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
                  ));
            }),
          );
        });
  }
}
