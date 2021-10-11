import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:upn_financiero_mobil/src/models/response.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/toast.dart' as toast;

class ApiRestService {
  static Future<ApiResponse> get({required String endPoint}) async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');
      final headers = {'Authorization': token.toString()};
      var request = http.Request('GET', Uri.parse(endPoint));
      //request.bodyFields = entity;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      final statusCode = response.statusCode;
      return returnResponseOrThrowException(statusCode, data, false);
    } on IOException {
      return ApiResponse.fromJsonNull();
    }
  }

  static Future<ApiResponse> getWithParams(
      {required String endPoint, required Map<String, String> body}) async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');
      final headers = {'Authorization': token.toString()};
      String requestUrl = '';
      String queryString = Uri(queryParameters: body).query;
      requestUrl = endPoint + '?' + queryString;
      var request = http.Request('GET', Uri.parse(requestUrl));
      request.bodyFields = body;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();

      final statusCode = response.statusCode;
      return returnResponseOrThrowException(statusCode, data, false);
    } on IOException {
      return ApiResponse.fromJsonNull();
    }
  }

  static Future<ApiResponse> post(
      {required String endPoint,
      required Map<String, String> body,
      bool showMessageSuccess: false}) async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');
      final headers = {'Authorization': token.toString()};
      var request = http.Request('POST', Uri.parse(endPoint));
      request.bodyFields = body;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      /* if (response.statusCode == 200) {
        data = await response.stream.bytesToString();
      } else {
        data = response.reasonPhrase;
      } */

      final statusCode = response.statusCode;
      return returnResponseOrThrowException(
          statusCode, data, showMessageSuccess);
    } on IOException {
      return ApiResponse.fromJsonNull();
    }
  }

  static Future<ApiResponse> upload(
      {required String endPoint,
      required Map<String, String> body,
      String fielNameFile = '',
      String filePath = '',
      bool showMessageSuccess: false}) async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');
      final headers = {'Authorization': token.toString()};

      var request = http.MultipartRequest('POST', Uri.parse(endPoint));
      request.fields.addAll(body);
      request.headers.addAll(headers);
      if (filePath.isNotEmpty) {
        http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
            fielNameFile.isNotEmpty ? fielNameFile : 'file', filePath);
        request.files.add(multipartFile);
      }

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      final statusCode = response.statusCode;
      return returnResponseOrThrowException(
          statusCode, data, showMessageSuccess);
    } on IOException {
      return ApiResponse.fromJsonNull();
    }
  }

  static Future<ApiResponse> uploadMultiple(
      {required String endPoint,
      required Map<String, String> body,
      required List<Map<String, String>> files,
      bool showMessageSuccess: false}) async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');
      final headers = {'Authorization': token.toString()};

      var request = http.MultipartRequest('POST', Uri.parse(endPoint));
      request.fields.addAll(body);
      request.headers.addAll(headers);
      if (files.isNotEmpty) {
        files.forEach((file) async {
          if (file['filename'].toString().isNotEmpty &&
              file['filepath'].toString().isNotEmpty) {
            http.MultipartFile multipartFile =
                await http.MultipartFile.fromPath(
                    file['filename'].toString(), file['filepath'].toString());
            request.files.add(multipartFile);
          }
        });
      }
      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      final statusCode = response.statusCode;
      return returnResponseOrThrowException(
          statusCode, data, showMessageSuccess);
    } on IOException {
      return ApiResponse.fromJsonNull();
    }
  }

  static Future<ApiResponse> put(
      {required String endPoint,
      required String id,
      required Map<String, String> body,
      bool showMessageSuccess: false}) async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');
      final headers = {'Authorization': token.toString()};
      var request = http.Request('PUT', Uri.parse('$endPoint/$id'));
      request.bodyFields = body;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();

      final statusCode = response.statusCode;
      return returnResponseOrThrowException(
          statusCode, data, showMessageSuccess);
    } on IOException {
      return ApiResponse.fromJsonNull();
    }
  }

  static Future<ApiResponse> putNotId(
      {required String endPoint,
      required Map<String, String> body,
      bool showMessageSuccess: false}) async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');
      final headers = {'Authorization': token.toString()};
      var request = http.Request('PUT', Uri.parse('$endPoint'));
      request.bodyFields = body;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();

      final statusCode = response.statusCode;
      return returnResponseOrThrowException(
          statusCode, data, showMessageSuccess);
    } on IOException {
      return ApiResponse.fromJsonNull();
    }
  }
  static Future<ApiResponse> delete(
      {required String endPoint,
      required String id,
      bool showMessageSuccess: false}) async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');
      final headers = {
        'Authorization': token.toString(),
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      var request = http.Request('PUT', Uri.parse('$endPoint/$id'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();

      final statusCode = response.statusCode;
      return returnResponseOrThrowException(
          statusCode, data, showMessageSuccess);
    } on IOException {
      return ApiResponse.fromJsonNull();
    }
  }

  static ApiResponse returnResponseOrThrowException(
      statusCode, data, showMessageSuccess) {
    try {
      final parseResponse = _parseJsonResponse(data);
      if (statusCode > 500) {
        toast.ToastCustom().danger(
            message: parseResponse.message.isNotEmpty
                ? parseResponse.message
                : 'El servidor no responde. Intente más tarde.',
            time: 10);
        return ApiResponse.fromJsonNull();
        //throw UnKnowApiException(response.statusCode);
      } else if (statusCode > 400) {
        if (statusCode == 401) {
          toast.ToastCustom().danger(
              message: parseResponse.message.isEmpty
                  ? parseResponse.message
                  : 'Usuario o contraseña incorrectas.',
              time: 10);
          return ApiResponse.fromJsonNull();
          //throw ItemNotFoundException();
        } else if (statusCode == 403) {
          toast.ToastCustom().danger(
              message: parseResponse.message.isNotEmpty
                  ? parseResponse.message
                  : 'No tienes permiso.',
              time: 10);
          return ApiResponse.fromJsonNull();
          //throw ItemNotFoundException();
        } else if (statusCode == 404) {
          toast.ToastCustom().danger(
              message: parseResponse.message.isNotEmpty
                  ? parseResponse.message
                  : 'El servidor no pudo encontrar el contenido solicitado.',
              time: 10);
          return ApiResponse.fromJsonNull();
        } else {
          toast.ToastCustom().danger(
              message: parseResponse.message.isNotEmpty
                  ? parseResponse.message
                  : 'Ocurrió un error. Intente más tarde.',
              time: 10);
          return ApiResponse.fromJsonNull();
        } //throw ItemNotFoundException();
      } else if (statusCode > 300) {
        toast.ToastCustom().danger(
            message: parseResponse.message.isNotEmpty
                ? parseResponse.message
                : 'El servidor no responde. Intente más tarde.',
            time: 10);
        return ApiResponse.fromJsonNull();
        //throw UnKnowApiException(response.statusCode);
      } else {
        if (parseResponse.success == false) {
          toast.ToastCustom().danger(message: parseResponse.message, time: 10);
        } else if (showMessageSuccess) {
          toast.ToastCustom().success(message: parseResponse.message, time: 10);
        }
        return parseResponse;
      }
    } on IOException {
      toast.ToastCustom().danger(
          message:
              'Ocurrió un error. No se pudo procesar la información. Intente más tarde.',
          time: 10);
      return ApiResponse.fromJsonNull();
    }
  }

  static ApiResponse _parseJsonResponse(data) {
    try {
      final Map<String, dynamic> decoded = json.decode(data);
      final respParse = ApiResponse.fromJson(decoded);
      return respParse;
    } catch (e) {
      toast.ToastCustom().danger(
          message:
              'Ocurrió un error. No se pudo procesar la información. Intente más tarde.',
          time: 10);
      return ApiResponse.fromJsonNull();
    }
  }
}
