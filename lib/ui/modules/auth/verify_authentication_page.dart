import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/auth/verify_authentication_controller.dart';
import 'package:lamb_talent/core/colors.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ColorsApp.primary, ColorsApp.primaryVariant],
            ),
          ),
          child: GetBuilder<VerifyAutheticationController>(
            init: VerifyAutheticationController(),
            builder: (_) => Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                      child: CircularProgressIndicator(color: ColorsApp.white)),
                  const SizedBox(
                    height: 8,
                  ),
                  Text('Verificando...',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500, color: ColorsApp.white))
                ],
              ),
            )),
          )),
    );
  }
}
