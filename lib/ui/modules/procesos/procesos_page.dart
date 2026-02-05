import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/procesos/procesos_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';

class ProcesosPage extends StatelessWidget {
  final controller = Get.put(ProcesosController());

  ProcesosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProcesosController>(
      didUpdateWidget: (_, stateBuilder) {
        stateBuilder.controller!.onInit();
      },
      builder: (_) {
        return Obx(() => controller.loadingData.value
            ? AppScreen(
                // TODO: Actualizar codePage con el código real asignado por el backend
                codePage: '16120105',
                principalPage: true,
                scrollController: controller.scrollController,
                enablePullDown: false,
                enablePullUp: false,
                showTabs: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildSectionCard(
                        title: 'Solicitud de Pago',
                        icon: Icons.payment_outlined,
                        color: ColorsApp.primary,
                        onTap: controller.goToSolicitudPago,
                      ),
                      const SizedBox(height: 12),
                      _buildSectionCard(
                        title: 'Solicitud de Vale',
                        icon: Icons.receipt_outlined,
                        color: ColorsApp.warning,
                        onTap: controller.goToSolicitudVale,
                      ),
                      const SizedBox(height: 12),
                      _buildSectionCard(
                        title: 'Rendir Vale',
                        icon: Icons.assignment_return_outlined,
                        color: ColorsApp.success,
                        onTap: controller.goToRendirVale,
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink());
      },
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(icon, color: color, size: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: ColorsApp.primary,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: ColorsApp.control, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
