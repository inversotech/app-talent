import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/controllers/holiday/holiday_approve_controller.dart';
import 'package:lamb_talent/shared/components/secondary_screen.dart';

import 'components/list_holiday_approve.dart';

class HolidayApprovePage extends StatelessWidget {
  const HolidayApprovePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HolidayApproveController>(
        init: HolidayApproveController(),
        didUpdateWidget: (_, stateBuilder) {
          stateBuilder.controller!.onInit();
        },
        builder: (controller) {
          return SecondaryScreen(
              title: 'Aprobar vacaciones',
              refreshController: controller.refreshController,
              scrollController: controller.scrollController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: controller.onRefresh,
              onLoading: controller.onLoading,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  children: [
                    const SizedBox(height: 8.0),
                    Obx(() => _widgetBody(constraints, controller)),
                  ],
                );
              }));
        });
  }

  Widget _widgetBody(
      BoxConstraints constraints, HolidayApproveController controller) {
    return SizedBox(
      width: constraints.maxWidth,
      child: Column(
        children: [
          controller.loadingDataInit.value
              ? ListHolidayApprove(
                  constraints: constraints,
                  listData: controller.listData,
                  isDth: controller.isDth.value,
                  changeRequestStatus: (buildContext, text, idEstado, idWorker,
                      idPeriodoVacTrab) {
                    controller.changeRequestStatus(buildContext, text, idEstado,
                        idWorker, idPeriodoVacTrab);
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}
