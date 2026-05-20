import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/home/home_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

void showModalQr() async {
  final controller = Get.put(HomeController());

  Get.dialog(
      AlertDialog(
          elevation: 0,
          backgroundColor: ColorsApp.neutral200,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          title: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: Image.asset('assets/icons/close.png',
                    height: 40, width: 40, color: ColorsApp.primary),
                onPressed: () => Get.back()),
          ),
          contentPadding: const EdgeInsets.all(8.0),
          titlePadding: EdgeInsets.zero,
          scrollable: false,
          content: SizedBox(
            width: Get.width,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /* Text(
                      userPreferences.nroDocument.toString(),
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        color: ColorsApp.primary,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ), */
                    TextFormField(
                      enabled: true,
                      // textAlignVertical: TextAlignVertical.center,
                      initialValue: controller.numDocument.toString(),
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          labelStyle: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              color: ColorsApp.primary),
                          labelText: 'N° Documento',
                          suffixIcon: InkWell(
                            onTap: () {
                              if (controller.numDocument.value.isNotEmpty) {
                                controller.numDocQr.value =
                                    controller.numDocument.value;
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, right: 2),
                              child: Text(
                                'Generar',
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.0),
                              ),
                            )

                            /* const Icon(Icons.qr_code,
                                color: ColorsApp.primary) */
                            ,
                          )),
                      style: GoogleFonts.montserrat(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: ColorsApp.primary),
                      onSaved: (val) {},
                      onChanged: (val) {
                        controller.numDocument.value = val.toString();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo requerido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8.0),
                    const Divider(height: 1, color: ColorsApp.primary),
                    const SizedBox(height: 8.0),
                    const SizedBox(height: 12.0),
                    Obx(() => controller.numDocQr.isNotEmpty
                        ? QrImageView(
                            data: controller.numDocQr.toString(),
                            version: QrVersions.auto,
                            size: 320,
                            gapless: false,
                          )
                        : Container())
                  ],
                ),
              ),
            ),
          )),
      barrierDismissible: true);
}
