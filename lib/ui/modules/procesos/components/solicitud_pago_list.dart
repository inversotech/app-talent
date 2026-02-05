import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/procesos/solicitud_pago_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/shared/components/secondary_screen.dart';

class SolicitudPagoList extends StatelessWidget {
  const SolicitudPagoList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SolicitudPagoController>(
      init: SolicitudPagoController(),
      builder: (controller) {
        return SecondaryScreen(
          title: 'Solicitudes de Pago',
          refreshController: controller.refreshController,
          scrollController: controller.scrollController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: controller.onRefresh,
          onBackPressed: controller.goToBack,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => controller.goToForm(),
            backgroundColor: ColorsApp.primary,
            icon: const Icon(Icons.add, color: ColorsApp.white),
            label: Text(
              'Nueva solicitud',
              style: GoogleFonts.montserrat(
                color: ColorsApp.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          child: Obx(() => controller.loadingDataInit.value
              ? Column(
                  children: controller.listData
                      .map((item) => _buildItem(item, controller))
                      .toList(),
                )
              : const SizedBox.shrink()),
        );
      },
    );
  }

  Widget _buildItem(
      SolicitudPagoModel item, SolicitudPagoController controller) {
    final Color statusColor;
    final String statusLabel;

    switch (item.estado) {
      case 'aprobado':
        statusColor = ColorsApp.success;
        statusLabel = 'Aprobado';
        break;
      case 'rechazado':
        statusColor = ColorsApp.danger;
        statusLabel = 'Rechazado';
        break;
      default:
        statusColor = ColorsApp.warning;
        statusLabel = 'Pendiente';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsApp.info, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => controller.goToForm(item),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#${item.id}',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: ColorsApp.primary,
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        statusLabel,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.descripcion ?? '',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: ColorsApp.control,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.fecha ?? '',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: ColorsApp.control,
                      ),
                    ),
                    Text(
                      'S/. ${item.montoTotal?.toStringAsFixed(2) ?? '0.00'}',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: ColorsApp.primary,
                      ),
                    ),
                  ],
                ),
                if ((item.documentos?.length ?? 0) > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.attach_file,
                            size: 14, color: ColorsApp.control),
                        const SizedBox(width: 4),
                        Text(
                          '${item.documentos?.length} documento(s)',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: ColorsApp.control,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
