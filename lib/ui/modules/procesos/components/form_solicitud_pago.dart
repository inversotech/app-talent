import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/controllers/procesos/form_solicitud_pago_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/shared/components/secondary_screen.dart';

class FormSolicitudPago extends StatelessWidget {
  final SolicitudPagoModel arguments;
  FormSolicitudPago({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    final isEditable =
        arguments.estado == null || arguments.estado == 'pendiente';

    return GetBuilder<FormSolicitudPagoController>(
      init: FormSolicitudPagoController(arguments: arguments),
      builder: (controller) {
        return SecondaryScreen(
          title: arguments.id == null ? 'Nueva Solicitud' : 'Detalle Solicitud',
          scrollController: controller.scrollController,
          enablePullDown: false,
          enablePullUp: false,
          floatingActionButton: isEditable
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsApp.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        arguments.id == null ? 'Crear' : 'Actualizar',
                        style: GoogleFonts.montserrat(
                          color: ColorsApp.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              : null,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Obx(() => controller.loadingData.value
                  ? Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          _createInputDescripcion(controller, isEditable),
                          _createInputFecha(context, controller, isEditable),
                          _createDocumentos(controller, isEditable),
                          const SizedBox(height: 80),
                        ],
                      ),
                    )
                  : const SizedBox.shrink());
            },
          ),
        );
      },
    );
  }

  Widget _createInputDescripcion(
      FormSolicitudPagoController controller, bool enabled) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller.inputDescripcionCtrl,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          labelStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: ColorsApp.control,
          ),
          labelText: 'Descripción',
        ),
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: ColorsApp.primary,
        ),
        enabled: enabled,
        onSaved: (val) => controller.formData.value.descripcion = val,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Widget _createInputFecha(BuildContext context,
      FormSolicitudPagoController controller, bool enabled) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller.inputFechaCtrl,
        readOnly: true,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          labelStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: ColorsApp.control,
          ),
          labelText: 'Fecha',
          suffixIcon: const Icon(Icons.calendar_today_outlined),
        ),
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: ColorsApp.primary,
        ),
        enabled: enabled,
        onTap: () async {
          if (!enabled) return;
          final date = await showDatePicker(
            context: context,
            firstDate: DateTime(2020),
            initialDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year + 1),
          );
          if (date != null) {
            controller.inputFechaCtrl.text =
                DateFormat('dd/MM/yyyy').format(date);
            controller.formData.value.fecha =
                DateFormat('y-MM-dd').format(date);
          }
        },
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Widget _createDocumentos(
      FormSolicitudPagoController controller, bool isEditable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            'Documentos de gasto',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: ColorsApp.primary,
            ),
          ),
        ),
        ...(controller.formData.value.documentos ?? [])
            .asMap()
            .entries
            .map<Widget>((entry) {
          final index = entry.key;
          final doc = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorsApp.info.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.description_outlined,
                    color: ColorsApp.primary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.nombre ?? '',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: ColorsApp.primary,
                        ),
                      ),
                      Text(
                        '${doc.tipo ?? ''} • S/. ${doc.monto?.toStringAsFixed(2) ?? '0.00'}',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: ColorsApp.control,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isEditable)
                  IconButton(
                    onPressed: () => controller.removeDocumento(index),
                    icon:
                        const Icon(Icons.close, color: ColorsApp.danger, size: 18),
                  ),
              ],
            ),
          );
        }),
        if (isEditable)
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: controller.addDocumento,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorsApp.info, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: ColorsApp.primary, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      'Agregar documento',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: ColorsApp.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
