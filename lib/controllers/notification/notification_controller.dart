import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/enviroment/enviroment.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/resources/models/notification/notification_general.dart';
import 'package:lamb_talent/resources/services/notification/notification_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:lamb_talent/ui/modules/notification/components/album_detail.dart';
import 'package:lamb_talent/ui/modules/notification/components/comment.dart';
import 'package:lamb_talent/ui/modules/notification/components/event_detail.dart';
import 'package:lamb_talent/ui/modules/notification/components/notification_detail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationController extends GetxController {
  final scrollController = ScrollController();
  final refreshController = RefreshController(initialRefresh: false);
  final userPreferences = UserPreferences();
  ApiResponse pagination = ApiResponse(success: true, data: {}, message: '');
  List<NotificationGeneralModel> listData = [];
  RxBool loadingData = false.obs;
  RxInt perPage = 5.obs;
  RxInt page = 1.obs;

  @override
  void onReady() {
    if (listData.isEmpty) {
      loadingIndicator(
          onlyLoading: true, opacity: false, colorLoading: ColorsApp.white);
    } else {
      loadingIndicator(onlyLoading: true, opacity: false);
    }
    initValues();
    getListDataInitial();
    super.onReady();
  }

  void initValues() {
    page.value = 1;
    perPage.value = 5;
    listData = [];
  }

  void getListDataInitial() async {
    await getListMoreData();
    if (Get.isDialogOpen!) {
      Get.back();
    }
    loadingData.value = true;
  }

  Future getListMoreData() async {
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity != null
          ? userPreferences.idEntity.toString()
          : '',
      'id_persona': userPreferences.idPerson != null
          ? userPreferences.idPerson.toString()
          : '',
      'code_fcm_app': codeFcmApp.toString(),
      'per_page': perPage.value.toString(),
      'page': page.value.toString()
    };
    final _notificationService = NotificationService();
    pagination = await _notificationService.getNotifications(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as dynamic;
    if (jsonList.isNotEmpty) {
      List<NotificationGeneralModel> list = jsonList
          .map((jsonElement) => NotificationGeneralModel.fromJson(jsonElement))
          .toList();
      listData.addAll(list);
      page.value++;
    }
    if (pagination.meta!.total <= perPage.value ||
        jsonList.length < perPage.value ||
        jsonList.isEmpty) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
    loadingData.value = false;
    loadingData.value = true;
  }

  void onRefresh() async {
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity != null
          ? userPreferences.idEntity.toString()
          : '',
      'id_persona': userPreferences.idPerson != null
          ? userPreferences.idPerson.toString()
          : '',
      'code_fcm_app': codeFcmApp.toString(),
      'per_page': perPage.value.toString(),
      'page': '1'
    };
    final _notificationService = NotificationService();
    pagination = await _notificationService.getNotifications(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<NotificationGeneralModel> list = jsonList
        .map((jsonElement) => NotificationGeneralModel.fromJson(jsonElement))
        .toList();
    listData = list;
    if (pagination.meta!.total <= perPage.value) {
      refreshController.refreshCompleted();
      refreshController.loadNoData();
    } else {
      refreshController.refreshCompleted();
      refreshController.loadComplete();
    }
    page.value = 2;

    loadingData.value = false;
    loadingData.value = true;
  }

  void onLoading() async {
    await getListMoreData();
  }

  goToDetail(NotificationGeneralModel item) {
    switch (item.codigo) {
      case 'msm_evento':
        Get.to(() => EventDetail(id: item.id.toString()),
            transition: Transition.size, duration: const Duration(seconds: 1));
        break;
      case 'msm_album':
        Get.to(() => AlbumDetail(id: item.id.toString()),
            transition: Transition.size, duration: const Duration(seconds: 1));
        break;
      case 'msm_notificacion':
        Get.to(() => NotificationDetail(id: item.id.toString()),
            transition: Transition.size, duration: const Duration(seconds: 1));
        break;
      default:
    }
  }

  fnSaveLike(Foto photo) async {
    final Map<String, String> params = {
      'origen': 'msm_album_foto',
      'id_origen': photo.idAfoto.toString(),
      'id_persona': userPreferences.idPerson.toString()
    };
    final _notificationService = NotificationService();
    await _notificationService.saveLike(params);
  }

  goToComents(Foto photo) {
    Get.to(() => Comment());
  }

  shareFileImage(Foto photo) {}
}
