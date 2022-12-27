import 'dart:async';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lamb_talent/resources/services/auth/auth_service.dart';
import 'package:lamb_talent/ui/modules/notification/components/likes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/enviroment/enviroment.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/resources/models/notification/album.dart';
import 'package:lamb_talent/resources/models/notification/notification.dart';
import 'package:lamb_talent/resources/models/notification/notification_general.dart';
import 'package:lamb_talent/resources/services/notification/notification_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:lamb_talent/ui/modules/notification/components/album_detail.dart';
import 'package:lamb_talent/ui/modules/notification/components/comment.dart';
import 'package:lamb_talent/ui/modules/notification/components/event_detail.dart';
import 'package:lamb_talent/ui/modules/notification/components/notification_detail.dart';
import 'package:lamb_talent/ui/modules/notification/components/show_photo.dart';

class NotificationController extends GetxController {
  final refreshController = RefreshController(initialRefresh: false);
  final scrollController = ScrollController();
  final controllerCarousel = CarouselController();
  String idOrigen = '';
  String origen = '';
  final userPreferences = UserPreferences();
  final dataKeyScroll = GlobalKey();
  ApiResponse pagination = ApiResponse(success: true, data: {}, message: '');
  List<NotificationGeneralModel> listData = [];
  RxBool loadingData = true.obs;
  RxInt perPage = 5.obs;
  RxInt page = 1.obs;
  bool finishLoad = false;
  bool finishConsults = false;
  RxString codeModule = '16120104'.obs;
  final storage = GetStorage();
  String token = '';

  @override
  void onInit() {
    if (Get.arguments != null) {
      idOrigen = Get.arguments.containsKey('id_origen')
          ? Get.arguments['id_origen'].toString()
          : '';
      origen = Get.arguments.containsKey('origen')
          ? Get.arguments['origen'].toString()
          : '';
    }
    super.onInit();
  }

  @override
  void onReady() {
    token = storage.read('tokenLamb');
    initValues();
    getListDataInitial();
    super.onReady();
  }

  void initValues() {
    userPreferences.searchPerson = false;
    page.value = 1;
    perPage.value = 5;
    listData = [];
    finishLoad = false;
    finishConsults = false;
  }

