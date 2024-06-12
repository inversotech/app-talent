import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/general/file.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/response.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AccountStatusService {
  Future getAccountStatus(String params) async {
    try {
      final apiProvider = ApiProvider();
      final response = await apiProvider.getAll(
          endPoint:
              endPoints['account-status']['account-status'] + '/' + params);
      //_apiProvider.dispose();
      if (response.success) {
        return response.data;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future getItems(Map<String, String> entity) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['account-status']['account-status-items'],
        params: entity);
    //_apiProvider.dispose();
    if (response.success) {
      return response.data;
    } else {
      return null;
    }
  }

  Future getIncomes(Map<String, String> entity) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['account-status']['account-status-items-incomes'],
        params: entity);
    //_apiProvider.dispose();
    if (response.success) {
      return response.data;
    } else {
      return null;
    }
  }

  Future getDiscounts(Map<String, String> entity) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['account-status']['account-status-items-discounts'],
        params: entity);
    //_apiProvider.dispose();
    if (response.success) {
      return response.data;
    } else {
      return null;
    }
  }

  Future getHelpsIncomes(Map<String, String> entity) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['account-status']['account-status-helps-incomes'],
        params: entity);
    //_apiProvider.dispose();
    if (response.success) {
      return response.data;
    } else {
      return null;
    }
  }

  Future getHelpsDiscounts(Map<String, String> entity) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['account-status']['account-status-helps-discounts'],
        params: entity);
    //_apiProvider.dispose();
    if (response.success) {
      return response.data;
    } else {
      return null;
    }
  }

  Future getTravelsIncomes(Map<String, String> entity) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['account-status']['account-status-travels-incomes'],
        params: entity);
    //_apiProvider.dispose();
    if (response.success) {
      return response.data;
    } else {
      return null;
    }
  }

  Future getTravelsDiscounts(Map<String, String> entity) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['account-status']
            ['account-status-travels-discounts'],
        params: entity);
    //_apiProvider.dispose();
    if (response.success) {
      return response.data;
    } else {
      return null;
    }
  }

  Future getDetailsAccount(Map<String, String> entity) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['account-status']
            ['account-status-personal-agreement-detail'],
        params: entity);
    //_apiProvider.dispose();
    if (response.success) {
      return response.data;
    } else {
      return null;
    }
  }

  Future<FileModel> gePaymentstTicketMonth(Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['workerportal']['payments-ticket-month'],
        params: params);
    //_apiProvider.dispose();
    if (response.success) {
      return FileModel.fromJson(response.data);
    } else {
      return FileModel.fromJson({});
    }
  }

  Future<File> createFileOfPdfUrl(String url, String filename) async {
    Completer<File> completer = Completer();
    try {
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await p.getTemporaryDirectory();
      File file = File("${dir.path}/$filename");
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      Get.until((route) => !Get.isDialogOpen!);
      Get.snackbar('Mensaje:', 'No se puede ver el archivo',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.danger);
    }
    return completer.future;
  }

  Future<ApiResponse> downloadFileWithPath(String urlFile, String fileName,
      Map<String, String> params, BuildContext context) async {
    try {
      var response = ApiResponse.fromJsonNull();
      if (await canLaunchUrlString(urlFile.toString())) {
        await launchUrlString(
          urlFile.toString(),
        );
      } else {
        Get.until((route) => !Get.isDialogOpen!);
        Get.snackbar('Mensaje:',
            'No se puede abrir el navegador web o no hay un navegador web instalado',
            duration: const Duration(seconds: 8),
            colorText: ColorsApp.white,
            backgroundColor: ColorsApp.danger);
      }
      return response;
    } catch (e) {
      Get.until((route) => !Get.isDialogOpen!);
      Get.snackbar('Mensaje:', 'No se procedió con la descarga',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.danger);
      return ApiResponse.fromJsonNull();
    }
  }

  Future<ApiResponse> downloadPaymentTicket(
      String urlFile, String filename) async {
    ApiResponse response = ApiResponse.fromJsonNull();

    final status = await Permission.storage.request();
    var isGranted = status.isGranted;

    // Add to Android 13 and above
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if ((info.version.sdkInt) >= 33) {
        isGranted = true;
      }
    }

    if (isGranted) {
      final Directory? baseStorage;
      if (Platform.isAndroid) {
        baseStorage = await p.getExternalStorageDirectory();
      } else {
        baseStorage = await p.getApplicationDocumentsDirectory();
      }
      await FlutterDownloader.enqueue(
          url: urlFile,
          savedDir: baseStorage!.path,
          fileName: filename,
          showNotification:
              true, // show download progress in status bar (for Android)
          openFileFromNotification:
              true, // click on notification to open downloaded file (for Android)
          saveInPublicStorage: true);
    } else {
      Get.until((route) => !Get.isDialogOpen!);
      Get.snackbar('Mensaje:', 'Debe otogar permiso para descargar archivos.',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.danger);
      openAppSettings();
    }
    return response;
  }

  Future saveDownloadPaymentTicket(Map<String, String> params) async {
    ApiResponse response = ApiResponse.fromJsonNull();
    final userPreferences = UserPreferences();
    if (!userPreferences.isWorkerChild) {
      final apiProvider = ApiProvider();
      response = await apiProvider.putNotId(
          endPoint: endPoints['workerportal']['payments-ticket'],
          params: params,
          showMessage: false);
      if (response.success) {
        Get.snackbar('Mensaje:', 'Descarga completada.',
            duration: const Duration(seconds: 8),
            colorText: ColorsApp.white,
            backgroundColor: ColorsApp.success);
      }
    } else {
      Get.snackbar('Mensaje:', 'Descarga completada.',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.success);
    }
  }
}
