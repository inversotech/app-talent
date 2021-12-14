import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/home/button_marking_controller.dart';
import 'package:lamb_talent/core/colors.dart';

class MarkingWidget extends StatelessWidget {
  final Function() onPressed;
  final String hourMarking;
  final int minutosTolerancia;
  final String descripcionMarcacion;
  final String idDescripcionMarcacion;
  const MarkingWidget(
      {Key? key,
      required this.onPressed,
      required this.hourMarking,
      required this.minutosTolerancia,
      required this.descripcionMarcacion,
      required this.idDescripcionMarcacion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ButtonMarkingController>(
      init: ButtonMarkingController(
          hourMarking: hourMarking,
          minutosTolerancia: minutosTolerancia,
          descripcionMarcacion: descripcionMarcacion,
          idDescripcionMarcacion: idDescripcionMarcacion),
      builder: (controller) => SizedBox(
          width: double.infinity,
          child: Obx(() => Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              color: ColorsApp.info,
              child: Column(
                children: [
                  Text(controller.titleMarking.value,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: ColorsApp.primary)),
                  const SizedBox(height: 4.0),
                  Text(
                    controller.subTitleMarking.value +
                        ' ' +
                        (descripcionMarcacion.isNotEmpty
                            ? descripcionMarcacion.toLowerCase()
                            : ''),
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400, color: ColorsApp.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4.0),
                  Text(controller.textMarking.value.toLowerCase(),
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: controller.colorButtonMarking,
                          fontSize: 22.0)),
                  _buttonAssistanceMarking(),
                ],
              )))),
    );
  }

  Container _buttonAssistanceMarking() {
    return Container(
        padding: const EdgeInsets.all(12.0),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return ColorsApp.primary; // Use the component's default.
              },
            ),
            shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
              (Set<MaterialState> states) {
                return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10)); // Use the component's default.
              },
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_box_outlined, color: Colors.white),
              Text(
                'marcar asistencia',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w400, color: Colors.white),
              ),
            ],
          ),
          onPressed: () {
            onPressed();
          },
        ));
  }
}