  @override
  void dispose() {
    scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  void getListDataInitial() async {
    if (listData.isEmpty) {
      loadingIndicator(
          onlyLoading: true, opacity: false, colorLoading: ColorsApp.white);
    } else {
      loadingIndicator(onlyLoading: true, opacity: false);
    }
    await Jiffy.locale("es");
    await _getAccessNivel();
    await getListMoreData();
    Get.until((route) => !Get.isDialogOpen!);
    loadingIndicator(onlyLoading: true, opacity: false);
    finishConsults = true;
    loadingData.value = false;
    loadingData.value = true;
    if (!finishLoad && origen.isNotEmpty && !userPreferences.isWorkerChild) {
      await fnCheckIfNotificationArrived();
      loadingData.value = false;
      loadingData.value = true;
      Get.until((route) => !Get.isDialogOpen!);
      loadingIndicator(onlyLoading: true, opacity: false);
      await fnGotoItemScroll();
      finishLoad = true;
      await getTotalNoLeidos();
      loadingData.value = false;
      loadingData.value = true;
      Get.until((route) => !Get.isDialogOpen!);
    } else {
      await getTotalNoLeidos();
      finishConsults = true;
      loadingData.value = false;
      loadingData.value = true;
    }
    Get.until((route) => !Get.isDialogOpen!);
  }

  Future _getAccessNivel() async {
    final Map<String, String> params = {
      'codigo_acceso': codeModule.value.toString()
    };
    final authService = AuthService();
    final resp = await authService.getAccessNivel(params);
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

  Future fnCheckIfNotificationArrived() async {
    switch (origen) {
      case 'msm_album':
        await _changeRelationPerson();
        await fnGetAlbumById();
        break;
      case 'msm_notificacion':
        await _changeRelationPerson();
        await fnGetNotificationById();
        break;
      default:
    }
  }

  Future fnGetNotificationById() async {
    int findIndex = listData.indexWhere(
        (element) => element.id == idOrigen && element.codigo == origen);
    if (findIndex != -1) {
      listData[findIndex].globalKey = dataKeyScroll;
    } else {
      final notificationService = NotificationService();
      final resp = await notificationService.getNotification(idOrigen);
      if (resp.success) {
        NotificationModel notify = NotificationModel.fromJson(resp.data);
        listData.add(NotificationGeneralModel(
            id: notify.idNotificacion.toString(),
            codigo: 'msm_notificacion',
            mensaje: notify.mensaje,
            fechaInicio: notify.fecha,
            addArchivo: notify.addArchivo,
            archivoName: notify.archivoName,
            archivoUrl: notify.archivoUrl,
            addVideo: notify.addVideo,
            videoUrl: notify.videoUrl,
            addLink: notify.addLink,
            link: notify.link,
            estado: notify.estado,
            idEntidad: notify.idEntidad,
            nombreEntidad: notify.nombreEntidad,
            idPersona: notify.idPersona,
            imagenUrl: notify.imagenUrl,
            globalKey: dataKeyScroll));
      }
    }
  }

  Future fnGetAlbumById() async {
    int findIndex = listData.indexWhere(
        (element) => element.id == idOrigen && element.codigo == origen);
    if (findIndex != -1) {
      listData[findIndex].globalKey = dataKeyScroll;
    } else {
      final notificationService = NotificationService();
      final resp = await notificationService.getalbum(idOrigen);
      if (resp.success) {
        AlbumModel album = AlbumModel.fromJson(resp.data);
        listData.add(NotificationGeneralModel(
            id: album.idAlbum.toString(),
            codigo: 'msm_album',
            mensaje: album.nombre,
            descripcion: album.descripcion,
            fechaInicio: album.fecha,
            estado: album.estado,
            idEntidad: album.idEntidad,
            nombreEntidad: album.nombreEntidad,
            idPersona: album.idPersona,
            countComentarios: album.countComentarios,
            countLikes: album.countLikes,
            fotos: album.fotos,
            like: album.like,
            globalKey: dataKeyScroll));
      }
    }
  }

  Future fnGotoItemScroll() async {
    if (origen.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 2), () {
        Scrollable.ensureVisible(dataKeyScroll.currentContext!,
            duration: const Duration(seconds: 2), curve: Curves.easeInOutCubic);
      });
    }
  }

  Future getListMoreData() async {
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity != null
          ? userPreferences.idEntity.toString()
          : '',
      'id_persona': userPreferences.idPerson != null
          ? userPreferences.idPerson.toString()
          : '',
      'id_persona_like': userPreferences.idPerson != null
          ? userPreferences.idPerson.toString()
          : '',
      'code_fcm_app': Env.api.codeFcmApp,
      'per_page': perPage.value.toString(),
      'page': page.value.toString()
    };
    final notificationService = NotificationService();
    pagination = await notificationService.getNotifications(params);
    List<dynamic> jsonList;
    if (pagination.data == null || pagination.data.runtimeType == String) {
      jsonList = [];
    } else {
      jsonList = pagination.data as dynamic;
    }
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

