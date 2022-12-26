import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/routers_names.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/notification/group.dart';
import 'package:lamb_talent/resources/models/notification/notification.dart';
import 'package:lamb_talent/resources/services/notification/notification_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';

class NotificationDetailController extends GetxController {
  final String id;
  NotificationDetailController({required this.id});
  final scrollController = ScrollController();
  final refreshController = RefreshController(initialRefresh: false);
  late VideoPlayerController controllerVideo;
  NotificationModel notification = NotificationModel();
  List<GroupModel> listGroups = [];
  String origen = 'msm_notificacion';
  RxBool loadingVideo = true.obs;

  RxBool loadingData = true.obs;
  @override
  void onReady() {
    _listAllData();
    super.onReady();
  }

  @override
  void dispose() {
    controllerVideo.dispose();
    super.dispose();
  }

  Future<ClosedCaptionFile> _loadCaptions() async {
    final String fileContents = await DefaultAssetBundle.of(Get.context!)
        .loadString('assets/bumble_bee_captions.vtt');
    return WebVTTCaptionFile(
        fileContents); // For vtt files, use WebVTTCaptionFile
  }

  void onRefresh() async {
    await _getNotification();
    await _listGroups();
    refreshController.refreshCompleted();
    refreshController.loadNoData();
    loadingData.value = true;
    loadingData.value = false;
  }

  void _listAllData() async {
    loadingIndicator(onlyLoading: true, opacity: false);
    await _getNotification();
    await _listGroups();
    refreshController.loadNoData();
    Get.until((route) => !Get.isDialogOpen!);
    loadingData.value = false;
  }

  Future _getNotification() async {
    final notificationService = NotificationService();
    final response = await notificationService.getNotification(id);
    notification = NotificationModel.fromJson(response.data);
    if (notification.addVideo == '1' &&
        notification.videoUrl != null &&
        notification.videoUrl!.isNotEmpty) {
      controllerVideo = VideoPlayerController.network(
        notification.videoUrl.toString(),
        closedCaptionFile: _loadCaptions(),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      controllerVideo.addListener(() {
        loadingVideo.value = false;
        loadingVideo.value = true;
      });
      controllerVideo.setLooping(true);
      controllerVideo.initialize();
    }
    await _changeRelationPerson();
  }

  Future _changeRelationPerson() async {
    final notificationService = NotificationService();
    final userPref = UserPreferences();
    Map<String, String> params = {
      'origen': origen,
      'id_origen': id,
      'id_persona': userPref.idPerson.toString(),
      'esta_leido': '1'
    };
    await notificationService.changeRelationPerson(
        origen, id, userPref.idPerson.toString(), params);
  }

  Future _listGroups() async {
    final Map<String, String> params = {'origen': origen, 'id_origen': id};
    final notificationService = NotificationService();
    listGroups = await notificationService.getGroups(params);
  }

  goToLinkUrl(String link) async {
    if (await canLaunchUrlString(link)) {
      await launchUrlString(link);
    } else {
      Get.snackbar('Mensaje:', 'No se puede ingresar al enlace',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.warning);
    }
  }

  goToBack(bool loadBack) {
    Get.until((route) => !Get.isDialogOpen!);
    if (loadBack) {
      Get.offAllNamed(RoutesName.notification);
    } else {
      Get.back();
    }
  }
}
