import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/home/button_marking_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';

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
        child: Obx(
          () => Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: ColorsApp.info.withValues(alpha: 0.6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                children: [
                  // Subtitle
                  Text(
                    controller.subTitleMarking.value,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      color: ColorsApp.primary.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  // Time Display
                  Text(
                    controller.textMarking.value.toLowerCase(),
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      color: controller.colorButtonMarking,
                      fontSize: 28,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Marking Button
                  _buttonAssistanceMarking(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonAssistanceMarking() {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: ColorsApp.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 22),
          const SizedBox(width: 10),
          Text(
            capitalize(descripcionMarcacion.toLowerCase()),
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