  Future getTotalNoLeidos() async {
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity != null
          ? userPreferences.idEntity.toString()
          : '',
      'id_persona': userPreferences.idPerson != null
          ? userPreferences.idPerson.toString()
          : '',
      'code_fcm_app': Env.api.codeFcmApp,
    };
    final notificationService = NotificationService();
    final resp = await notificationService.totalNoLeidos(params);
    if (resp.success) {
      userPreferences.cantNotify = int.parse(resp.data.toString());
    }
  }

  void onRefresh() async {
    perPage.value = 5;
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity != null
          ? userPreferences.idEntity.toString()
          : '',
      'id_persona': userPreferences.idPerson != null
          ? userPreferences.idPerson.toString()
          : '',
      'id_persona_like': userPreferences.idPerson != null
          ? userPreferences.idPerson.toString()
          : '',
      'code_fcm_app': Env.api.codeFcmApp,
      'per_page': perPage.value.toString(),
      'page': '1'
    };
    final notificationService = NotificationService();
    pagination = await notificationService.getNotifications(params);
    List<dynamic> jsonList;
    if (pagination.data == null || pagination.data.runtimeType == String) {
      jsonList = [];
    } else {
      jsonList = pagination.data as List<dynamic>;
    }
    List<NotificationGeneralModel> list = jsonList
        .map((jsonElement) => NotificationGeneralModel.fromJson(jsonElement))
        .toList();
    listData = list;
    await getTotalNoLeidos();
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
    perPage.value = 2;
    await getListMoreData();
    if (userPreferences.cantNotify > 0) {
      await getTotalNoLeidos();
      loadingData.value = false;
      loadingData.value = true;
    }
  }

  goToDetail(NotificationGeneralModel item) {
    switch (item.codigo) {
      case 'msm_evento':
        Get.to(
            () => EventDetail(
                  id: item.id.toString(),
                  token: token,
                ),
            transition: Transition.size,
            duration: const Duration(seconds: 1));
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

  fnSaveLike(NotificationGeneralModel item, int index) async {
    final Map<String, String> params = {
      'origen': item.codigo.toString(),
      'id_origen': item.id.toString(),
      'id_persona': userPreferences.idPerson.toString()
    };
    final notificationService = NotificationService();
    final resp = await notificationService.saveLike(params);
    if (resp.success) {
      listData[index].like = item.like;
      listData[index].countLikes = item.like
          ? listData[index].countLikes! + 1
          : listData[index].countLikes! - 1;
    }

    loadingData.value = false;
    loadingData.value = true;
  }

  goToComents(
      NotificationGeneralModel item, bool autofocus, int indexOrigen) async {
    await Get.to(() => Comment(
        origen: item.codigo.toString(),
        idOrigen: item.id.toString(),
        focusState: autofocus,
        indexOrigen: indexOrigen));
    loadingData.value = false;
    loadingData.value = true;
  }

  goToLikes(NotificationGeneralModel item) async {
    Get.to(() =>
        Likes(origen: item.codigo.toString(), idOrigen: item.id.toString()));
  }

  shareFileImage(NotificationGeneralModel item) async {
    loadingIndicator(onlyLoading: true, opacity: false);
    // List<String> listPaths = [];
    List<XFile> listPaths = [];
    for (var i = 0; i < item.fotos!.length; i++) {
      print('token de acceso');
      print(token);
      print(
          '${Env.api.apiMessengerShell}storage/file?fileName=${item.fotos![i].imagenUrl.toString()}');
      final response = item.fotos![i].imagenUrl!.contains('http')
          ? await get(Uri.parse(item.fotos![i].imagenUrl.toString()))
          : await get(
              Uri.parse(
                  '${Env.api.apiMessengerShell}storage/file?fileName=${item.fotos![i].imagenUrl.toString()}'),
              headers: {'Authorization': token});
      final documentDirectory = (await getTemporaryDirectory()).path;
      File imgFile = File('$documentDirectory/${item.fotos![i].idAfoto}.png');
      imgFile.writeAsBytesSync(response.bodyBytes);
      listPaths.add(XFile(imgFile.path));
    }
    Get.until((route) => !Get.isDialogOpen!);
    Share.shareXFiles(listPaths, text: item.mensaje!);
    // Share.shareFiles(listPaths, text: item.mensaje!); // version anterior y ya esta depreciado.
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

  Future _changeRelationPerson() async {
    final notificationService = NotificationService();
    final userPref = UserPreferences();
    Map<String, String> params = {
      'origen': origen,
      'id_origen': idOrigen,
      'id_persona': userPref.idPerson.toString(),
      'esta_leido': '1'
    };
    await notificationService.changeRelationPerson(
        origen, idOrigen, userPref.idPerson.toString(), params);
  }

  showPhoto(String imageUrl) {
    Get.to(() => ShowPhoto(imageUrl: imageUrl, token: token),
        transition: Transition.size, duration: const Duration(seconds: 0));
  }

  showPhotos(List<String> photos, int index) {
    Get.to(
        () => ShowPhoto(
            isMultiple: true, token: token, photos: photos, indexStart: index),
        transition: Transition.size,
        duration: const Duration(seconds: 0));
  }
}
