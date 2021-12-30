import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/justification/justification_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';

import 'components/list_justification.dart';

class JustificationPage extends StatelessWidget {
  final bool approve;
  final String title;
  const JustificationPage(
      {Key? key, this.approve = false, this.title = 'Justificaciones'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JustificationController>(
      init: JustificationController(approve: approve),
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
            showTabs: true,
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
                        onPressed: controller.goToBack,
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
                        title,
                        style: GoogleFonts.montserrat(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            color: ColorsApp.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Obx(() => _widgetFilters(controller)),
                  const SizedBox(height: 8.0),
                  Obx(() => _widgetBody(constraints, controller))
                ],
              );
            }));
      },
    );
  }

  Widget _widgetFilters(JustificationController controller) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: ColorsApp.primary, width: 1.5),
            borderRadius: BorderRadius.circular(25.0)),
        child: Column(children: [
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
                        children: const [
                          Text(''),
                        ],
                      ),
                      Row(children: [
                        Text(
                          controller.dateModel.value.nameMonth +
                              ', ' +
                              controller.dateModel.value.year.toString(),
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              color: ColorsApp.primary),
                        ),
                        const Icon(Icons.arrow_drop_down)
                      ])
                    ]),
              ))
        ]));
  }

  Widget _widgetBody(
      BoxConstraints constraints, JustificationController controller) {
    return SizedBox(
      width: constraints.maxWidth,
      child: Column(
        children: [
          controller.loadingDataInit.value
              ? ListJustification(
                  approve: approve,
                  constraints: constraints,
                  listData: controller.listData,
                  onPressed: (arguments) {
                    controller.goToForm(arguments);
                  },
                  onChangeList: () {
                    controller.changeApprove = true;
                    controller.getListData();
                  },
                  isJefeArea: controller.isJefeArea.value,
                  isDth: controller.isDth.value,
                )
              : Container(),
        ],
      ),
    );
  }
}
