import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/ui/modules/procesos/components/rendir_vale_list.dart';
import 'package:lamb_talent/ui/modules/procesos/components/solicitud_pago_list.dart';
import 'package:lamb_talent/ui/modules/procesos/components/solicitud_vale_list.dart';

class ProcesosController extends GetxController {
  final scrollController = ScrollController();
  final userPreferences = UserPreferences();

  RxBool loadingData = true.obs;

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void goToSolicitudPago() {
    Get.to(() => const SolicitudPagoList());
  }

  void goToSolicitudVale() {
    Get.to(() => SolicitudValeList());
  }

  void goToRendirVale() {
    Get.to(() => RendirValeList());
  }
}
