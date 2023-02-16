import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/routers_names.dart';

import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/resources/services/assistance/marking_service.dart';
import 'package:lamb_talent/resources/services/justification/justification_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:lamb_talent/shared/components/visor_pdf_img.dart';
import 'package:path_provider/path_provider.dart';

class FormJustificationController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final userPreferences = UserPreferences();
  final JustificationModel arguments;
  List<Map<String, dynamic>> listReasons = [];
  List<ScheduleWorkerModel> listSchedule = [];
  List<MarkingWorkerModel> listMarkings = [];
  List<MarkingModel> listAssistance = [];
  List<MarkingWorkerModel> listMarkingsSelected = [];
  List<DescriptionMarkingModel> listDescripMarkings = [];
  List<DescriptionMarkingModel> listDescriptionsMarking = [];
  List<ProcessJustifcationModel> listProcessJustif = [];
  List<Color> listColorsMarkingSelected = [];
  TextEditingController inputFieldReasonCtrl = TextEditingController();

  var formData = JustificationModel().obs;
  RxString evidence = ''.obs;
  RxString evidenceText = 'Adjuntar evidencia'.obs;
  RxBool loadMarking = false.obs;
  RxBool loadDescripMarking = false.obs;
  RxBool loadingDescriptionsMarking = false.obs;
  RxString idDescripMarcacion = ''.obs;
  RxBool deleteEvidence = false.obs;
  RxBool validForm = false.obs;
  ScheduleWorkerModel? scheduleData;
  FormJustificationController({required this.arguments});
  @override
  void onReady() {
    formData.value = arguments;
    if (formData.value.idSolicJustif != null) {
      inputFieldReasonCtrl.text = formData.value.idMotivoJustif.toString();
      if (formData.value.evidenciaAdj != null) {
        evidenceText.value = 'Adjuntar evidencia';
      }
      getMarkings();
    } else {
      formData.value.idEstadoJustif = '01';
      formData.value.idEntidad = userPreferences.idEntity.toString();
      formData.value.idDepto = userPreferences.idDeparment.toString();
    }

    _getDatheader();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    inputFieldReasonCtrl.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    scrollController.dispose();
    inputFieldReasonCtrl.dispose();
    super.dispose();
  }

  void _getDatheader() async {
    Get.until((route) => !Get.isDialogOpen!);
    loadingIndicator(onlyLoading: true, opacity: false);

    final justificationService = JustificationService();
    final list = await justificationService.getReasonsJustification();
    for (var element in list) {
      listReasons.add({
        'value': element.idMotivoJustif,
        'label': element.nombre,
        'icon': null,
      });
    }
    Get.until((route) => !Get.isDialogOpen!);
  }

  void getMarkings() async {
    Map<String, String> params = {
      'fecha': DateFormat('y-MM-dd')
          .format(DateTime.parse(formData.value.fecha.toString())),
    };
    Get.until((route) => !Get.isDialogOpen!);
    loadingIndicator(onlyLoading: true, opacity: false);
    final justificationService = JustificationService();
    listSchedule = await justificationService.getScheduleWorker(params);
    if (listSchedule.isNotEmpty) {
      scheduleData = listSchedule[0];
      Map<String, String> params = {
        'id_entidad': formData.value.idEntidad.toString(),
        'id_depto': formData.value.idDepto.toString(),
        'fechahora_entrada': listSchedule[0].fechahoraEntrada.toString(),
        'fechahora_salida': listSchedule[0].fechahoraSalida.toString(),
        'id_solic_justif': formData.value.idSolicJustif != null
            ? formData.value.idSolicJustif.toString()
            : '',
        'fecha': DateFormat('y-MM-dd')
            .format(DateTime.parse(formData.value.fecha.toString()))
      };
      if (!Get.isDialogOpen!) {
        loadingIndicator(onlyLoading: true, opacity: false);
      }
      listMarkings = await justificationService.getMarkingWorker(params);
      UserPreferences userPreferences = UserPreferences();
      params = {
        'id_entidad': userPreferences.idEntity != null
            ? userPreferences.idEntity.toString()
            : '',
        'id_depto': userPreferences.idDeparment != null
            ? userPreferences.idDeparment.toString()
            : '',
        'id_trabajador': userPreferences.idWorker != null
            ? userPreferences.idWorker.toString()
            : '',
        'id_motivo_asist': 'A',
        'per_page': '10',
        'page': '1'
      };
      params['fecha'] = DateFormat('y-MM-dd')
          .format(DateTime.parse(formData.value.fecha.toString()));
      if (!Get.isDialogOpen!) {
        loadingIndicator(onlyLoading: true, opacity: false);
      }
      final markingService = MarkingService();
      PaginationModel pagination = await markingService.assistMarkings(params);
      List<dynamic> jsonList =
          pagination.data == null ? [] : pagination.data as List<dynamic>;

      List<MarkingModel> list = jsonList
          .map((jsonElement) => MarkingModel.fromJson(jsonElement))
          .toList();
      listAssistance = list;
    } else {
      listMarkings = [];
    }
    listMarkingsSelected = [];
    listColorsMarkingSelected = [];
    MarkingWorkerModel horaEntrada = MarkingWorkerModel();
    MarkingWorkerModel horaSalidaRef = MarkingWorkerModel();
    MarkingWorkerModel horaEntradaRef = MarkingWorkerModel();
    MarkingWorkerModel horaSalida = MarkingWorkerModel();
    final schedule = listSchedule.isNotEmpty ? listSchedule[0] : null;
    final assistance =
        listAssistance.isNotEmpty ? listAssistance[0] : MarkingModel();
    MarkingWorkerModel findEntrada = listMarkings.firstWhere(
        (val) => val.idMarcacion != null && val.idDescripMarcacion == '01',
        orElse: () => MarkingWorkerModel());
    MarkingWorkerModel findSalidaRef = listMarkings.firstWhere(
        (val) => val.idMarcacion != null && val.idDescripMarcacion == '02',
        orElse: () => MarkingWorkerModel());
    MarkingWorkerModel findEntradaRef = listMarkings.firstWhere(
        (val) => val.idMarcacion != null && val.idDescripMarcacion == '03',
        orElse: () => MarkingWorkerModel());
    MarkingWorkerModel findSalida = listMarkings.firstWhere(
        (val) => val.idMarcacion != null && val.idDescripMarcacion == '04',
        orElse: () => MarkingWorkerModel());
    final colorEnt = _getColorEnt(assistance);
    final colorSalRef = _getColorSalRef(assistance);
    final colorEntRef = _getColorEntRef(assistance);
    final colorSal = _getColorSal(assistance);
    if (findEntrada.idDescripMarcacion == null) {
      if (schedule != null) {
        horaEntrada = MarkingWorkerModel(
            fechahoraManual: schedule.fechahoraEntrada,
            idDescripMarcacion: '01',
            esSolicitado: false,
            eliminar: true,
            esJustificado: false,
            nombreDescripMarcacion: 'Hora entrada');
        listColorsMarkingSelected.add(colorEnt);
        listMarkingsSelected.add(horaEntrada);
      }
    } else {
      listColorsMarkingSelected.add(colorEnt);
      listMarkingsSelected.add(findEntrada);
    }
    if (findSalidaRef.idDescripMarcacion == null) {
      if (schedule != null) {
        if (schedule.fechahoraSalidaRef != null) {
          horaSalidaRef = MarkingWorkerModel(
              fechahoraManual: schedule.fechahoraSalidaRef,
              idDescripMarcacion: '02',
              esSolicitado: false,
              eliminar: true,
              esJustificado: false,
              nombreDescripMarcacion: 'Hora salida ref');

          listColorsMarkingSelected.add(colorSalRef);
          listMarkingsSelected.add(horaSalidaRef);
        }
      }
    } else {
      listColorsMarkingSelected.add(colorSalRef);
      listMarkingsSelected.add(findSalidaRef);
    }
    if (findEntradaRef.idDescripMarcacion == null) {
      if (schedule != null) {
        if (schedule.fechahoraEntradaRef != null) {
          horaEntradaRef = MarkingWorkerModel(
              fechahoraManual: schedule.fechahoraEntradaRef,
              idDescripMarcacion: '03',
              esSolicitado: false,
              eliminar: true,
              esJustificado: false,
              nombreDescripMarcacion: 'Hora entrada ref');
          listColorsMarkingSelected.add(colorEntRef);
          listMarkingsSelected.add(horaEntradaRef);
        }
      }
    } else {
      listColorsMarkingSelected.add(colorEntRef);
      listMarkingsSelected.add(findEntradaRef);
    }
    if (findSalida.idDescripMarcacion == null) {
      if (schedule != null) {
        horaSalida = MarkingWorkerModel(
            fechahoraManual: schedule.fechahoraSalida,
            idDescripMarcacion: '04',
            esSolicitado: false,
            eliminar: true,
            esJustificado: false,
            nombreDescripMarcacion: 'Hora salida');

        listColorsMarkingSelected.add(colorSal);
        listMarkingsSelected.add(horaSalida);
      }
    } else {
      listColorsMarkingSelected.add(colorSal);
      listMarkingsSelected.add(findSalida);
    }
    Future.delayed(Duration.zero, () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    });
    loadMarking.value = false;
    loadMarking.value = true;
    Get.until((route) => !Get.isDialogOpen!);
    Get.until((route) => !Get.isDialogOpen!);
  }

  Color _getColorEnt(MarkingModel item) {
    Color color = ColorsApp.success;
    if (item.horaEntJust == '1') {
      color = ColorsApp.primary;
    } else if (item.horaEntradaReal == null) {
      color = ColorsApp.danger;
    } else if (double.parse(item.numMinutosTarEnt.toString()) > 0) {
      color = ColorsApp.warning;
    } else if (double.parse(item.numMinutosTarEnt.toString()) == 0) {
      color = ColorsApp.success;
    } else {
      color = ColorsApp.danger;
    }
    return color;
  }

  Color _getColorSalRef(MarkingModel item) {
    Color color = ColorsApp.success;
    if (item.horaSalRefJust == '1') {
      color = ColorsApp.primary;
    } else if (item.horaSalidaRefReal == null &&
        item.horaBaseSalRef != null &&
        item.horaBaseEntRef != null) {
      color = ColorsApp.danger;
    } else if (item.horaBaseSalRef == null && item.horaBaseEntRef == null) {
      color = ColorsApp.danger;
    } else if (double.parse(item.numMinutosTarSalRef.toString()) > 0) {
      color = ColorsApp.warning;
    } else if (double.parse(item.numMinutosTarSalRef.toString()) == 0) {
      color = ColorsApp.success;
    } else {
      color = ColorsApp.danger;
    }
    return color;
  }

  Color _getColorEntRef(MarkingModel item) {
    Color color = ColorsApp.success;
    if (item.horaEntRefJust == '1') {
      color = ColorsApp.primary;
    } else if (item.horaEntradaRefReal == null &&
        item.horaBaseSalRef != null &&
        item.horaBaseEntRef != null) {
      color = ColorsApp.danger;
    } else if (item.horaBaseSalRef == null && item.horaBaseEntRef == null) {
      color = ColorsApp.danger;
    } else if (double.parse(item.numMinutosTarRef.toString()) > 0) {
      color = ColorsApp.warning;
    } else if (double.parse(item.numMinutosTarRef.toString()) == 0) {
      color = ColorsApp.success;
    } else {
      color = ColorsApp.danger;
    }
    return color;
  }

  Color _getColorSal(MarkingModel item) {
    Color color = ColorsApp.success;
    if (item.horaSalJust == '1') {
      color = ColorsApp.primary;
    } else if (item.horaSalidaReal == null) {
      color = ColorsApp.danger;
    } else if (double.parse(item.numMinutosTarSal.toString()) > 0) {
      color = ColorsApp.warning;
    } else if (double.parse(item.numMinutosTarSal.toString()) == 0) {
      color = ColorsApp.success;
    } else {
      color = ColorsApp.danger;
    }
    return color;
  }

  void fnShowEvidence() async {
    if (evidence.value.isEmpty && formData.value.evidenciaAdj != null) {
      loadingIndicator();
      Map<String, String> params = {
        'archivo': formData.value.evidenciaAdj.toString()
      };
      final justificationService = JustificationService();
      ApiResponse resp = await justificationService.geFileRequest(params);
      if (resp.success) {
        final dir = await getTemporaryDirectory();
        File file = File(dir.path + formData.value.evidenciaAdj.toString());
        Uint8List bytes = base64.decode(resp.data);
        await file.writeAsBytes(bytes);
        Get.until((route) => !Get.isDialogOpen!);
        Get.to(() => VisorPdfImgPage(title: 'Evidencia', filePath: file.path));
      }
    } else if (evidence.value.isNotEmpty) {
      Get.to(
          () => VisorPdfImgPage(title: 'Evidencia', filePath: evidence.value));
    }
  }

  void fnClickMarking(int index, MarkingWorkerModel item) {
    if (listMarkingsSelected[index].idDescripMarcacion != null) {
      listMarkingsSelected[index].fechahoraManual =
          _getDateMarking(item.idDescripMarcacion.toString());
      listMarkingsSelected[index].esSolicitado = !item.esSolicitado;
    } else {
      Get.snackbar('Mensaje:', 'No se ha definido el tipo marcación',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.warning);
    }

    loadMarking.value = false;
    loadMarking.value = true;
  }

  void fnChangeMarking(int index, MarkingWorkerModel item, bool val) {
    if (listMarkingsSelected[index].idDescripMarcacion != null) {
      listMarkingsSelected[index].fechahoraManual =
          _getDateMarking(item.idDescripMarcacion.toString());
      listMarkingsSelected[index].esSolicitado = val;
    } else {
      Get.snackbar('Mensaje:', 'No se ha definido el tipo marcación',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.warning);
    }

    loadMarking.value = false;
    loadMarking.value = true;
  }

  String _getDateMarking(String idDescripMarcacion) {
    String fechahora = '';
    if (scheduleData!.idTipoHorario != null) {
      switch (idDescripMarcacion) {
        case '01':
          fechahora = scheduleData!.fechahoraEntrada.toString();
          break;
        case '02':
          if (scheduleData!.fechahoraSalidaRef != null) {
            fechahora = scheduleData!.fechahoraSalidaRef.toString();
          }
          break;
        case '03':
          if (scheduleData!.fechahoraEntradaRef != null) {
            fechahora = scheduleData!.fechahoraEntradaRef.toString();
          }
          break;
        case '04':
          fechahora = scheduleData!.fechahoraSalida.toString();
          break;
        default:
      }
    }
    return fechahora;
  }

  void submit() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();

    final markingsSelected =
        listMarkingsSelected.where((el) => el.esSolicitado == true);
    if (markingsSelected.isNotEmpty) {
      loadingIndicator(onlyLoading: false, text: 'Guardando ...');
      final justificationService = JustificationService();
      if (formData.value.idSolicJustif == null) {
        final Map<String, dynamic> params = {
          'id_entidad': formData.value.idEntidad.toString(),
          'id_depto': formData.value.idDepto.toString(),
          'id_motivo_justif': formData.value.idMotivoJustif.toString(),
          'fecha': formData.value.fecha.toString(),
          'descripcion': formData.value.descripcion.toString(),
          'evidencia_adj': formData.value.evidenciaAdj.toString(),
          'archivo': evidence.value,
          'id_estado_justif': formData.value.idEstadoJustif.toString(),
          'marcaciones': json.encode(markingsSelected.toList()).toString()
        };
        if (evidence.value.isNotEmpty) {
          params['archivo'] =
              MultipartFile(evidence.value, filename: 'archivo');
        }
        final form = FormData(params);
        final create = await justificationService.createJustification(form);
        Get.until((route) => !Get.isDialogOpen!);
        if (create.success) {
          final userPref = UserPreferences();
          userPref.resultChange = true;
          Get.until((route) => Get.currentRoute == RoutesName.home);
        }
      } else {
        final Map<String, dynamic> params = {
          'id_entidad': formData.value.idEntidad.toString(),
          'id_depto': formData.value.idDepto.toString(),
          'id_trabajador': formData.value.idTrabajador.toString(),
          'id_motivo_justif': formData.value.idMotivoJustif.toString(),
          'fecha': formData.value.fecha.toString(),
          'descripcion': formData.value.descripcion.toString(),
          'evidencia_adj': formData.value.evidenciaAdj.toString(),
          'id_estado_justif': formData.value.idEstadoJustif.toString(),
          'marcaciones': json.encode(markingsSelected.toList()).toString(),
          'eliminar_evidencia': deleteEvidence.toString()
        };
        if (evidence.value.isNotEmpty) {
          params['archivo'] =
              MultipartFile(evidence.value, filename: 'archivo');
        }
        final form = FormData(params);
        ApiResponse update = await justificationService.updateJustification(
            form, formData.value.idSolicJustif.toString());
        Get.until((route) => !Get.isDialogOpen!);
        if (update.success) {
          final userPref = UserPreferences();
          userPref.resultChange = true;
          Get.until((route) => Get.currentRoute == RoutesName.home);
        }
      }
    } else {
      Get.snackbar('Mensaje:', 'Debe seleccionar por lo menos una marcación',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.warning);
    }
  }

  void changeRequestStatus(String text) async {
    loadingIndicator(onlyLoading: true, opacity: false);
    UserPreferences userPreferences = UserPreferences();
    Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker.toString(),
      'id_solic_justif': formData.value.idSolicJustif.toString(),
      'id_estado_justif': '00',
      'comentario': text
    };

    final justificationService = JustificationService();
    ApiResponse create = await justificationService.changeRequestStatus(params);
    Get.until((route) => !Get.isDialogOpen!);
    if (create.success) {
      final userPref = UserPreferences();
      userPref.resultChange = true;
      Get.until((route) => Get.currentRoute == RoutesName.home);
    }
  }
}
