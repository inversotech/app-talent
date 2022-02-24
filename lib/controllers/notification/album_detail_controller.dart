import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/routers_names.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/notification/album.dart';
import 'package:lamb_talent/resources/models/notification/group.dart';
import 'package:lamb_talent/resources/services/notification/notification_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:lamb_talent/ui/modules/notification/components/show_album_photo.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AlbumDetailController extends GetxController {
  final String id;
  AlbumDetailController({required this.id});
  final scrollController = ScrollController();
  final refreshController = RefreshController(initialRefresh: false);
  AlbumModel album = AlbumModel();
  List<GroupModel> listGroups = [];
  String origen = 'msm_album';

  RxBool loadingData = true.obs;
  @override
  void onReady() {
    _listAllData();
    super.onReady();
  }

  void onRefresh() async {
    await _getAlbum();
    await _listGroups();
    refreshController.refreshCompleted();
    refreshController.loadNoData();
    loadingData.value = true;
    loadingData.value = false;
  }

  void _listAllData() async {
    loadingIndicator(onlyLoading: true, opacity: false);
    await _getAlbum();
    await _listGroups();
    refreshController.loadNoData();
    if (Get.isDialogOpen!) {
      Get.back();
    }
    loadingData.value = false;
  }

  Future _getAlbum() async {
    final _notificationService = NotificationService();
    final response = await _notificationService.getalbum(id);
    album = AlbumModel.fromJson(response.data);
    await _changeRelationPerson();
  }

  Future _changeRelationPerson() async {
    final _notificationService = NotificationService();
    final _userPref = UserPreferences();
    Map<String, String> params = {
      'origen': origen,
      'id_origen': id,
      'id_persona': _userPref.idPerson.toString(),
      'esta_leido': '1'
    };
    await _notificationService.changeRelationPerson(
        origen, id, _userPref.idPerson.toString(), params);
  }

  Future _listGroups() async {
    final Map<String, String> params = {'origen': origen, 'id_origen': id};
    final _notificationService = NotificationService();
    listGroups = await _notificationService.getGroups(params);
  }

  goToBack(bool loadBack) {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    if (loadBack) {
      Get.offAllNamed(RoutesName.notification);
    } else {
      Get.back();
    }
  }

  showPhoto(String imageUrl) {
    Get.to(() => ShowAlbumPhoto(imageUrl: imageUrl),
        transition: Transition.size, duration: const Duration(seconds: 1));
  }
}
