import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/resources/services/license_permit/license_permit_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';

class FormLicensePermitController extends GetxController {
  final scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();
  final userPreferences = UserPreferences();
  final LicensePermitModel arguments;
  TextEditingController inputFieldTypeLicPerCtrl = TextEditingController(),
      inputFieldTypeConLicPerCtrl = TextEditingController(),
      inputFieldTypeInstitutionCtrl = TextEditingController(),
      inputFieldPeriodoCtrl = TextEditingController(),
      inputFieldDateFromCtrl = TextEditingController(),
      inputFieldDateToCtrl = TextEditingController();
  List<TypeLicensePermitModel> listTypeLicensePermit = [];
  List<TypeConceptLicensePermitModel> listTypeConceptLicensePermit = [];
  List<TypeInstitutionModel> listTypeInstitution = [];
  List<StateLicensePermitModel> listProcessLicensePermit = [];
  List<ValidLicensePermitModel> listValidLicensePermit = [];
  var formData = LicensePermitModel().obs;
  RxString adjunto = ''.obs,
      adjuntoText = ''.obs,
      adjuntoVoucher = ''.obs,
      adjuntoVoucherText = ''.obs,
      adjuntoCITT = ''.obs,
      adjuntoCITTText = ''.obs,
      adjuntoNITT = ''.obs,
      adjuntoNITTText = ''.obs,
      adjuntoVIVA = ''.obs,
      adjuntoVIVAText = ''.obs,
      fechaFinDesmed = ''.obs,
      fechaFinSubs = ''.obs,
      fechaIniSubs = ''.obs;
  RxBool loadingData = false.obs,
      showPeriodo = true.obs,
      showDateFrom = false.obs,
      showDateTo = false.obs,
      showTotalDays = false.obs,
      showTotalHours = false.obs,
      showHourFrom = false.obs,
      showHourTo = false.obs,
      requiredAdjunto = false.obs,
      showArea = false.obs,
      showInstitution = false.obs,
      showCodeCITT = false.obs,
      showCodeNitt = false.obs,
      showAdjuntoCITT = false.obs,
      validAdjunto = true.obs,
      validAdjuntoCITT = true.obs,
      validAdjuntoNITT = true.obs,
      validAdjuntoVoucher = true.obs;
  RxInt maxDias = 0.obs,
      minDias = 0.obs,
      diasFijo = 0.obs,
      maxDiasAnho = 0.obs,
      diasAcumulados = 0.obs,
      diasSumados = 0.obs,
      diasSeleccionados = 0.obs,
      diasDesmed = 0.obs,
      diasSubs = 0.obs;

  FormLicensePermitController({required this.arguments});
  @override
  void onReady() {
    formData.value = arguments;
    if (formData.value.idLicenciaPermiso != null) {
      inputFieldTypeLicPerCtrl.text = formData.value.idTipoPermLic.toString();
      /*  if (formData.value.adjunto != null) {
        _evidenceText = 'Se adjuntó evidencia';
      } */

    } else {
      formData.value.idEstadoLicaPer = '01';
    }
    _getDatheader();
    super.onReady();
  }

  @override
  void dispose() {
    scrollController.dispose();
    inputFieldTypeLicPerCtrl.dispose();
    inputFieldTypeConLicPerCtrl.dispose();
    inputFieldTypeInstitutionCtrl.dispose();
    inputFieldPeriodoCtrl.dispose();
    inputFieldDateToCtrl.dispose();
    inputFieldDateFromCtrl.dispose();
    super.dispose();
  }

  void _getDatheader() async {
    Get.until((route) => !Get.isDialogOpen!);
    loadingIndicator(onlyLoading: true, opacity: false);

    final licensePermitService = LicensePermitService();
    listTypeLicensePermit = await licensePermitService.getTypeLicensePermit();
    loadingData.value = true;
    loadingData.value = false;
    Get.until((route) => !Get.isDialogOpen!);
  }

  void cleanConcept() {
    formData.value.goce = null;
    formData.value.engrupo = null;
    formData.value.periodo = null;
    formData.value.codigoConcepto = null;

    showPeriodo.value = false;

    cleanFormCasos('DH');
    _cleanDays();
  }

