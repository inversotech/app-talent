import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/notification/comment.dart';
import 'package:lamb_talent/resources/models/response.dart';
import 'package:lamb_talent/resources/services/notification/notification_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'notification_controller.dart';

class CommentController extends GetxController {
  final String origen;
  final String idOrigen;
  final String idParent;
  final int indexOrigen;
  CommentController(
      {required this.origen,
      required this.idOrigen,
      required this.indexOrigen,
      this.idParent = ''});
  final scrollController = ScrollController();
  final refreshController = RefreshController(initialRefresh: false);
  final userPref = UserPreferences();
  final mensaje = TextEditingController();
  final parentController = Get.find<NotificationController>();
  FocusNode focusNode = FocusNode();
  ApiResponse pagination = ApiResponse(success: true, data: {}, message: '');
  List<CommentModel> listData = [];
  RxBool loadingData = false.obs;
  RxInt perPage = 15.obs;
  RxInt page = 1.obs;
  String idOrigenSave = '';
  String origenComment = '';
  bool isPressedDelete = false;
  RxBool answerParent = false.obs;
  RxString answerUserParent = ''.obs;
  int indexAnswerParent = 0;

  @override
  void onInit() {
    idOrigenSave = idOrigen;
    origenComment = origen;
    super.onInit();
  }

  @override
  void onReady() {
    initValues();
    getListDataInitial();
    super.onReady();
  }

