import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/general/change_entity_controller.dart';
import 'package:lamb_talent/core/colors.dart';
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
              backgroundColor: ColorsApp.info,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              title: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    icon: Image.asset('assets/icons/close.png',
                        height: 40, width: 40, color: ColorsApp.primary),
                    onPressed: () => Navigator.of(context).pop()),
              ),
              contentPadding: const EdgeInsets.all(8.0),
              titlePadding: EdgeInsets.zero,
              scrollable: false,
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Obx(() => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cambiar mi entidad y departamento',
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w700,
                                    color: ColorsApp.primary,
                                    fontSize: 16.0)),
                            const SizedBox(height: 24.0),
                            controller.loadingEntities.value
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : SelectFormField(
                                    decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 30.0,
                                                vertical: 12.0),
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
                            const SizedBox(height: 16.0),
                            controller.loadingDeptos.value
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
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
                            const SizedBox(height: 12.0),
                            Container(
                              alignment: Alignment.center,
                              child: TextButton(
                                  onPressed: () {
                                    controller.saveNewEntityDepto(context);
                                  },
                                  style: ButtonStyle(
                                    alignment: Alignment.center,
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/icons/save.png',
                                            height: 30,
                                            width: 30,
                                            color: Colors.white),
                                        const Text(
                                          'Guardar',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            const SizedBox(height: 12.0),
                          ],
                        )),
                  ),
                ),
              ));
        });
  }
}
