import 'package:carousel_slider/carousel_controller.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/resources/services/auth/auth_service.dart';
import 'package:lamb_talent/ui/modules/holiday/holiday_approve_page.dart';
import 'package:lamb_talent/ui/modules/holiday/holiday_page.dart';
import 'package:lamb_talent/ui/modules/justification/components/form_justification.dart';
import 'package:lamb_talent/ui/modules/justification/justificattion_page.dart';
import 'package:lamb_talent/ui/modules/license_permit/components/form_license_permit.dart';
import 'package:lamb_talent/ui/modules/license_permit/license_permit_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/resources/services/assistance/marking_service.dart';
import 'package:lamb_talent/resources/services/report/assistance_summary_service.dart';
import 'package:lamb_talent/ui/modules/home/components/list_schedule.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:lamb_talent/ui/modules/home/components/sign.dart';
import 'package:lamb_talent/ui/modules/markings/my_markings_page.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final userPreferences = UserPreferences();
  final scrollController = ScrollController();
  final controllerCarousel = CarouselController();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  RxString showButton = '0'.obs;
  RxString textButton = ''.obs;
  RxString codeModality = ''.obs;
  RxString insidePolygon = '0'.obs;
  RxString namePolygon = ''.obs;
  RxString idDescripMarcacion = ''.obs;
  RxString hourMarking = ''.obs;
  RxInt minutosTolerancia = 0.obs;
  final chart = GlobalKey();
  RxBool loadingData = false.obs;
  List<AssistanceSummaryModel> listData = [];
  RxBool chartInit = false.obs;
  Map<String, dynamic>? chartData;
  Map<String, dynamic>? dataCarousel;
  List<dynamic> series = [];
  RxBool isMarking = false.obs;

  bool openSetting = false;
  bool openLocation = false;

  RxString codeModule = '16120101'.obs;
  RxBool isJefeArea = false.obs;
  RxBool isDth = false.obs;
  bool isListApprove = false;
  @override
  void onInit() {
    WidgetsBinding.instance!.addObserver(this);
    super.onInit();
  }

  @override
  void onReady() {
    if ((Get.currentRoute == '/JustificationPage' ||
            Get.currentRoute == '/LicensePermitPage' ||
            Get.currentRoute == '/HolidayApprovePage') &&
        isListApprove) {
      Get.back();
      _listAllData();
    } else {
      _listAllData();
    }
    super.onReady();
  }

  @override
  void dispose() {
    refreshController.dispose();
    scrollController.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void _listAllData() async {
    loadingIndicator(onlyLoading: true, opacity: false);
    await _getActions();
    await _getAccessNivel();
    await _getListDataAndChart();
    if (!userPreferences.isWorkerChild) {
      await _verifyButtonAssistance();
    } else {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      refreshController.loadNoData();
      loadingData.value = true;
      loadingData.value = false;
    }
  }

  Future _getActions() async {
    final Map<String, String> params = {'id_modulo': codeModule.value};
    final _authService = AuthService();
    final actions = await _authService.getActionsByModule(params);
    isJefeArea.value = actions
        .where((element) =>
            element.clave.toString().toUpperCase() == 'APPROVE_JUST_AREA')
        .isNotEmpty;
    isDth.value = actions
        .where((element) =>
            element.clave.toString().toUpperCase() == 'APPROVE_JUST_DTH')
        .isNotEmpty;
  }

  Future _getAccessNivel() async {
    final Map<String, String> params = {
      'codigo_acceso': codeModule.value.toString()
    };
    final _authService = AuthService();
    final resp = await _authService.getAccessNivel(params);
    userPreferences.idNivelAcceso = resp.accesoNivel!.idAccesoNivel != null
        ? resp.accesoNivel!.idAccesoNivel.toString()
        : '';
    if (resp.accesoNivel!.idTipoNivelVista != null &&
        resp.accesoNivel!.idTipoNivelVista != '5') {
      userPreferences.searchPerson = true;
    } else {
      userPreferences.searchPerson = false;
    }
  }

  Future _verifyButtonAssistance() async {
    bool serviceEnabled;
    LocationPermission permission;

// Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _getButtonAssitance('0', '0', false, false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await _getButtonAssitance('0', '0', true, false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await _getButtonAssitance('0', '0', true, false);
      return;
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    await _getButtonAssitance(position.longitude.toString(),
        position.latitude.toString(), true, true);
  }

  Future _getButtonAssitance(String longitude, String latitude,
      bool serviceEnabled, bool denied) async {
    Map<String, String> params = {
      'lng': longitude,
      'lat': latitude,
      'id_entidad': userPreferences.idEntity.toString(),
      'id_depto': userPreferences.idDeparment.toString()
    };

    final _markingService = MarkingService();
    final response = await _markingService.showButtonAssistance(params);
    if (response.success) {
      showButton.value = response.data['show_button'] ?? '0';
      textButton.value = response.data['text_button'] ?? '';
      codeModality.value = response.data['code_modality'] ?? '';
      idDescripMarcacion.value = response.data['id_descrip_marcacion'] ?? '';
      hourMarking.value = response.data['fecha_hora'] ?? '';
      minutosTolerancia.value = response.data['minutos_tolerancia'] != null
          ? int.parse(response.data['minutos_tolerancia'].toString())
          : 0;
      if (showButton.value == '3' && !isMarking.value) {
        if (Get.isDialogOpen!) {
          Get.back();
        }
        Get.snackbar('Mensaje:', response.message,
            duration: const Duration(seconds: 8),
            colorText: ColorsApp.white,
            backgroundColor: ColorsApp.warning);
      } else {
        isMarking.value = false;
      }
    }
    if (Get.isDialogOpen!) {
      Get.back();
    }
    refreshController.loadNoData();
    loadingData.value = true;
    loadingData.value = false;
    if (codeModality.value == 'TP' && !serviceEnabled) {
      await _serviceLocationDisable(refreshShowButton: true);
    } else if (codeModality.value == 'TP' && !denied) {
      await _serviceLocationDenied(refreshShowButton: true);
    }
  }

  Future _getListDataAndChart() async {
    final Map<String, String> params = {
      'id_anho': DateTime.now().year.toString(),
      'id_mes': DateTime.now().month.toString(),
      'id_entidad': userPreferences.idEntity.toString(),
      /* 'id_depto': userPreferences.idDeparment.toString(), */
      'id_trabajador': userPreferences.idWorker.toString(),
      'incluir_chart_data': '1',
      'restringido': 'S',
      'id_acceso_nivel': userPreferences.idNivelAcceso.toString(),
      'incluir_cantidad_aprobar':
          (isDth.value || isJefeArea.value) && !userPreferences.isWorkerChild
              ? '1'
              : '0',
      'id_estado_justif_in': isDth.value
          ? '01,02'
          : isJefeArea.value
              ? '01'
              : '',
      'id_estado_lica_perc_in': isDth.value
          ? '01,02'
          : isJefeArea.value
              ? '01'
              : ''
    };
    final assistanceSummaryService = AssistanceSummaryService();
    final resp = await assistanceSummaryService.getAssistanceSummary(params);
    if (resp.success) {
      dataCarousel = resp.data;
      if (dataCarousel != null && dataCarousel!.containsKey('chart_data')) {
        List<dynamic> jsonList = resp.data['chart_data'] as List;
        List<AssistanceSummaryModel> list = jsonList
            .map((jsonElement) => AssistanceSummaryModel.fromJson(jsonElement))
            .toList();
        listData = list;
      }
    }
  }

  void onRefresh() async {
    if (!userPreferences.isWorkerChild) {
      await _verifyButtonAssistance();
    }
    await _getListDataAndChart();
    refreshController.refreshCompleted();
    refreshController.loadNoData();
    loadingData.value = true;
    loadingData.value = false;
  }

  void markingAssistance() async {
    loadingIndicator(onlyLoading: false, text: 'Guardando...');
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    String uuid = '';
    if (GetPlatform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      uuid = androidInfo.androidId; //UUID for Android
    } else if (GetPlatform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      uuid = iosInfo.identifierForVendor; //UUID for iOS
    }

    bool serviceEnabled;
    LocationPermission permission;

// Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (codeModality.value == 'TP') {
        if (Get.isDialogOpen!) {
          Get.back();
        }
        await _serviceLocationDisable(refreshShowButton: false);
      } else {
        continuoMarkingAssistance(uuid, '0', '0');
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (codeModality.value == 'TP') {
          if (Get.isDialogOpen!) {
            Get.back();
          }
          await _serviceLocationDenied(refreshShowButton: false);
        } else {
          continuoMarkingAssistance(uuid, '0', '0');
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (codeModality.value == 'TP') {
        if (Get.isDialogOpen!) {
          Get.back();
        }
        await _serviceLocationDenied(refreshShowButton: false);
      } else {
        continuoMarkingAssistance(uuid, '0', '0');
      }
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    await continuoMarkingAssistance(
        uuid, position.longitude.toString(), position.latitude.toString());
  }

  Future continuoMarkingAssistance(
      String uuid, String longitude, String latitude) async {
    Map<String, String> params = {
      'uuid': uuid,
      'lng': longitude,
      'lat': latitude,
      'codigo_modalidad': codeModality.toString(),
      'id_descrip_marcacion': idDescripMarcacion.toString(),
      'id_entidad': userPreferences.idEntity.toString(),
      'id_depto': userPreferences.idDeparment.toString()
    };

    final _markingService = MarkingService();
    final marking = await _markingService.workerMarking(params);
    if (Get.isDialogOpen!) {
      Get.back();
    }
    if (marking.success) {
      isMarking.value = true;
      loadingIndicator(onlyLoading: true, opacity: false);
      if (!userPreferences.isWorkerChild) {
        await _verifyButtonAssistance();
      }
      await _getListDataAndChart();
      if (Get.isDialogOpen!) {
        Get.back();
      }
    }
    loadingData.value = true;
    loadingData.value = false;
  }

  Color colorAssistance(String code) {
    Color color = Colors.black12;
    switch (code) {
      case '01':
        color = ColorsApp.success;
        break;
      case '02':
        color = ColorsApp.primary;
        break;
      case '03':
        color = ColorsApp.warning;
        break;
      case '04':
        color = ColorsApp.danger;
        break;
      default:
        color = Colors.black12;
        break;
    }
    return color;
  }

  void fnShowModalSchedule() {
    showModalSchedule(DateTime.now());
  }

  void goToMarkings() {
    Get.to(() => MyMarkingsPage(), transition: Transition.size);
  }

  void goToJustification() {
    isListApprove = false;
    Get.to(() => const JustificationPage(), transition: Transition.size);
  }

  void goToJustificationApprove() async {
    isListApprove = true;
    final result = await Get.to(
        () => const JustificationPage(
              approve: true,
              title: 'Aprobar justificaciones',
            ),
        transition: Transition.size);
    if (result != null) {
      if (result['change'] == 'true' || result['change'] == true) {
        loadingIndicator(onlyLoading: true, opacity: false);
        await _getListDataAndChart();
        if (Get.isDialogOpen!) {
          Get.back();
        }
        loadingData.value = true;
        loadingData.value = false;
      }
    }
  }

  void goToLicensePermit() {
    isListApprove = false;
    Get.to(() => const LicensePermitPage(), transition: Transition.size);
  }

  void goToLicensePermitApprove() async {
    isListApprove = true;
    final result = await Get.to(
        () => const LicensePermitPage(
              approve: true,
              title: 'Aprobar permisos y licencias',
            ),
        transition: Transition.size);
    if (result != null) {
      if (result['change'] == 'true' || result['change'] == true) {
        loadingIndicator(onlyLoading: true, opacity: false);
        await _getListData();
        if (Get.isDialogOpen!) {
          Get.back();
        }
        loadingData.value = true;
        loadingData.value = false;
      }
    }
  }

  void goToHolidayApprove() async {
    isListApprove = true;
    final result = await Get.to(() => const HolidayApprovePage(),
        transition: Transition.size);
    if (result != null) {
      if (result['change'] == 'true' || result['change'] == true) {
        loadingIndicator(onlyLoading: true, opacity: false);
        await _getListData();
        if (Get.isDialogOpen!) {
          Get.back();
        }
        loadingData.value = true;
        loadingData.value = false;
      }
    }
  }

  void goToHoliday() {
    isListApprove = false;
    Get.to(() => const HolidayPage(), transition: Transition.size);
  }

  void goToFormJustification() async {
    final result = await Get.to(
        () => FormJustification(arguments: JustificationModel()),
        transition: Transition.size);
    if (result != null) {
      if (result['change'] == 'true' || result['change'] == true) {
        loadingIndicator(onlyLoading: true, opacity: false);
        await _getListData();
        if (Get.isDialogOpen!) {
          Get.back();
        }
        loadingData.value = true;
        loadingData.value = false;
      }
    }
  }

  void goToFormLicenPerm() async {
    final result = await Get.to(
        () => FormLicensePermit(arguments: LicensePermitModel()),
        transition: Transition.size);
    if (result != null) {
      if (result['change'] == 'true' || result['change'] == true) {
        loadingIndicator(onlyLoading: true, opacity: false);
        await _getListData();
        if (Get.isDialogOpen!) {
          Get.back();
        }
        loadingData.value = true;
        loadingData.value = false;
      }
    }
  }

  Future _getListData() async {
    final Map<String, String> params = {
      'id_anho': DateTime.now().year.toString(),
      'id_mes': DateTime.now().month.toString(),
      'id_entidad': userPreferences.idEntity.toString(),
      /* 'id_depto': userPreferences.idDeparment.toString(), */
      'id_trabajador': userPreferences.idWorker.toString(),
      'incluir_chart_data': '0',
      'restringido': 'S',
      'id_acceso_nivel': userPreferences.idNivelAcceso.toString(),
      'incluir_cantidad_aprobar':
          (isDth.value || isJefeArea.value) && !userPreferences.isWorkerChild
              ? '1'
              : '0',
      'id_estado_justif_in': isDth.value
          ? '01,02'
          : isJefeArea.value
              ? '01'
              : '',
      'id_estado_lica_perc_in': isDth.value
          ? '01,02'
          : isJefeArea.value
              ? '01'
              : ''
    };
    final assistanceSummaryService = AssistanceSummaryService();
    ApiResponse resp =
        await assistanceSummaryService.getAssistanceSummary(params);
    if (resp.success) {
      dataCarousel = resp.data;
    } else {
      dataCarousel = {};
    }
  }

  void fnVacation(BuildContext buildContext) async {
    if (dataCarousel != null && dataCarousel!.containsKey('vacacion')) {
      if (dataCarousel!['vacacion']['codigo'].toString() == '01' ||
          dataCarousel!['vacacion']['codigo'].toString() == '02') {
        HolidayModel vacacion =
            HolidayModel.fromJson(dataCarousel!['vacacion']['vacacion']);
        String type = vacacion.inihabilitar == '1'
            ? 'S'
            : vacacion.finhabilitar == '1'
                ? 'R'
                : '';
        bool sign = await showModalSSign(vacacion, type, buildContext);
        if (sign) {
          loadingIndicator(onlyLoading: true, opacity: false);
          await _getListDataAndChart();
          if (Get.isDialogOpen!) {
            Get.back();
          }
          refreshController.loadNoData();
          loadingData.value = true;
          loadingData.value = false;
        }
      }
    }
  }

  Future<bool> _serviceLocationDisable({bool refreshShowButton = false}) async {
    Get.dialog(AlertDialog(
      title: Center(
          child: Text('Alerta!',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500, color: ColorsApp.primary))),
      content: Text(
          'Usted es un trabajador con la modalidad "Trabajo Presencial" es necesario que active y otorgue el permiso de su ubicación para la asistencia',
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w400, color: ColorsApp.primary)),
      actions: [
        TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return ColorsApp.info; // Use the component's default.
              },
            ), shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
              (Set<MaterialState> states) {
                return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25)); // Use the component's default.
              },
            )),
            onPressed: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Cancelar',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500, color: ColorsApp.primary)),
            )),
        TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return ColorsApp.primary;
              },
            ), shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
              (Set<MaterialState> states) {
                return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25));
              },
            )),
            onPressed: () async {
              Get.back();
              await Geolocator.openLocationSettings();
              openLocation = refreshShowButton;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Activar mi ubicación',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500, color: ColorsApp.white)),
            ))
      ],
    ));
    return true;
  }

  Future<void> _serviceLocationDenied({bool refreshShowButton = false}) async {
    Get.dialog(
        AlertDialog(
          title: Center(
              child: Text('Alerta!',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500, color: ColorsApp.primary))),
          content: Text(
              'Usted es un trabajador con la modalidad "Trabajo Presencial", es necesario que otorgue el permiso de su ubicación para la asistencia',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: ColorsApp.primary)),
          actions: [
            TextButton(
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return ColorsApp.info; // Use the component's default.
                  },
                ), shape:
                    MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                  (Set<MaterialState> states) {
                    return RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            25)); // Use the component's default.
                  },
                )),
                onPressed: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Cancelar',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: ColorsApp.primary)),
                )),
            TextButton(
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return ColorsApp.primary;
                  },
                ), shape:
                    MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                  (Set<MaterialState> states) {
                    return RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25));
                  },
                )),
                onPressed: () async {
                  Get.back();
                  await Geolocator.openAppSettings();
                  openSetting = refreshShowButton;
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Otorgar permiso',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500, color: ColorsApp.white)),
                ))
          ],
        ),
        barrierDismissible: false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && openSetting) {
      openSetting = false;
      loadingIndicator(onlyLoading: true, opacity: false);
      _verifyButtonAssistance();
    } else if (state == AppLifecycleState.resumed && openLocation) {
      openLocation = false;
      loadingIndicator(onlyLoading: true, opacity: false);
      _verifyButtonAssistance();
    }
  }
}
