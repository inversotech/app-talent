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
      builder: (controller) => Obx(
        () => Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: controller.colorButtonMarking.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: controller.colorButtonMarking.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Fila 1: indicador + mensaje
              Text(
                controller.subTitleMarking.value,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  color: ColorsApp.neutral600,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),
              // Fila 2: hora
              Text(
                controller.textMarking.value.toLowerCase(),
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  color: controller.colorButtonMarking,
                  fontSize: 24,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 3),
              // Fila 3: botón ancho completo
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onPressed,
                  style: FilledButton.styleFrom(
                    backgroundColor: controller.colorButtonMarking,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon:
                      const Icon(Icons.check_circle_outline_rounded, size: 18),
                  label: Text(
                    capitalize(descripcionMarcacion.toLowerCase()),
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
