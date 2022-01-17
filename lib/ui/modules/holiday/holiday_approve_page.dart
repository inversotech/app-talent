import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/holiday/holiday_approve_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';

import 'components/list_holiday_approve.dart';

class HolidayApprovePage extends StatelessWidget {
  const HolidayApprovePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HolidayApproveController>(
        init: HolidayApproveController(),
        didUpdateWidget: (_, _stateBuilder) {
          _stateBuilder.controller!.onInit();
        },
        builder: (controller) {
          return AppScreen(
              refreshController: controller.refreshController,
              scrollController: controller.scrollController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: controller.onRefresh,
              onLoading: controller.onLoading,
              initialIndex: 0,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  children: [
                    const SizedBox(height: 8.0),
                    AppBar(
                      centerTitle: true,
                      leading: Transform.translate(
                        offset: const Offset(-15, -8),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
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
                          'Aprobar vacaciones',
                          style: GoogleFonts.montserrat(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: ColorsApp.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
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
                  changeRequestStatus:
                      (buildContext, text, idEstado, idWorker,idPeriodoVacTrab) {
                    controller.changeRequestStatus(
                        buildContext, text, idEstado, idWorker,idPeriodoVacTrab);
                  },
                )
              : Container(),
        ],
      ),
    );
  }

}