  void cleanFormCasos(String periodo) {
    switch (periodo) {
      case 'D':
        showDateFrom.value = true;
        showDateTo.value = true;
        showTotalDays.value = true;
        showHourFrom.value = false;
        showHourTo.value = false;
        showTotalHours.value = false;
        formData.value.fechaDesde = null;
        formData.value.fechaHasta = null;
        formData.value.dias = null;
        formData.value.horaInicio = null;
        formData.value.horaFin = null;
        formData.value.horas = null;
        diasSeleccionados.value = 0;
        break;
      case 'H':
        showDateFrom.value = true;
        showDateTo.value = false;
        showTotalDays.value = false;
        showHourFrom.value = true;
        showHourTo.value = true;
        showTotalHours.value = true;
        formData.value.fechaDesde = null;
        formData.value.fechaHasta = null;
        formData.value.dias = null;
        formData.value.horaInicio = null;
        formData.value.horaFin = null;
        formData.value.horas = null;
        diasSeleccionados.value = 1;
        break;
      case 'DH':
        showDateFrom.value = false;
        showDateTo.value = false;
        showHourFrom.value = false;
        showHourTo.value = false;
        showTotalDays.value = false;
        showTotalHours.value = false;
        formData.value.fechaDesde = null;
        formData.value.fechaHasta = null;
        formData.value.dias = null;
        formData.value.horaInicio = null;
        formData.value.horaFin = null;
        formData.value.horas = null;
        diasSeleccionados.value = 0;
        break;
      default:
    }
  }

  void _cleanDays() {
    diasAcumulados.value = 0;
    diasSumados.value = 0;
    diasSeleccionados.value = 0;
    maxDiasAnho.value = 0;
    fechaFinDesmed.value = '';
    fechaFinSubs.value = '';
    fechaIniSubs.value = '';
    diasDesmed.value = 0;
    diasSubs.value = 0;
  }

  void getTypeConLicePer(String idTipoPermLic) async {
    Get.until((route) => !Get.isDialogOpen!);
    loadingIndicator(onlyLoading: true, opacity: false);

    final Map<String, String> params = {'id_tipo_perm_lic': idTipoPermLic};

    final licensePermitService = LicensePermitService();
    listTypeConceptLicensePermit =
        await licensePermitService.getTypeConceptLicensePermit(params);

    loadingData.value = true;
    loadingData.value = false;
    Get.until((route) => !Get.isDialogOpen!);
  }

  void cleanTypeInstitution() {
    formData.value.idTipoInstAtencion = null;
    formData.value.nombreInst = null;
    formData.value.codigocitt = null;
    formData.value.codigonit = null;
    formData.value.codigoviva = null;
    adjuntoVoucher.value = '';
    adjuntoVoucherText.value = '';
    adjuntoCITT.value = '';
    adjuntoCITTText.value = '';
    adjuntoVIVA.value = '';
    adjuntoVIVAText.value = '';
  }

  void getTypeInstitution() async {
    Get.until((route) => !Get.isDialogOpen!);
    loadingIndicator(onlyLoading: true, opacity: false);
    final licensePermitService = LicensePermitService();
    listTypeInstitution = await licensePermitService.getTypeInstitution();

    loadingData.value = true;
    loadingData.value = false;
    Get.until((route) => !Get.isDialogOpen!);
  }

  void validLicensePermit() async {
    Get.until((route) => !Get.isDialogOpen!);
    loadingIndicator(onlyLoading: true, opacity: false);
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity.toString(),
      'id_depto': userPreferences.idDeparment.toString(),
      'trabajador': userPreferences.idWorker.toString(),
      'id_concepto_perm_lic': formData.value.idConceptoPermLic.toString(),
      'fecha_desde': formData.value.fechaDesde.toString(),
      'fecha_hasta': formData.value.fechaHasta.toString(),
      'periodo': formData.value.periodo.toString()
    };
    final licensePermitService = LicensePermitService();
    listValidLicensePermit =
        await licensePermitService.getValidateLicensePermit(params);
    if (listValidLicensePermit.isNotEmpty) {
      diasAcumulados.value = listValidLicensePermit[0].diasAcumulado != null
          ? int.parse(listValidLicensePermit[0].diasAcumulado.toString())
          : 0;
      diasSumados.value = listValidLicensePermit[0].totalDia != null
          ? int.parse(listValidLicensePermit[0].totalDia.toString())
          : 0;
      maxDiasAnho.value = listValidLicensePermit[0].diasAcumulado != null
          ? int.parse(listValidLicensePermit[0].diasAcumulado.toString())
          : 0;
      fechaFinDesmed.value = listValidLicensePermit[0].fechaFinDesmes != null
          ? listValidLicensePermit[0].fechaFinDesmes.toString()
          : '';
      fechaFinSubs.value = listValidLicensePermit[0].fechaFinSubs != null
          ? listValidLicensePermit[0].fechaFinSubs.toString()
          : '';
      fechaIniSubs.value = listValidLicensePermit[0].fechaIniSubs != null
          ? listValidLicensePermit[0].fechaIniSubs.toString()
          : '';
      diasDesmed.value = listValidLicensePermit[0].diasDesmed != null
          ? int.parse(listValidLicensePermit[0].diasDesmed.toString())
          : 0;
      diasSubs.value = listValidLicensePermit[0].diasSubs != null
          ? int.parse(listValidLicensePermit[0].diasSubs.toString())
          : 0;
      maxDiasAnho.value = listValidLicensePermit[0].maxDiasAnho != null
          ? int.parse(listValidLicensePermit[0].maxDiasAnho.toString())
          : 0;
    }

