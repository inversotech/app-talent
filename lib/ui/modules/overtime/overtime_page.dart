import 'package:flutter/material.dart';
import 'package:lamb_talent/controllers/overtime/overtime_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/shared/components/secondary_screen.dart';
import 'package:lamb_talent/ui/modules/overtime/components/list_overtime.dart';

class OvertimePage extends StatelessWidget {
  final bool approve;
  final String title;
  const OvertimePage(
      {Key? key, this.approve = false, this.title = 'Sobretiempos'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OvertimeController>(
      init: OvertimeController(approve: approve),
      didUpdateWidget: (_, stateBuilder) {
        stateBuilder.controller!.onInit();
      },
      builder: (controller) {
        return SecondaryScreen(
            title: title,
            refreshController: controller.refreshController,
            scrollController: controller.scrollController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            onBackPressed: controller.goToBack,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: [
                  const SizedBox(height: 8.0),
                  Obx(() => _widgetFilters(controller)),
                  const SizedBox(height: 8.0),
                  Obx(() => _widgetBody(constraints, controller))
                ],
              );
            }));
      },
    );
  }

  Widget _widgetFilters(OvertimeController controller) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: ColorsApp.primary, width: 1.5),
            borderRadius: BorderRadius.circular(25.0)),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                controller.selectDate();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [Text('')],
                    ),
                    Row(
                      children: [
                        Text(
                          '${controller.dateModel.value.nameMonth},${controller.dateModel.value.year}',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              color: ColorsApp.primary),
                        ),
                        const Icon(Icons.arrow_drop_down)
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget _widgetBody(
      BoxConstraints constraints, OvertimeController controller) {
    return SizedBox(
      width: constraints.maxWidth,
      child: Column(
        children: [
          controller.loadingDataInit.value
              ? ListOvertime(
                  approve: approve,
                  constraints: constraints,
                  listData: controller.listData,
                  onPressed: (p0) {},
                  onChangeList: () {
                    controller.changeApprove = true;
                    controller.getListData();
                  },
                  isJefeArea: controller.isJefeArea.value,
                  isWorker: controller.isWorker.value,
                  isDth: controller.isDth.value,
                )
              : Container(),
        ],
      ),
    );
  }
}
