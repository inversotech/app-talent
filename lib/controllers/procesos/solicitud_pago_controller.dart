import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/ui/modules/procesos/components/form_solicitud_pago.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SolicitudPagoController extends GetxController {
  final scrollController = ScrollController();
  final refreshController = RefreshController(initialRefresh: false);
  final userPreferences = UserPreferences();

  List<SolicitudPagoModel> listData = [];
  RxBool loadingDataInit = false.obs;

  @override
  void onReady() {
    listData = [];
    getListDataInitial();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    refreshController.dispose();
    super.onClose();
  }

  void getListDataInitial() async {
    // TODO: Reemplazar con llamada a servicio API
    listData = [
      SolicitudPagoModel(
        id: 1,
        descripcion: 'Compra de papelería',
        fecha: '2026-01-15',
        montoTotal: 250.00,
        estado: 'aprobado',
        documentos: [
          DocumentoGastoModel(
            id: 1,
            nombre: 'factura_papeleria.pdf',
            tipo: 'factura',
            monto: 250.00,
          ),
        ],
      ),
      SolicitudPagoModel(
        id: 2,
        descripcion: 'Transporte interprovincial',
        fecha: '2026-01-22',
        montoTotal: 180.50,
        estado: 'pendiente',
        documentos: [
          DocumentoGastoModel(
            id: 2,
            nombre: 'boleta_transporte.pdf',
            tipo: 'boleta',
            monto: 180.50,
          ),
        ],
      ),
      SolicitudPagoModel(
        id: 3,
        descripcion: 'Insumos de oficina',
        fecha: '2026-02-01',
        montoTotal: 95.00,
        estado: 'rechazado',
        documentos: [],
      ),
    ];
    loadingDataInit.value = false;
    loadingDataInit.value = true;
  }

  void goToForm([SolicitudPagoModel? model]) {
    Get.to(() => FormSolicitudPago(arguments: model ?? SolicitudPagoModel()));
  }

  Future onRefresh() async {
    getListDataInitial();
    refreshController.refreshFailed();
  }

  void goToBack() {
    Get.back();
  }
}
