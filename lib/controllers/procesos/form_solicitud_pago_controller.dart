import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/shared/components/loading.dart';

class FormSolicitudPagoController extends GetxController {
  final SolicitudPagoModel arguments;
  FormSolicitudPagoController({required this.arguments});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();

  TextEditingController inputDescripcionCtrl = TextEditingController();
  TextEditingController inputFechaCtrl = TextEditingController();

  var formData = SolicitudPagoModel().obs;

  RxBool loadingData = false.obs;

  @override
  void onReady() {
    formData.value = arguments;
    formData.value.documentos ??= [];
    if (formData.value.id != null) {
      inputDescripcionCtrl.text = formData.value.descripcion ?? '';
      inputFechaCtrl.text = formData.value.fecha ?? '';
    }
    loadingData.value = true;
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    inputDescripcionCtrl.dispose();
    inputFechaCtrl.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    scrollController.dispose();
    inputDescripcionCtrl.dispose();
    inputFechaCtrl.dispose();
    super.dispose();
  }

  void clear() {
    formData.value = SolicitudPagoModel();
    formData.value.documentos = [];
    inputDescripcionCtrl.clear();
    inputFechaCtrl.clear();
    loadingData.value = true;
    loadingData.value = false;
  }

  Future<void> addDocumento() async {
    // TODO: Integrar file_picker para selección de archivos reales
    final doc = DocumentoGastoModel(
      id: (formData.value.documentos?.length ?? 0) + 1,
      nombre: 'documento_${(formData.value.documentos?.length ?? 0) + 1}.pdf',
      tipo: 'factura',
      monto: 0.0,
    );
    formData.value.documentos!.add(doc);
    loadingData.value = true;
    loadingData.value = false;
  }

  void removeDocumento(int index) {
    formData.value.documentos?.removeAt(index);
    loadingData.value = true;
    loadingData.value = false;
  }

  Future<void> submit() async {
    bool isValid = formKey.currentState!.validate();
    if (!isValid) {
      Get.snackbar('Mensaje:', 'Corriga los campos marcados de rojo',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.warning);
      return;
    }

    formKey.currentState!.save();
    loadingIndicator(onlyLoading: false, text: 'Guardando ...');

    // TODO: Reemplazar con llamada a servicio API
    await Future.delayed(const Duration(milliseconds: 1500));

    Get.until((route) => !Get.isDialogOpen!);
    Get.snackbar('Éxito', 'Solicitud guardada correctamente',
        duration: const Duration(seconds: 3),
        colorText: ColorsApp.white,
        backgroundColor: ColorsApp.success);
    clear();
    Get.back();
  }
}
