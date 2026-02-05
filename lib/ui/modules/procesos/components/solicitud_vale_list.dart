import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/shared/components/secondary_screen.dart';

class SolicitudValeList extends StatelessWidget {
  SolicitudValeList({super.key});

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SecondaryScreen(
      title: 'Solicitudes de Vale',
      scrollController: scrollController,
      enablePullDown: false,
      enablePullUp: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            children: [
              const Icon(Icons.receipt_outlined, size: 64, color: ColorsApp.info),
              const SizedBox(height: 16),
              Text(
                'Próximamente',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: ColorsApp.control,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Esta sección está en desarrollo',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: ColorsApp.control,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
