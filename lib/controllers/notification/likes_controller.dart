import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/notification/relation_person.dart';
import 'package:lamb_talent/resources/models/response.dart';
import 'package:lamb_talent/resources/services/notification/notification_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LikesController extends GetxController {
  final String origen;
  final String idOrigen;
  LikesController({required this.origen, required this.idOrigen});
  final scrollController = ScrollController();
  final refreshController = RefreshController(initialRefresh: false);
  final userPref = UserPreferences();
  final search = TextEditingController();

  List<RelationPersonModel> listData = [];
  ApiResponse pagination = ApiResponse(success: true, data: {}, message: '');
  RxBool loadingData = false.obs;
  RxInt perPage = 10.obs;
  RxInt page = 1.obs;

  @override
  void onReady() {
    initValues();
    getListDataInitial();
    super.onReady();
  }

  void initValues() {
    page.value = 1;
    perPage.value = 20;
    listData = [];
  }

  void getListDataInitial() async {
    loadingIndicator(onlyLoading: true, opacity: false);
    await Jiffy.setLocale("es");
    await getListMoreData();
    loadingData.value = true;
    Get.until((route) => !Get.isDialogOpen!);
  }

  Future getListMoreData() async {
    final Map<String, String> params = {
      'origen': origen,
      'text_search': search.text,
      'id_origen': idOrigen,
      'per_page': perPage.value.toString(),
      'page': page.value.toString()
    };
    final notificationService = NotificationService();
    pagination = await notificationService.getLikes(params);
    List<dynamic> jsonList;
    if (pagination.data == null || pagination.data.runtimeType == String) {
      jsonList = [];
    } else {
      jsonList = pagination.data as dynamic;
    }
    if (jsonList.isNotEmpty) {
      List<RelationPersonModel> list = jsonList
          .map((jsonElement) => RelationPersonModel.fromJson(jsonElement))
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

  @override
  void onClose() {
    search.dispose();
    scrollController.dispose();
    refreshController.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    search.dispose();
    scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  void onRefresh() async {
    final Map<String, String> params = {
      'origen': origen,
      'id_origen': idOrigen,
      'text_search': search.text,
      'per_page': perPage.value.toString(),
      'page': '1'
    };
    final notificationService = NotificationService();
    pagination = await notificationService.getLikes(params);
    List<dynamic> jsonList;
    if (pagination.data == null || pagination.data.runtimeType == String) {
      jsonList = [];
    } else {
      jsonList = pagination.data as List<dynamic>;
    }

    List<RelationPersonModel> list = jsonList
        .map((jsonElement) => RelationPersonModel.fromJson(jsonElement))
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

  void onListData() async {
    loadingIndicator(onlyLoading: true, opacity: false);
    final Map<String, String> params = {
      'origen': origen,
      'id_origen': idOrigen,
      'text_search': search.text,
      'per_page': perPage.value.toString(),
      'page': '1'
    };
    final notificationService = NotificationService();
    pagination = await notificationService.getLikes(params);
    List<dynamic> jsonList =
        pagination.data == null ? [] : pagination.data as List<dynamic>;

    List<RelationPersonModel> list = jsonList
        .map((jsonElement) => RelationPersonModel.fromJson(jsonElement))
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
    Get.until((route) => !Get.isDialogOpen!);
  }

  goToBack() {
    Get.until((route) => !Get.isDialogOpen!);
    Get.back();
  }
}
