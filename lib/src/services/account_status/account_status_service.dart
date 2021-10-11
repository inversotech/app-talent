import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upn_financiero_mobil/src/models/models.dart';
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

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
  Future<List<TicketPaymentModel>> gePaymentstTicket(Map<String, String> params) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['workerportal']
            ['payments-ticket'],
        body: params);
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

  Future<File> createFileOfPdfUrl(String url,String filename) async {
    Completer<File> completer = Completer();
    try {
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }
    return completer.future;
  }

   /* Future<File> writeFile(String  url, String filename) async {
    // storage permission ask
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    // the downloads folder path
    Directory tempDir = await DownloadsPathProvider.downloadsDirectory;
    String tempPath = tempDir.path;
    var filePath = tempPath + '/$name';
    // 

    // the data
    var bytes = ByteData.view(data.buffer);
    final buffer = bytes.buffer;
    // save the data in the path
    return File(filePath).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  } */

  
}
