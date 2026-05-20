import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/controllers/license_permit/license_permit_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/shared/components/app_text.dart';
import 'package:lamb_talent/shared/components/secondary_screen.dart';

import 'components/list_license_permit.dart';

class LicensePermitPage extends StatelessWidget {
  final bool approve;
  final String title;
  const LicensePermitPage(
      {Key? key, this.approve = false, this.title = 'Permisos y licencias'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LicensePermitController>(
        init: LicensePermitController(approve: approve),
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
                  const SizedBox(height: Spacing.sm),
                  Obx(() => _widgetFilters(controller)),
                  const SizedBox(height: Spacing.sm + Spacing.xs),
                  Obx(() => _widgetBody(constraints, controller)),
                ],
              );
            }),
          );
        });
  }

  Widget _widgetFilters(LicensePermitController controller) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: ColorsApp.primary, width: 1.5),
            borderRadius: BorderRadius.circular(AppRadius.pill)),
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  controller.selectDate();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Spacing.sm, horizontal: Spacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(children: [Text('')]),
                      Row(
                        children: [
                          AppText.label(
                              '${controller.dateModel.value.nameMonth}, ${controller.dateModel.value.year}',
                              color: ColorsApp.primary),
                          const Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }

  Widget _widgetBody(
      BoxConstraints constraints, LicensePermitController controller) {
    return SizedBox(
      width: constraints.maxWidth,
      child: Column(
        children: [
          controller.loadingDataInit.value
              ? ListLicensePermit(
                  approve: approve,
                  constraints: constraints,
                  listData: controller.listData,
                  onChangeList: () {
                    controller.changeApprove = true;
                    controller.getListData();
                  },
                  isJefeArea: controller.isJefeArea.value,
                  isDth: controller.isDth.value)
              : Container(),
        ],
      ),
    );
  }
}