    loadingData.value = true;
    loadingData.value = false;
    Get.until((route) => !Get.isDialogOpen!);
  }

  void submit() async {
    validAdjunto.value = true;
    validAdjuntoCITT.value = true;
    validAdjuntoNITT.value = true;
    validAdjuntoVoucher.value = true;
    bool isValid = formKey.currentState!.validate();
    if (requiredAdjunto.value && adjunto.value.isEmpty) {
      validAdjunto.value = false;
      isValid = false;
    }
    if (showInstitution.value &&
        showCodeCITT.value &&
        adjuntoCITT.value.isEmpty) {
      validAdjuntoCITT.value = false;
      isValid = false;
    }
    if (showInstitution.value &&
        showCodeNitt.value &&
        diasSumados.value > 20 &&
        adjuntoNITT.value.isEmpty) {
      validAdjuntoNITT.value = false;
      isValid = false;
    }
    if (showInstitution.value &&
        showCodeNitt.value &&
        adjuntoVoucher.value.isEmpty) {
      validAdjuntoVoucher.value = false;
      isValid = false;
    }
    if (!isValid) {
      Get.snackbar('Mensaje:', 'Corriga los campos marcados de rojo',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.warning);
      return;
    }
    formKey.currentState!.save();
    loadingIndicator(onlyLoading: false, text: 'Guardando ...');
    final Map<String, dynamic> params = {
      'id_concepto_perm_lic': formData.value.idConceptoPermLic.toString(),
      'id_entidad': userPreferences.idEntity.toString(),
      'id_trabajador': userPreferences.idWorker.toString(),
      'id_trabajador_grupo': [].toString(),
      'periodo': formData.value.periodo.toString(),
      'motivo':
          formData.value.motivo != null ? formData.value.motivo.toString() : '',
      'fecha_desde': formData.value.fechaDesde != null
          ? formData.value.fechaDesde.toString()
          : '',
      'fecha_hasta': formData.value.fechaHasta != null
          ? formData.value.fechaHasta.toString()
          : '',
      'id_tipo_inst_atencion': formData.value.idTipoInstAtencion != null
          ? formData.value.idTipoInstAtencion.toString()
          : '',
      'nombre_inst': formData.value.nombreInst != null
          ? formData.value.nombreInst.toString()
          : '',
      'codigo_citt': formData.value.codigocitt != null
          ? formData.value.codigocitt.toString()
          : '',
      'codigo_nitt': formData.value.codigonit != null
          ? formData.value.codigonit.toString()
          : '',
      'codigo_viva': formData.value.codigoviva != null
          ? formData.value.codigoviva.toString()
          : '',
      'hora_inicio': formData.value.horaInicio != null
          ? formData.value.horaInicio.toString()
          : '',
      'hora_fin': formData.value.horaFin != null
          ? formData.value.horaFin.toString()
          : '',
      'id_estado_lica_per': formData.value.idEstadoLicaPer.toString(),
      'enhoras':
          formData.value.horas != null ? formData.value.horas.toString() : '',
      'ambiente': 'P',
      'engrupo': formData.value.engrupo != null
          ? formData.value.engrupo.toString()
          : '',
      'codigo': formData.value.codigoConcepto != null
          ? formData.value.codigoConcepto.toString()
          : ''
    };
    if (adjunto.value.isNotEmpty) {
      params['adjunto'] = MultipartFile(adjunto.value, filename: 'adjunto');
    }
    if (adjuntoCITT.value.isNotEmpty) {
      params['adjunto_citt'] =
          MultipartFile(adjuntoCITT.value, filename: 'adjunto_citt');
    }
    if (adjuntoNITT.value.isNotEmpty) {
      params['adjunto_nitt'] =
          MultipartFile(adjuntoNITT.value, filename: 'adjunto_nitt');
    }
    if (adjuntoVoucher.value.isNotEmpty) {
      params['adjunto_voucher'] =
          MultipartFile(adjuntoVoucher.value, filename: 'adjunto_voucher');
    }
    if (adjuntoVIVA.value.isNotEmpty) {
      params['adjunto_viva'] =
          MultipartFile(adjuntoVIVA.value, filename: 'adjunto_viva');
    }
    final form = FormData(params);
    final licensePermitService = LicensePermitService();
    final create = await licensePermitService.createLicensePermit(form);
    Get.until((route) => !Get.isDialogOpen!);
    if (create.success) {
      Get.back(result: {'change': true, 'data': null});
      Get.snackbar(
          'Mensaje:',
          create.message.isNotEmpty
              ? create.message
              : 'Se guardó correctamente',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.success);
    }
  }
}
