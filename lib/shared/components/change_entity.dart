import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/general/change_entity_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/shared/components/app_button.dart';
import 'package:select_form_field/select_form_field.dart';

void showModalChangeEntity(BuildContext buildContext) async {
  await showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (context) {
        return const ChangeEntity();
      });
}

class ChangeEntity extends StatelessWidget {
  const ChangeEntity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangeEntityController>(
        init: ChangeEntityController(),
        builder: (controller) {
          return AlertDialog(
              elevation: 0,
              backgroundColor: ColorsApp.neutral200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg)),
              title: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    icon: Image.asset('assets/icons/close.png',
                        height: 40, width: 40, color: ColorsApp.primary),
                    onPressed: () => Navigator.of(context).pop()),
              ),
              contentPadding: const EdgeInsets.all(Spacing.sm),
              titlePadding: EdgeInsets.zero,
              scrollable: false,
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: Spacing.sm),
                    child: Obx(() => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cambiar mi entidad y departamento',
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w700,
                                    color: ColorsApp.primary,
                                    fontSize: 16.0)),
                            const SizedBox(height: Spacing.lg),
                            controller.loadingEntities.value
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(Spacing.md),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : SelectFormField(
                                    decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(AppRadius.pill)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: Spacing.xl,
                                                vertical: Spacing.md),
                                        labelText: 'Entidad',
                                        labelStyle: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w500,
                                            color: ColorsApp.primary),
                                        suffixIcon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: ColorsApp.primary)),
                                    type: SelectFormFieldType.dialog,
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w600,
                                        color: ColorsApp.primary),
                                    controller: controller.inputFieldEntity,
                                    changeIcon: true,
                                    dialogTitle: 'Seleccionar',
                                    dialogCancelBtn: 'Cancelar',
                                    enableSearch: false,
                                    dialogSearchHint: 'Buscar',
                                    items: controller.listMyEntities,
                                    onChanged: (val) async {
                                      controller.fnGetDeptos(val.toString());
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Campo requerido.';
                                      }
                                      return null;
                                    },
                                  ),
                            const SizedBox(height: Spacing.md),
                            controller.loadingDeptos.value
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(Spacing.md),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : controller.listMyEntities.isNotEmpty
                                    ? SelectFormField(
                                        decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        50.0)),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 30.0,
                                                    vertical: 12.0),
                                            labelText: 'Departamento',
                                            labelStyle: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w500,
                                                color: ColorsApp.primary),
                                            suffixIcon: const Icon(
                                                Icons.arrow_drop_down,
                                                color: ColorsApp.primary)),
                                        type: SelectFormFieldType.dialog,
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w600,
                                            color: ColorsApp.primary),
                                        controller: controller.inputFieldDepto,
                                        changeIcon: true,
                                        dialogTitle: 'Seleccionar',
                                        dialogCancelBtn: 'Cancelar',
                                        enableSearch: false,
                                        dialogSearchHint: 'Buscar',
                                        items: controller.listMyDeptos,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Campo requerido.';
                                          }
                                          return null;
                                        },
                                      )
                                    : Container(),
                            const SizedBox(height: Spacing.md),
                            Container(
                              alignment: Alignment.center,
                              child: AppButton.primary(
                                text: 'Guardar',
                                icon: Icons.save,
                                onPressed: () {
                                  controller.saveNewEntityDepto(context);
                                },
                              ),
                            ),
                            const SizedBox(height: Spacing.md),
                          ],
                        )),
                  ),
                ),
              ));
        });
  }
}
