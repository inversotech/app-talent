import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/routers_names.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/notification/event.dart';
import 'package:lamb_talent/resources/models/notification/group.dart';
import 'package:lamb_talent/resources/services/notification/notification_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:lamb_talent/ui/modules/notification/components/show_photo.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailController extends GetxController {
  final String id;
  EventDetailController({required this.id});
  final scrollController = ScrollController();
  final refreshController = RefreshController(initialRefresh: false);
  EventModel event = EventModel();
  List<GroupModel> listGroups = [];
  final userPreferences = UserPreferences();
  String origen = 'msm_evento';
  final storage = GetStorage();
  String token = '';

  RxBool buttonAssitance = false.obs;
  RxBool loadingData = true.obs;

  @override
  void onInit() {
    super.onInit();
    token = storage.read('tokenLamb');
  }

  @override
  void onReady() {
    if (event.idEvento == null) {
      loadingIndicator(
          onlyLoading: true, opacity: false, colorLoading: ColorsApp.white);
    } else {
      loadingIndicator(onlyLoading: true, opacity: false);
    }
    _listAllData();
    super.onReady();
  }

  @override
  void dispose() {
    scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  void onRefresh() async {
    await _getEvent();
    await _listGroups();
    refreshController.refreshCompleted();
    refreshController.loadNoData();
    loadingData.value = true;
    loadingData.value = false;
  }

  void _listAllData() async {
    await _getEvent();
    await _listGroups();
    refreshController.loadNoData();
    loadingData.value = false;
    print('detalle event');
    Get.until((route) => !Get.isDialogOpen!);

    // Get.back();
  }

  Future _getEvent() async {
    final _notificationService = NotificationService();
    final response = await _notificationService.getEevent(id);
    event = EventModel.fromJson(response.data);
    await _changeRelationPerson();
  }

  Future _changeRelationPerson() async {
    final _notificationService = NotificationService();
    final _userPref = UserPreferences();
    final relationPerson = await _notificationService.getRelationPerson(
        origen, id, _userPref.idPerson.toString());
    if (relationPerson.estaLeido == null || relationPerson.estaLeido == '0') {
      Map<String, String> params = {
        'origen': origen,
        'id_origen': id,
        'id_persona': _userPref.idPerson.toString(),
        'esta_leido': '1'
      };
      await _notificationService.changeRelationPerson(
          origen, id, _userPref.idPerson.toString(), params);
    }
    if (event.addBtnAsistir != null && event.addBtnAsistir == '1') {
      if (relationPerson.seraParticipante != null ||
          relationPerson.seraParticipante == '1') {
        buttonAssitance.value = false;
      } else {
        buttonAssitance.value = true;
      }
    }
  }

  Future _listGroups() async {
    final Map<String, String> params = {'origen': origen, 'id_origen': id};
    final _notificationService = NotificationService();
    listGroups = await _notificationService.getGroups(params);
  }

  goToLinkUrl(String link) async {
    final notificationService = NotificationService();
    if (link.contains('http')) {
      await goToUrl(link);
    } else {
      final resp = await notificationService.getRouteStorageFile(link);
      if (resp.success) {
        await goToUrl(resp.data);
      }
    }
  }

  goToUrl(String link) async {
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(Uri.parse(link));
    } else {
      Get.snackbar('Mensaje:', 'No se puede ingresar al enlace',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.warning);
    }
  }

  registerAssistance() async {
    loadingIndicator(onlyLoading: true, opacity: false);
    final _notificationService = NotificationService();
    final _userPref = UserPreferences();
    Map<String, String> params = {
      'origen': origen,
      'id_origen': id,
      'id_persona': _userPref.idPerson.toString(),
      'sera_participante': '1'
    };
    final changeRegister = await _notificationService.changeRelationPerson(
        origen, id, _userPref.idPerson.toString(), params);
    if (changeRegister.success) {
      buttonAssitance.value = false;
    }
    Get.until((route) => !Get.isDialogOpen!);
  }

  goToBack(bool loadBack) {
    Get.until((route) => !Get.isDialogOpen!);
    if (loadBack) {
      Get.offAllNamed(RoutesName.notification);
    } else {
      Get.back();
    }
  }

  showPhoto(String imageUrl) {
    Get.to(() => ShowPhoto(imageUrl: imageUrl, token: token),
        transition: Transition.size, duration: const Duration(seconds: 0));
  }
}
