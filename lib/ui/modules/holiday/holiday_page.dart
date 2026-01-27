import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/holiday/holiday_controller.dart';
import 'package:lamb_talent/core/colors.dart';
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
                              child: TextButton(
                                style: ButtonStyle(
                                  alignment: Alignment.center,
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      return ColorsApp
                                          .warning; // Use the component's default.
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text('Observar',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                                onPressed: () {
                                  _showModalAnularRefuse(
                                      context, '03', 'Observar', controller);
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: TextButton(
                                style: ButtonStyle(
                                  alignment: Alignment.center,
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      return ColorsApp
                                          .success; // Use the component's default.
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text('Aprobar',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                                onPressed: () {
                                  _showModalApprove(context, '02', controller);
                                },
                              ),
                            )
                          ]),
                    )
                  : Container()),
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  children: [
                    const SizedBox(height: 8.0),
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
                                        const SizedBox(height: 8.0),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Total días programados',
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: ColorsApp.primary),
                                                ),
                                                Text(
                                                  controller.totalPro.value
                                                      .toString(),
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: ColorsApp.primary),
                                                )
                                              ]),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Total días gozados',
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: ColorsApp.primary),
                                                ),
                                                Text(
                                                  controller.totalGo.value
                                                      .toString(),
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: ColorsApp.primary),
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
          backgroundColor: ColorsApp.info,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
                  child: Text('Cerrar',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                onPressed: () => Get.back()
                // Navigator.of(context).pop()
                ),
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
        ));

    /*  await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: ColorsApp.info,
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
          backgroundColor: ColorsApp.info,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
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
                  child: Text('Cerrar',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                onPressed: () => Get.back()
                // Navigator.of(context).pop() by pedro
                ),
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
        ));

    /* await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          TextEditingController inputFieldCtrl = TextEditingController();
          return AlertDialog(
            elevation: 0,
            backgroundColor: ColorsApp.info,
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
