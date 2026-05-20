import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/ui/modules/markings/components/list_markings.dart';
import 'package:lamb_talent/controllers/markings/marking_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/shared/components/app_text.dart';
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
                padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                child: Column(children: [
                  const SizedBox(height: Spacing.sm),
                  Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: ColorsApp.primary, width: 1.5),
                          borderRadius:
                              BorderRadius.circular(AppRadius.pill)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Spacing.sm, horizontal: Spacing.md),
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
                                        AppText.label(
                                          controller.selectOptionTitle.value,
                                          color: ColorsApp.primary,
                                        ),
                                      ],
                                    )),
                                InkWell(
                                    onTap: () {
                                      controller.bottomOptions();
                                    },
                                    child: Row(
                                      children: [
                                        AppText.label(
                                            controller.getOptionName(
                                                controller.selectOption.value),
                                            color: ColorsApp.primary),
                                        const Icon(Icons.arrow_drop_down)
                                      ],
                                    )),
                              ],
                            )),
                      )),
                  const SizedBox(height: Spacing.sm + Spacing.xs),
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
