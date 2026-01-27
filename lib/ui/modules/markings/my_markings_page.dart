import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/ui/modules/markings/components/list_markings.dart';
import 'package:lamb_talent/controllers/markings/marking_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/shared/components/secondary_screen.dart';

class MyMarkingsPage extends StatelessWidget {
  MyMarkingsPage({Key? key}) : super(key: key);

  final controller = Get.put(MarkingController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarkingController>(
        init: MarkingController(),
        didUpdateWidget: (_, stateBuilder) {
          stateBuilder.controller!.onInit();
        },
        builder: (_) {
          return SecondaryScreen(
            title: 'Marcaciones',
            refreshController: controller.refreshController,
            scrollController: controller.scrollController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(children: [
                  const SizedBox(height: 8.0),
                  Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: ColorsApp.primary, width: 1.5),
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 12.0),
                        child: Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      if (controller.selectOption.value == 4) {
                                        controller.selectMonthYear();
                                      } else if (controller
                                              .selectOption.value ==
                                          5) {
                                        controller.selectDate();
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        controller.selectOptionTitle.value
                                                    .isNotEmpty &&
                                                controller.selectOption.value >
                                                    3
                                            ? const Icon(Icons.arrow_drop_down)
                                            : Container(),
                                        Text(
                                          controller.selectOptionTitle.value,
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w400,
                                              color: ColorsApp.primary),
                                        ),
                                      ],
                                    )),
                                InkWell(
                                    onTap: () {
                                      controller.bottomOptions();
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                            controller.getOptionName(
                                                controller.selectOption.value),
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w400,
                                                color: ColorsApp.primary)),
                                        const Icon(Icons.arrow_drop_down)
                                      ],
                                    )),
                              ],
                            )),
                      )),
                  const SizedBox(height: 12.0),
                  Obx(() => Column(
                        children: [
                          controller.loadingDataInit.value
                              ? ListMarking(
                                  constraints: constraints,
                                  listData: controller.listData,
                                  onPressed: (arguments) {})
                              : Container(),
                        ],
                      )),
                ]),
              );
            }),
          );
        });
  }
}
