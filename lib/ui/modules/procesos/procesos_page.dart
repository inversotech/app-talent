import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/controllers/procesos/procesos_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';
import 'package:lamb_talent/shared/components/app_card.dart';
import 'package:lamb_talent/shared/components/app_text.dart';

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
                  padding: const EdgeInsets.all(Spacing.sm),
                  child: Column(
                    children: [
                      const SizedBox(height: Spacing.xs),
                      _buildSectionCard(
                        title: 'Solicitud de Pago',
                        subtitle:
                            '¿Tienes comprobantes pedientes de reembolso?',
                        icon: Icons.payment_outlined,
                        color: ColorsApp.primary,
                        onTap: controller.goToSolicitudPago,
                      ),
                      const SizedBox(height: Spacing.xs),
                      _buildSectionCard(
                        title: 'Solicitud de Vale',
                        subtitle:
                            '¿Necesitas un vale para gastos de tu trabajo?',
                        icon: Icons.receipt_outlined,
                        color: ColorsApp.warning,
                        onTap: controller.goToSolicitudVale,
                      ),
                      const SizedBox(height: Spacing.xs),
                      _buildSectionCard(
                        title: 'Rendir Vale',
                        subtitle: '¿Tienes vales pendientes de rendir?',
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
    String? subtitle,
  }) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(Spacing.md),
      borderRadius: AppRadius.sm,
      child: Row(
        children: [
          // Ícono con fondo circular
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Center(
              child: Icon(icon, color: color, size: 22),
            ),
          ),
          const SizedBox(width: Spacing.md),
          // Título + subtítulo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.h3(title, color: ColorsApp.neutral800),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  AppText.label(subtitle, color: ColorsApp.neutral500),
                ],
              ],
            ),
          ),
          // Flecha indicadora
          Icon(
            Icons.arrow_forward_ios,
            color: ColorsApp.neutral400,
            size: 15,
          ),
        ],
      ),
    );
  }
}
