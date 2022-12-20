import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/general/file.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/response.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AccountStatusService {
  Future getAccountStatus(String params) async {
    try {
      final _apiProvider = ApiProvider();
      final response = await _apiProvider.getAll(
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
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
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
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
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
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
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
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
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
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
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
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
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
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
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
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
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
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
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
      if (Get.isDialogOpen!) {
        Get.back();
      }
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
        if (Get.isDialogOpen!) {
          Get.back();
        }
        Get.snackbar('Mensaje:',
            'No se puede abrir el navegador web o no hay un navegador web instalado',
            duration: const Duration(seconds: 8),
            colorText: ColorsApp.white,
            backgroundColor: ColorsApp.danger);
      }
      return response;
    } catch (e) {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      Get.snackbar('Mensaje:', 'No se procedió con la descarga',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.danger);
      return ApiResponse.fromJsonNull();
    }
  }

  Future<ApiResponse> saveDownloadPaymentTicket(
      String urlFile, String filename, Map<String, String> params) async {
    final userPreferences = UserPreferences();
    ApiResponse response = ApiResponse.fromJsonNull();
    bool showTicket = false;
    if (!userPreferences.isWorkerChild) {
      final _apiProvider = ApiProvider();
      response = await _apiProvider.putNotId(
          endPoint: endPoints['workerportal']['payments-ticket'],
          params: params);
      //_apiProvider.dispose();
      if (response.success) {
        showTicket = true;
      }
    } else if (userPreferences.isWorkerChild) {
      showTicket = true;
    }
    if (showTicket) {
      if (await canLaunchUrlString(urlFile.toString())) {
        await launchUrlString(
          urlFile.toString(),
          webViewConfiguration: WebViewConfiguration(headers: {
            'Content-Type': 'application/force-download',
            'Content-Disposition': 'attachment',
            'filename': filename
          }),
/*         headers: {
          'Content-Type': 'application/force-download',
          'Content-Disposition': 'attachment',
          'filename': filename
        } */
        );
      } else {
        if (Get.isDialogOpen!) {
          Get.back();
        }
        Get.snackbar('Mensaje:',
            'No se puede abrir el navegador web o no hay un navegador web instalado',
            duration: const Duration(seconds: 8),
            colorText: ColorsApp.white,
            backgroundColor: ColorsApp.danger);
      }
    } else {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      Get.snackbar('Mensaje:', 'No se procedió con la descarga',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.danger);
    }
    return response;
  }
}