  @override
  void dispose() {
    focusNode.dispose();
    mensaje.dispose();
    scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  void initValues() {
    page.value = 1;
    perPage.value = 15;
    listData = [];
    idOrigenSave = idOrigen;
    origenComment = origen;
    isPressedDelete = false;
    answerParent.value = false;
    answerUserParent.value = '';
    indexAnswerParent = 0;
  }

  void getListDataInitial() async {
    loadingIndicator(onlyLoading: true, opacity: false);
    await Jiffy.locale("es");
    await getListMoreData();
    loadingData.value = true;
    Get.until((route) => !Get.isDialogOpen!);
  }

  Future getListMoreData() async {
    final Map<String, String> params = {
      'origen': origen,
      'id_persona_like': userPref.idPerson.toString(),
      'id_origen': idOrigen,
      'id_parent': idParent,
      'per_page': perPage.value.toString(),
      'page': page.value.toString()
    };
    final notificationService = NotificationService();
    pagination = await notificationService.getComments(params);
    List<dynamic> jsonList;
    if (pagination.data == null || pagination.data.runtimeType == String) {
      jsonList = [];
    } else {
      jsonList = pagination.data as dynamic;
    }
    if (jsonList.isNotEmpty) {
      List<CommentModel> list = jsonList
          .map((jsonElement) => CommentModel.fromJson(jsonElement))
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
      'origen': origen,
      'id_origen': idOrigen,
      'id_persona_like': userPref.idPerson.toString(),
      'id_parent': idParent,
      'per_page': perPage.value.toString(),
      'page': '1'
    };
    final notificationService = NotificationService();
    pagination = await notificationService.getComments(params);
    List<dynamic> jsonList;
    if (pagination.data == null || pagination.data.runtimeType == String) {
      jsonList = [];
    } else {
      jsonList = pagination.data as List<dynamic>;
    }
    List<CommentModel> list = jsonList
        .map((jsonElement) => CommentModel.fromJson(jsonElement))
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

  fnSaveComment(String idComment, int index) async {
    loadingIndicator(onlyLoading: true, opacity: false);
    final Map<String, String> params = {
      'id_parent': '',
      'origen': origenComment,
      'id_origen': idOrigenSave,
      'id_persona': userPref.idPerson.toString(),
      'mensaje': mensaje.text
    };
    final notificationService = NotificationService();
    final resp = await notificationService.saveComment(params);
    if (resp.success) {
      if (origenComment == origen) {
        listData = [CommentModel.fromJson(resp.data), ...listData];
      } else {
        if (listData[indexAnswerParent].countComentarios! <= 0) {
          listData[indexAnswerParent].showMore = false;
        }
        listData[indexAnswerParent].comentarios = [
          CommentModel.fromJson(resp.data),
          ...listData[indexAnswerParent].comentarios!
        ];
        listData[indexAnswerParent].countComentarios =
            listData[indexAnswerParent].countComentarios! + 1;
      }
      parentController.listData[indexOrigen].countComentarios =
          parentController.listData[indexOrigen].countComentarios! + 1;
    }
    mensaje.clear();
    focusNode.unfocus();
    origenComment = origen;
    idOrigenSave = idOrigen;
    answerParent.value = false;
    indexAnswerParent = 0;
    loadingData.value = false;
    loadingData.value = true;
    Get.until((route) => !Get.isDialogOpen!);
  }

  fnAnswerParent(CommentModel item, int index) {
    indexAnswerParent = index;
    answerUserParent.value = item.personaFullname.toString();
    origenComment = 'msm_comentario';
    idOrigenSave = item.idComentario.toString();
    answerParent.value = true;
    mensaje.clear();
    focusNode.requestFocus(FocusNode());
  }

  fnCloseAnswerParent() {
    origenComment = origen;
    idOrigenSave = idOrigen;
    indexAnswerParent = 0;
    answerUserParent.value = '';
    answerParent.value = false;
    mensaje.clear();
  }

  fnShowComments(CommentModel item, index) async {
    focusNode.unfocus();
    loadingIndicator(onlyLoading: true, opacity: false);
    int perPage = 5;
    final Map<String, String> params = {
      'origen': 'msm_comentario',
      'id_persona_like': userPref.idPerson.toString(),
      'id_origen': item.idComentario.toString(),
      'per_page': perPage.toString(),
      'page': item.page.toString()
    };
    final notificationService = NotificationService();
    final paginationNew = await notificationService.getComments(params);
    List<dynamic> jsonList =
        paginationNew.data == null ? [] : paginationNew.data as dynamic;
    if (jsonList.isNotEmpty) {
      List<CommentModel> list = jsonList
          .map((jsonElement) => CommentModel.fromJson(jsonElement))
          .toList();
      listData[index].comentarios!.addAll(list);
      listData[index].page++;
    }
    if (paginationNew.meta!.total <= perPage ||
        jsonList.length < perPage ||
        jsonList.isEmpty) {
      listData[index].showMore = false;
    }
    loadingData.value = false;
    loadingData.value = true;
    Get.until((route) => !Get.isDialogOpen!);
  }

  fnPressDelete(
      CommentModel item, int index, int indexChild, bool child) async {
    if (isPressedDelete && !item.pressDelete) {
      Get.snackbar('Mensaje:', 'Solo puede seleccionar uno a la vez.',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.warning);
    } else {
      if (child) {
        listData[index].comentarios![indexChild].pressDelete =
            !item.pressDelete;
      } else {
        listData[index].pressDelete = !item.pressDelete;
      }
      isPressedDelete = item.pressDelete;
      loadingData.value = false;
      loadingData.value = true;
    }
  }

  fnPressClose(CommentModel item, int index, int indexChild, bool child) async {
    isPressedDelete = false;
    if (child) {
      listData[index].comentarios![indexChild].pressDelete = false;
    } else {
      listData[index].pressDelete = false;
    }
    loadingData.value = false;
    loadingData.value = true;
  }

  fnPressDeleteComment(
      CommentModel item, int index, int indexChild, bool child) async {
    if (!child && item.countComentarios! > 0) {
      Get.snackbar(
          'Mensaje:', 'No se puede eliminar porque ya tiene respuestas.',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.danger);
    } else {
      loadingIndicator(onlyLoading: true, opacity: false);
      final notificationService = NotificationService();
      final resp =
          await notificationService.deleteComment(item.idComentario.toString());
      if (resp.success) {
        if (child) {
          listData[index].comentarios!.removeAt(indexChild);
          listData[index].countComentarios =
              listData[index].countComentarios! - 1;
        } else {
          listData.removeAt(index);
        }
        isPressedDelete = false;
        parentController.listData[indexOrigen].countComentarios =
            parentController.listData[indexOrigen].countComentarios! - 1;
      }
      loadingData.value = false;
      loadingData.value = true;
      Get.until((route) => !Get.isDialogOpen!);
    }
  }

  fnPressLikeComment(
      CommentModel item, int index, int indexChild, bool child) async {
    final Map<String, String> params = {
      'origen': 'msm_comentario',
      'id_origen': item.idComentario.toString(),
      'id_persona': userPref.idPerson.toString()
    };
    final notificationService = NotificationService();
    final resp = await notificationService.saveLike(params);
    if (resp.success) {
      if (child) {
        listData[index].comentarios![indexChild].like = item.like;
        listData[index].comentarios![indexChild].countLikes = item.like
            ? item.countLikes! + 1
            : listData[index].comentarios![indexChild].countLikes! - 1;
      } else {
        listData[index].like = item.like;
        listData[index].countLikes =
            item.like ? item.countLikes! + 1 : listData[index].countLikes! - 1;
      }
    }
    loadingData.value = false;
    loadingData.value = true;
  }

  goToBack() {
    Get.until((route) => !Get.isDialogOpen!);
    Get.back();
  }
}
