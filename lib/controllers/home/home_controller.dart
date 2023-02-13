// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/core/location_user.dart';
import 'package:lamb_talent/resources/models/general/acceso_nivel_user.dart';
import 'package:lamb_talent/resources/models/overtime/overtime.dart';
import 'package:lamb_talent/ui/modules/holiday/holiday_approve_page.dart';
import 'package:lamb_talent/ui/modules/holiday/holiday_page.dart';
import 'package:lamb_talent/ui/modules/home/components/view_qr.dart';
import 'package:lamb_talent/ui/modules/justification/components/form_justification.dart';
import 'package:lamb_talent/ui/modules/justification/justificattion_page.dart';
import 'package:lamb_talent/ui/modules/license_permit/components/form_license_permit.dart';
import 'package:lamb_talent/ui/modules/license_permit/license_permit_page.dart';
import 'package:lamb_talent/ui/modules/overtime/components/form_overtime.dart';
import 'package:lamb_talent/ui/modules/overtime/overtime_page.dart';
import 'package:platform_device_id/platform_device_id.dart';
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
  RxString optionMarking = 'A'.obs;
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

  int counterVerify = 1;

  RxString codeModule = '16120101'.obs;
  bool isListApprove = false;

  RxString numDocument = ''.obs;
  RxString numDocQr = ''.obs;

  StreamSubscription<Position>? positionStreamSubscription;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void onReady() {
    LocationUser().initLocationUser();
    changeLocationUser();
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
  void onClose() {
    if (positionStreamSubscription != null) {
      positionStreamSubscription!.cancel();
    }
    refreshController.dispose();
    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void dispose() {
    if (positionStreamSubscription != null) {
      positionStreamSubscription!.cancel();
    }

    refreshController.dispose();
    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  changeLocationUser() async {
    bool serviceEnabled = true;
    LocationPermission permission = LocationPermission.denied;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      serviceEnabled = false;
    }
    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      serviceEnabled = false;
    }
    late LocationSettings locationSettings;
    if (serviceEnabled) {
      if (Platform.isAndroid) {
        locationSettings = AndroidSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 0,
            forceLocationManager: false
            /* //(Optional) Set foreground notification config to keep the app alive 
    //when going to the background
    foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText:
        "Example app will continue to receive your location even when you aren't using it",
        notificationTitle: "Running in Background",
        enableWakeLock: true,
    ) */
            );
      } else if (Platform.isIOS || Platform.isMacOS) {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.high,
          activityType: ActivityType.other,
          distanceFilter: 0,
          pauseLocationUpdatesAutomatically: false,
          // Only set to true if our app will be started up in the background.
          showBackgroundLocationIndicator: false,
        );
      } else {
        locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        );
      }
      if (positionStreamSubscription == null) {
        final positionStream =
            Geolocator.getPositionStream(locationSettings: locationSettings);
        positionStreamSubscription = positionStream.handleError((error) {
          positionStreamSubscription!.cancel();
          positionStreamSubscription = null;
        }).listen((Position? position) {
          if (position != null) {
            // print('UBICACION');
            // print(position.latitude);
            // print(position.longitude);
            /* Get.snackbar(
                'UBICACION:',
                position.latitude.toString() +
                    ',' +
                    position.longitude.toString(),
                colorText: ColorsApp.white,
                backgroundColor: ColorsApp.success); */
            userPreferences.latitude = position.latitude.toString();
            userPreferences.longitude = position.longitude.toString();
          }
        });
        //positionStreamSubscription?.pause();
      }
    }
  }

  void _listAllData() async {
    loadingIndicator(onlyLoading: true, opacity: false);
    await _getInfoAssistance();
    refreshController.loadNoData();
    loadingData.value = true;
    loadingData.value = false;
  }

  Future _verifyButtonAssistance() async {
    Get.until((route) => !Get.isDialogOpen!);
    loadingIndicator(onlyLoading: true, opacity: false);
    await _getButtonAssitance(userPreferences.longitude.toString(),
        userPreferences.latitude.toString());
  }

  Future _getButtonAssitance(String longitude, String latitude) async {
    Map<String, String> params = {
      'lng': longitude,
      'lat': latitude,
      'id_entidad': userPreferences.idEntity.toString(),
      'id_depto': userPreferences.idDeparment.toString()
    };

    final markingService = MarkingService();

    final response = await markingService.showButtonAssistance(params);

    if (response.success) {
      showButton.value = response.data['show_button'] ?? '0';
      textButton.value = response.data['text_button'] ?? '';
      codeModality.value = response.data['code_modality'] ?? '';
      idDescripMarcacion.value = response.data['id_descrip_marcacion'] ?? '';
      hourMarking.value = response.data['fecha_hora'] ?? '';
      minutosTolerancia.value = response.data['minutos_tolerancia'] != null
          ? int.parse(response.data['minutos_tolerancia'].toString())
          : 0;
      optionMarking.value = response.data['option'] ?? '';
      if ((showButton.value == '3' || showButton.value == '4') &&
          !isMarking.value) {
        Get.until((route) => !Get.isDialogOpen!);
        Get.snackbar('Mensaje:', response.message,
            duration: const Duration(seconds: 8),
            colorText: ColorsApp.white,
            backgroundColor: ColorsApp.warning);
      } else {
        isMarking.value = false;
      }
      if (showButton.value == '4' &&
          counterVerify <= 5 &&
          !userPreferences.isWorkerChild) {
        Future.delayed(Duration(seconds: counterVerify), () {
          counterVerify++;
          _verifyButtonAssistance();
        });
      }
    }

    refreshController.loadNoData();
    loadingData.value = true;
    loadingData.value = false;
    Get.until((route) => !Get.isDialogOpen!);
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final permission = await Geolocator.checkPermission();
    if (codeModality.value == 'TP' && !serviceEnabled) {
      await _serviceLocationDisable(refreshShowButton: true);
    } else if (codeModality.value == 'TP' &&
        (permission != LocationPermission.always &&
            permission != LocationPermission.whileInUse)) {
      await _serviceLocationDenied(refreshShowButton: true);
    }
  }

  Future _getInfoAssistance() async {
    final Map<String, String> params = {
      'id_anho': DateTime.now().year.toString(),
      'id_mes': DateTime.now().month.toString(),
      'id_entidad': userPreferences.idEntity.toString(),
      /* 'id_depto': userPreferences.idDeparment.toString(), */
      'id_trabajador': userPreferences.idWorker.toString(),
      'codigo_modulo': codeModule.value,
      'lng': userPreferences.longitude.toString(),
      'lat': userPreferences.latitude.toString(),
      'include_show_button': userPreferences.isWorkerChild ? '0' : '1',
      'include_actions': '0',
      'include_access_level': '1'
    };
    final assistanceSummaryService = AssistanceSummaryService();
    final resp = await assistanceSummaryService.getInfoAssistance(params);
    if (resp.success) {
      final dataResponse = resp.data;
      if (dataResponse != null) {
        await _parseDataAssistance(dataResponse);
      }
    } else {
      Get.until((route) => !Get.isDialogOpen!);
      loadingData.value = true;
      loadingData.value = false;
    }
  }

  Future _parseDataAssistance(Map<String, dynamic> dataResponse) async {
    if (dataResponse.containsKey('access_level')) {
      final accessLevel =
          AccesoNivelUser.fromJson(dataResponse['access_level'] ?? '');
      userPreferences.idNivelAcceso =
          accessLevel.accesoNivel!.idAccesoNivel != null
              ? accessLevel.accesoNivel!.idAccesoNivel.toString()
              : '';
      if (accessLevel.accesoNivel!.idTipoNivelVista != null &&
          accessLevel.accesoNivel!.idTipoNivelVista != '5') {
        userPreferences.searchPerson = true;
      } else {
        userPreferences.searchPerson = false;
      }
      loadingData.value = true;
      loadingData.value = false;
    }
    if (dataResponse.containsKey('chart_data')) {
      List<dynamic> jsonList = dataResponse['chart_data'] as List;
      List<AssistanceSummaryModel> list = jsonList
          .map((jsonElement) => AssistanceSummaryModel.fromJson(jsonElement))
          .toList();
      listData = list;
      loadingData.value = true;
      loadingData.value = false;
    }
    if (dataResponse.containsKey('slider_data')) {
      dataCarousel = dataResponse['slider_data'];
      loadingData.value = true;
      loadingData.value = false;
    }
    if (dataResponse.containsKey('button_marking') &&
        !userPreferences.isWorkerChild) {
      showButton.value = dataResponse['button_marking']['show_button'] ?? '0';
      textButton.value = dataResponse['button_marking']['text_button'] ?? '';
      codeModality.value =
          dataResponse['button_marking']['code_modality'] ?? '';
      idDescripMarcacion.value =
          dataResponse['button_marking']['id_descrip_marcacion'] ?? '';
      hourMarking.value = dataResponse['button_marking']['fecha_hora'] ?? '';
      minutosTolerancia.value = dataResponse['button_marking']
                  ['minutos_tolerancia'] !=
              null
          ? int.parse(
              dataResponse['button_marking']['minutos_tolerancia'].toString())
          : 0;
      optionMarking.value = dataResponse['button_marking']['option'] ?? '';
      if ((showButton.value == '3' || showButton.value == '4') &&
          !isMarking.value) {
        Get.until((route) => !Get.isDialogOpen!);
        Get.snackbar('Mensaje:', dataResponse['button_marking']['message'],
            duration: const Duration(seconds: 8),
            colorText: ColorsApp.white,
            backgroundColor: ColorsApp.warning);
      } else {
        isMarking.value = false;
      }
      loadingData.value = true;
      loadingData.value = false;
      Get.until((route) => !Get.isDialogOpen!);
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      final permission = await Geolocator.checkPermission();
      if (codeModality.value == 'TP' && !serviceEnabled) {
        await _serviceLocationDisable(refreshShowButton: true);
      } else if (codeModality.value == 'TP' &&
          (permission != LocationPermission.always &&
              permission != LocationPermission.whileInUse)) {
        await _serviceLocationDenied(refreshShowButton: true);
      }
      if (showButton.value == '4' && counterVerify <= 5) {
        Future.delayed(Duration(seconds: counterVerify), () {
          counterVerify++;
          _verifyButtonAssistance();
        });
      }
    } else {
      Get.until((route) => !Get.isDialogOpen!);
    }
  }

  void onRefresh() async {
    await _getInfoAssistance();
    refreshController.refreshCompleted();
    refreshController.loadNoData();
    loadingData.value = true;
    loadingData.value = false;
  }

  void markingAssistance() async {
    loadingIndicator(onlyLoading: false, text: 'Guardando...');
    // final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    String uuid = await PlatformDeviceId.getDeviceId ?? '';
    /* if (GetPlatform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      uuid = androidInfo.id; //UUID for Android reemplaze for pedro
      //uuid = androidInfo.androidId!; //UUID for Android
    } else if (GetPlatform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      uuid = iosInfo.identifierForVendor!; //UUID for iOS
    } */

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (codeModality.value == 'TP') {
        Get.until((route) => !Get.isDialogOpen!);
        await _serviceLocationDisable(refreshShowButton: false);
      } else {
        continuoMarkingAssistance(uuid, '0', '0');
      }
      return;
    }

    final permission = await Geolocator.checkPermission();
    if ((permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse)) {
      if (codeModality.value == 'TP') {
        Get.until((route) => !Get.isDialogOpen!);
        await _serviceLocationDisable(refreshShowButton: false);
      } else {
        continuoMarkingAssistance(uuid, '0', '0');
      }
      return;
    }
    await continuoMarkingAssistance(uuid, userPreferences.longitude.toString(),
        userPreferences.latitude.toString());
  }

  Future continuoMarkingAssistance(
      String uuid, String longitude, String latitude) async {
    Map<String, String> params = {
      'uuid': uuid,
      'lng': longitude,
      'lat': latitude,
      'codigo_modalidad': codeModality.value.toString(),
      'id_descrip_marcacion': idDescripMarcacion.toString(),
      'id_entidad': userPreferences.idEntity.toString(),
      'id_depto': userPreferences.idDeparment.toString(),
      'option': optionMarking.value.toString()
    };

    final markingService = MarkingService();
    final marking = await markingService.workerMarking(params);
    Get.until((route) => !Get.isDialogOpen!);
    if (marking.success) {
      isMarking.value = true;
      loadingIndicator(onlyLoading: true, opacity: false);
      showButton.value = '0';
      optionMarking.value = 'A';
      loadingData.value = true;
      loadingData.value = false;
      // userPreferences.optionLocation == '2';
      await _getInfoAssistance();
      Get.until((route) => !Get.isDialogOpen!);
      loadingData.value = true;
      loadingData.value = false;
    } else {
      optionMarking.value = 'A';
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

  void fnShowModalQr() {
    numDocument.value = userPreferences.nroDocument.toString();
    numDocQr.value = userPreferences.nroDocument.toString();
    showModalQr();
  }

  void goToMarkings() {
    Get.to(() => MyMarkingsPage(), transition: Transition.size);
  }

  void goToJustification() {
    isListApprove = false;
    Get.to(() => const JustificationPage(), transition: Transition.size);
  }

  void goToOvertimes() {
    isListApprove = false;
    Get.to(() => const OvertimePage(), transition: Transition.size);
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
        await _getListData();
        loadingData.value = true;
        loadingData.value = false;
        Get.until((route) => !Get.isDialogOpen!);
      }
    }
  }

  void goToOvertimeApprove() async {
    isListApprove = true;
    final result = await Get.to(
        () => const OvertimePage(
              approve: true,
              title: 'Aprobar Sobretiempos',
            ),
        transition: Transition.size);
    if (result != null) {
      if (result['change'] == 'true' || result['change'] == true) {
        loadingIndicator(onlyLoading: true, opacity: false);
        await _getListData();
        loadingData.value = true;
        loadingData.value = false;
        Get.until((route) => !Get.isDialogOpen!);
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
        loadingData.value = true;
        loadingData.value = false;
        Get.until((route) => !Get.isDialogOpen!);
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
        loadingData.value = true;
        loadingData.value = false;
        Get.until((route) => !Get.isDialogOpen!);
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
        loadingData.value = true;
        loadingData.value = false;
        Get.until((route) => !Get.isDialogOpen!);
      }
    }
  }

  void goToFormOvertime() async {
    final result = await Get.to(() => FormOvertime(arguments: OvertimeModel()),
        transition: Transition.size);
    if (result != null) {
      if (result['change'] == 'true' || result['change'] == true) {
        loadingIndicator(onlyLoading: true, opacity: false);
        await _getListData();
        loadingData.value = true;
        loadingData.value = false;
        Get.until((route) => !Get.isDialogOpen!);
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
        loadingData.value = true;
        loadingData.value = false;
        Get.until((route) => !Get.isDialogOpen!);
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
      'codigo_modulo': codeModule.value,
      'lng': userPreferences.longitude.toString(),
      'lat': userPreferences.latitude.toString(),
      'include_show_button': '0',
      'include_actions': '0',
      'include_access_level': '0'
    };
    final assistanceSummaryService = AssistanceSummaryService();
    final resp = await assistanceSummaryService.getInfoAssistance(params);
    if (resp.success) {
      final dataResponse = resp.data;
      if (dataResponse != null) {
        await _parseDataAssistance(dataResponse);
      }
    }
  }

  void fnVacation(BuildContext buildContext) async {
    if (dataCarousel != null && dataCarousel!.containsKey('vacacion')) {
      if (dataCarousel!['vacacion']['codigo'].toString() == '01' ||
          dataCarousel!['vacacion']['codigo'].toString() == '02') {
        //print('marcar vacaciones');
        HolidayModel vacacion =
            HolidayModel.fromJson(dataCarousel!['vacacion']['vacacion']);
        String type = vacacion.inihabilitar == '1'
            ? 'S'
            : vacacion.finhabilitar == '1'
                ? 'R'
                : '';
        final sign = await showModalSSign(vacacion, type, buildContext);
        if (sign) {
          loadingIndicator(onlyLoading: true, opacity: false);
          await _getListData();
          Get.until((route) => !Get.isDialogOpen!);
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
      LocationUser().initLocationUser();
      if (positionStreamSubscription != null) {
        positionStreamSubscription!.cancel();
      }
      changeLocationUser();
      openSetting = false;
      loadingIndicator(onlyLoading: true, opacity: false);
      _verifyButtonAssistance();
    } else if (state == AppLifecycleState.resumed && openLocation) {
      LocationUser().initLocationUser();
      if (positionStreamSubscription != null) {
        positionStreamSubscription!.cancel();
      }
      changeLocationUser();
      openLocation = false;
      loadingIndicator(onlyLoading: true, opacity: false);
      _verifyButtonAssistance();
    }
  }
}
