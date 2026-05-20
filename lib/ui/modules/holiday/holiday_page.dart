import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/controllers/holiday/holiday_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/shared/components/app_button.dart';
import 'package:lamb_talent/shared/components/app_text.dart';
import 'package:lamb_talent/shared/components/secondary_screen.dart';

import 'components/list_holiday.dart';

class HolidayPage extends StatelessWidget {
  const HolidayPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HolidayController>(
        init: HolidayController(),
        didUpdateWidget: (_, stateBuilder) {
          stateBuilder.controller!.onInit();
        },
        builder: (controller) {
          return SecondaryScreen(
              title: 'Vacaciones',
              scrollController: controller.scrollController,
              enablePullDown: false,
              enablePullUp: false,
              floatingActionButton: Obx(() => controller
                              .idEstadoVacTrab.value !=
                          '02' &&
                      controller.isDth.value &&
                      controller.listData.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Material(
                                color: ColorsApp.warning,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.pill),
                                child: InkWell(
                                  onTap: () {
                                    _showModalAnularRefuse(
                                        context, '03', 'Observar', controller);
                                  },
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.pill),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Spacing.md,
                                        vertical: Spacing.sm),
                                    child: Text('Observar',
                                        style: TextStyle(
                                            color: ColorsApp.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Material(
                                color: ColorsApp.success,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.pill),
                                child: InkWell(
                                  onTap: () {
                                    _showModalApprove(
                                        context, '02', controller);
                                  },
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.pill),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Spacing.md,
                                        vertical: Spacing.sm),
                                    child: Text('Aprobar',
                                        style: TextStyle(
                                            color: ColorsApp.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            )
                          ]),
                    )
                  : Container()),
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  children: [
                    const SizedBox(height: Spacing.sm),
                    Container(
                      width: 140,
                      decoration: BoxDecoration(
                          color: ColorsApp.primary,
                          border: Border.all(color: ColorsApp.primary),
                          borderRadius: BorderRadius.circular(AppRadius.pill)),
                      padding:
                          const EdgeInsets.symmetric(horizontal: Spacing.sm),
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
                                    height: 30,
                                    width: 30,
                                    color: ColorsApp.white),
                                const SizedBox(width: Spacing.sm),
                                Obx(() => AppText.body(
                                      controller.selectYear.toString(),
                                      color: ColorsApp.white,
                                    )),
                                const Icon(Icons.arrow_drop_down,
                                    color: ColorsApp.white)
                              ],
                            ),
                          )),
                    ),
                    const SizedBox(height: Spacing.sm + Spacing.xs),
                    Obx(() => Column(
                          children: [
                            controller.loadingDataInit.value
                                ? ListHoliday(
                                    constraints: constraints,
                                    listData: controller.listData)
                                : Container(),
                            controller.listData.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 40.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: Spacing.sm),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: Spacing.sm),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                AppText.labelLarge(
                                                  'Total días programados',
                                                  color: ColorsApp.primary,
                                                ),
                                                AppText.labelLarge(
                                                  controller.totalPro.value
                                                      .toString(),
                                                  color: ColorsApp.primary,
                                                )
                                              ]),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: Spacing.sm),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                AppText.labelLarge(
                                                  'Total días gozados',
                                                  color: ColorsApp.primary,
                                                ),
                                                AppText.labelLarge(
                                                  controller.totalGo.value
                                                      .toString(),
                                                  color: ColorsApp.primary,
                                                )
                                              ]),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        )),
                  ],
                );
              }));
        });
  }

  void _showModalApprove(BuildContext context, String idEstado,
      HolidayController controller) async {
    await Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          elevation: 0,
          backgroundColor: ColorsApp.neutral200,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm)),
          titlePadding: EdgeInsets.zero,
          scrollable: true,
          titleTextStyle: const TextStyle(
              color: ColorsApp.primary,
              fontWeight: FontWeight.bold,
              fontSize: FontSizes.xl),
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: Spacing.sm),
              child: Text(('Aprobar').toUpperCase()),
            ),
          ),
          content: Column(children: [
            Image.asset('assets/icons/check.png',
                height: 50, width: 50, color: ColorsApp.success),
            AppText.body(
                '¿Desea aprobar la vacación programada de: ${controller.userPreferences.fullnamePerson}?',
                color: ColorsApp.primary,
                textAlign: TextAlign.center)
          ]),
          actions: [
            AppButton.outlined(
                text: 'Cerrar', onPressed: () => Get.back()),
            AppButton.primary(
              text: 'Estoy de acuerdo!',
              onPressed: () {
                controller.changeRequestStatus(context, '', idEstado);
              },
            )
          ],
        ));

    /*  await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: ColorsApp.neutral200,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            titlePadding: EdgeInsets.zero,
            scrollable: true,
            titleTextStyle: GoogleFonts.montserrat(
                color: ColorsApp.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18),
            title: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(('Aprobar').toUpperCase()),
              ),
            ),
            content: Column(children: [
              Image.asset('assets/icons/check.png',
                  height: 50, width: 50, color: ColorsApp.success),
              Text(
                  '¿Desea aprobar la vacación programada de: ${controller.userPreferences.fullnamePerson}?',
                  style: GoogleFonts.montserrat(
                      color: ColorsApp.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                  textAlign: TextAlign.center)
            ]),
            actions: [
              TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return ColorsApp
                            .primaryVariant; // Use the component's default.
                      },
                    ),
                    shape: MaterialStateProperty.resolveWith<
                        RoundedRectangleBorder>(
                      (Set<MaterialState> states) {
                        return RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25)); // Use the component's default.
                      },
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Cerrar',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () => Navigator.of(context).pop()),
              TextButton(
                style: ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return ColorsApp.success; // Use the component's default.
                    },
                  ),
                  shape:
                      MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                    (Set<MaterialState> states) {
                      return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              25)); // Use the component's default.
                    },
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Estoy de acuerdo!',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                onPressed: () {
                  controller.changeRequestStatus(context, '', idEstado);
                },
              )
            ],
          );
        }); */
  }

  void _showModalAnularRefuse(BuildContext context, String idEstado,
      String text, HolidayController controller) async {
    TextEditingController inputFieldCtrl = TextEditingController();
    await Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          elevation: 0,
          backgroundColor: ColorsApp.neutral200,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm)),
          titlePadding: EdgeInsets.zero,
          scrollable: true,
          titleTextStyle: const TextStyle(
              color: ColorsApp.primary,
              fontWeight: FontWeight.bold,
              fontSize: FontSizes.xl),
          title: Center(
              child: Padding(
            padding: const EdgeInsets.only(top: Spacing.sm),
            child: Text(text.toUpperCase()),
          )),
          content: TextFormField(
            controller: inputFieldCtrl,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm)),
              labelText: 'Comentario (opcional)',
            ),
            maxLines: 4,
            keyboardType: TextInputType.multiline,
          ),
          actions: [
            AppButton.outlined(
                text: 'Cerrar', onPressed: () => Get.back()),
            AppButton.primary(
              text: text,
              onPressed: () {
                controller.changeRequestStatus(
                    context,
                    inputFieldCtrl.value.text.isNotEmpty
                        ? inputFieldCtrl.value.text
                        : '',
                    idEstado);
              },
            )
          ],
        ));

    /* await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          TextEditingController inputFieldCtrl = TextEditingController();
          return AlertDialog(
            elevation: 0,
            backgroundColor: ColorsApp.neutral200,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            titlePadding: EdgeInsets.zero,
            scrollable: true,
            titleTextStyle: GoogleFonts.montserrat(
                color: ColorsApp.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18),
            title: Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(text.toUpperCase()),
            )),
            content: TextFormField(
              controller: inputFieldCtrl,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                labelText: 'Comentario (opcional)',
              ),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),
            actions: [
              TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return ColorsApp
                            .primaryVariant; // Use the component's default.
                      },
                    ),
                    shape: MaterialStateProperty.resolveWith<
                        RoundedRectangleBorder>(
                      (Set<MaterialState> states) {
                        return RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25)); // Use the component's default.
                      },
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Cerrar',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () => Navigator.of(context).pop()),
              TextButton(
                style: ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return ColorsApp
                          .primaryVariant; // Use the component's default.
                    },
                  ),
                  shape:
                      MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                    (Set<MaterialState> states) {
                      return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              25)); // Use the component's default.
                    },
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(text,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                onPressed: () {
                  controller.changeRequestStatus(
                      context,
                      inputFieldCtrl.value.text.isNotEmpty
                          ? inputFieldCtrl.value.text
                          : '',
                      idEstado);
                },
              )
            ],
          );
        }); */
  }

  void _selectYearPicker(
      BuildContext buildContext, HolidayController controller) async {
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
