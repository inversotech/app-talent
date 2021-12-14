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
                    Container(
                      width: 140,
                      decoration: BoxDecoration(
                          color: ColorsApp.primary,
                          border: Border.all(color: ColorsApp.primary),
                          borderRadius: BorderRadius.circular(25.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: InkWell(
                          onTap: () {
                            _selectYearPicker(context, controller);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/icons/calendar.png',
                                    height: 30, width: 30, color: Colors.white),
                                const SizedBox(width: 8.0),
                                Obx(() => Text(
                                      controller.selectYear.toString(),
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    )),
                                const Icon(Icons.arrow_drop_down,
                                    color: Colors.white)
                              ],
                            ),
                          )),
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
                  idAnho: controller.selectYear.toString(),
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

  void _selectYearPicker(
      BuildContext buildContext, HolidayApproveController controller) async {
    final dialog = await showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Seleccionar año"),
          content: SizedBox(
            // Need to use container to add size constraint.
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(DateTime.now().year + 100, 1),
              initialDate: DateTime.now(),
              // save the selected date to _selectedDate DateTime variable.
              // It's used to set the previous selected date when
              // re-showing the dialog.
              selectedDate: DateTime(controller.selectYear.value, 1, 1),
              onChanged: (DateTime dateTime) {
                // close the dialog when year is selected.
                Navigator.of(context).pop(dateTime);

                // Do something with the dateTime selected.
                // Remember that you need to use dateTime.year to get the year
              },
            ),
          ),
        );
      },
    );
    if (dialog != null) {
      controller.selectYear.value = dialog.year;
      controller.getListData();
    }
  }
}
