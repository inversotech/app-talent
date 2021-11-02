import 'dart:async';
// import 'package:external_path/external_path.dart' as ep;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as p;
// import 'package:permission_handler/permission_handler.dart';
import 'package:upn_financiero_mobil/src/models/models.dart';
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/toast.dart';

class AccountStatusService {
  Future getAccountStatus(String params) async {
    try {
      final response = await ApiRestService.get(
          endPoint:
              endPoints['account-status']['account-status'] + '/' + params);
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
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['account-status']['account-status-items'],
        body: entity);
    if (response.success) {
      return response.data;
    } else {
      return null;
    }
  }

  Future getIncomes(Map<String, String> entity) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['account-status']['account-status-items-incomes'],
        body: entity);
    if (response.success) {
      return response.data;
    } else {
      return null;
    }
  }

  Future getDiscounts(Map<String, String> entity) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['account-status']['account-status-items-discounts'],
        body: entity);
    if (response.success) {
      return response.data;
    } else {
      return null;
    }
  }

  Future getHelpsIncomes(Map<String, String> entity) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['account-status']['account-status-helps-incomes'],
        body: entity);
    if (response.success) {
      return response.data;
    } else {
      return null;
    }
  }

  Future getHelpsDiscounts(Map<String, String> entity) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['account-status']['account-status-helps-discounts'],
        body: entity);
    if (response.success) {
      return response.data;
    } else {
      return null;
    }
  }

  Future getTravelsIncomes(Map<String, String> entity) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['account-status']['account-status-travels-incomes'],
        body: entity);
    if (response.success) {
      return response.data;
    } else {
      return null;
    }
  }

  Future getTravelsDiscounts(Map<String, String> entity) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['account-status']
            ['account-status-travels-discounts'],
        body: entity);
    if (response.success) {
      return response.data;
    } else {
      return null;
    }
  }

  Future getDetailsAccount(Map<String, String> entity) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['account-status']
            ['account-status-personal-agreement-detail'],
        body: entity);
    if (response.success) {
      return response.data;
    } else {
      return null;
    }
  }

  Future<List<TicketPaymentModel>> gePaymentstTicket(
      Map<String, String> params) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['workerportal']['payments-ticket'], body: params);
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<TicketPaymentModel> list = jsonList
          .map((jsonElement) => TicketPaymentModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
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
      ToastCustom().danger(message: 'No se puede ver el archivo', time: 10);
    }
    return completer.future;
  }

  Future<ApiResponse> downloadFileWithPath(String url, String fileName,
      Map<String, String> params, BuildContext context) async {
    /*try {
      String path = '';
       final status = await Permission.storage.request();
      if (status.isGranted && !status.isDenied) {
        if (Platform.isIOS) {
          final downloadPath = await p.getExternalStorageDirectories(
              type: p.StorageDirectory.downloads);
          path = downloadPath![0].path;
        } else if (Platform.isAndroid) {
          path = await ep.ExternalPath.getExternalStoragePublicDirectory(
              ep.ExternalPath.DIRECTORY_DOWNLOADS);
        }
      } else {
        ToastCustom().dangerContext(
            context: context,
            message:
                'No se otrgó el permiso de acceder a la memoria en esta aplicación.',
            time: 8);
        return ApiResponse.fromJsonNull();
      }
      await _startDownload('$path/$fileName', url);
      final response = await _saveDowloadTicket(params);
      return response;
    } catch (e) {
      ToastCustom().dangerContext(
          context: context, message: 'No se procedió con la descarga', time: 8);
      return ApiResponse.fromJsonNull();
    } */
     return ApiResponse.fromJsonNull();
  }

  Future<void> _startDownload(String savePath, String _fileUrl) async {
    var request = await HttpClient().getUrl(Uri.parse(_fileUrl));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    File file = File(savePath);
    await file.writeAsBytes(bytes, flush: true);
  }

  Future<ApiResponse> _saveDowloadTicket(Map<String, String> params) async {
    final response = await ApiRestService.putNotId(
        endPoint: endPoints['workerportal']['payments-ticket'], body: params);
    return response;
  }
}
