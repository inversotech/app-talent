import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/response.dart';
import 'package:http/http.dart' as http;

class ApiProvider extends GetConnect {
  Future<ApiResponse> loginLamb(
      Map<String, String> params, bool saveCred) async {
    if (await checkInternet(endPoints['oauth']['login'])) {
      httpClient.maxRedirects = 1;
      httpClient.timeout = const Duration(seconds: 60);
      try {
        var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
        final response = await post(
            endPoints['oauth']['login'].toString(), null,
            query: params, headers: headers);
        if (response.status.code == 302) {
          _showDialog(
              'danger', 'Verifica tu conexión a internet o intente más tarde',
              icon: const Icon(Icons.wifi_off));
          return ApiResponse.fromJsonNull();
        } else if (response.status.connectionError) {
          _showDialog('danger',
              'La petición esta demorando demasiado, verifique su conexión a internet o intente nuevamente.');
          return ApiResponse.fromJsonNull();
        } else {
          final resp = _parseJsonResponse(response.body);
          if (resp.success) {
            GetStorage storage = GetStorage();
            if (saveCred) {
              final usernamelamb = params['username']!;
              final passwordlamb = params['password']!;
              await storage.write('saveCredLamb', saveCred);
              await storage.write('usernameLamb', usernamelamb);
              await storage.write('passwordLamb', passwordlamb);
            } else {
              await storage.write('saveCredLamb', saveCred);
              await storage.remove('usernameLamb');
              await storage.remove('passwordLamb');
            }

            await storage.write('tokenLamb', resp.data['access_token']);
          } else if (response.status.isUnauthorized) {
            _showDialog('danger', 'Usuario o contraseña incorrectas.');
            return ApiResponse.fromJsonNull();
          } else {
            _showDialog(
                'danger',
                resp.message.isNotEmpty
                    ? resp.message
                    : 'Ocurrió un error al realizar la petición, intente nuevamente.');
          }
          return resp;
        }
      } catch (e) {
        _showDialog('danger',
            'Ocurrió un error al realizar la petición, intente nuevamente.');
        return ApiResponse.fromJsonNull();
      }
    } else {
      return ApiResponse.fromJsonNull();
    }
  }

  Future<bool> checkInternet(String endPoint) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      try {
        final uri = Uri.parse(endPoint);
        String domain = uri.host;
        final response = await InternetAddress.lookup(domain);
        if (response.isNotEmpty) {
          return true;
        } else {
          _showDialog('danger',
              'Hay problemas en el servidor. Intente más tarde o comunícase con DTH.');
          return false;
        }
      } on SocketException catch (_) {
        _showDialog('danger',
            'Hay problemas en el servidor. Intente más tarde o comunícase con DTH.');
        return false;
      }
    } else {
      _showDialog('danger', 'Verifica tu conexión a internet.',
          icon: const Icon(Icons.wifi_off));
      return false;
    }
  }

  Future<ApiResponse> getAll({required String endPoint}) async {
    if (await checkInternet(endPoint)) {
      try {
        httpClient.maxRedirects = 1;
        httpClient.timeout = const Duration(seconds: 60);
        final storage = GetStorage();
        final token = storage.read('tokenLamb');
        final headers = {'Authorization': token.toString()};
        final response = await get(endPoint, headers: headers);
        return returnResponseOrThrowException(
            response.status, response.statusCode, response.body, false);
      } catch (e) {
        _showDialog('danger',
            'Ocurrió un error al realizar la petición, intente nuevamente.');
        return ApiResponse.fromJsonNull();
      }
    } else {
      return ApiResponse.fromJsonNull();
    }
  }

  Future<ApiResponse> getWithParams({
    required String endPoint,
    required Map<String, String> params,
  }) async {
    if (await checkInternet(endPoint)) {
      try {
        httpClient.maxRedirects = 1;
        httpClient.timeout = const Duration(seconds: 60);
        final storage = GetStorage();
        final token = storage.read('tokenLamb');
        final headers = {'Authorization': token.toString()};
        final response = await get(endPoint, query: params, headers: headers);
        return returnResponseOrThrowException(
            response.status, response.statusCode, response.body, false);
      } catch (e) {
        _showDialog('danger',
            'Ocurrió un error al realizar la petición, intente nuevamente.');
        return ApiResponse.fromJsonNull();
      }
    } else {
      return ApiResponse.fromJsonNull();
    }
  }

  Future<ApiResponse> postParams(
      {required String endPoint,
      required Map<String, String> params,
      bool showMessage = true}) async {
    if (await checkInternet(endPoint)) {
      try {
        httpClient.maxRedirects = 1;
        httpClient.timeout = const Duration(seconds: 60);
        final storage = GetStorage();
        final token = storage.read('tokenLamb');
        final headers = {'Authorization': token.toString()};
        final response = await post(endPoint, params, headers: headers);
        return returnResponseOrThrowException(
            response.status, response.statusCode, response.body, showMessage);
      } catch (e) {
        _showDialog('danger',
            'Ocurrió un error al realizar la petición, intente nuevamente.');
        return ApiResponse.fromJsonNull();
      }
    } else {
      return ApiResponse.fromJsonNull();
    }
  }

  Future<ApiResponse> postUpload(
      {required String endPoint,
      required FormData formData,
      bool showMessage = true}) async {
    if (await checkInternet(endPoint)) {
      try {
        httpClient.maxRedirects = 1;
        httpClient.timeout = const Duration(seconds: 60);
        final storage = GetStorage();
        final token = storage.read('tokenLamb');
        final headers = {'Authorization': token.toString()};

        final response = await post(endPoint, formData, headers: headers);
        return returnResponseOrThrowException(
            response.status, response.statusCode, response.body, showMessage);
      } catch (e) {
        _showDialog('danger',
            'Ocurrió un error al realizar la petición, intente nuevamente.');
        return ApiResponse.fromJsonNull();
      }
    } else {
      return ApiResponse.fromJsonNull();
    }
  }

  Future<ApiResponse> putWithId(
      {required String endPoint,
      required Map<String, String> params,
      required String id,
      bool showMessage = true}) async {
    if (await checkInternet(endPoint)) {
      try {
        httpClient.maxRedirects = 1;
        httpClient.timeout = const Duration(seconds: 60);
        final storage = GetStorage();
        final token = storage.read('tokenLamb');
        final headers = {'Authorization': token.toString()};
        final response = await put('$endPoint/$id', params, headers: headers);
        return returnResponseOrThrowException(
            response.status, response.statusCode, response.body, showMessage);
      } catch (e) {
        _showDialog('danger',
            'Ocurrió un error al realizar la petición, intente nuevamente.');
        return ApiResponse.fromJsonNull();
      }
    } else {
      return ApiResponse.fromJsonNull();
    }
  }

  Future<ApiResponse> putNotId(
      {required String endPoint,
      required Map<String, String> params,
      bool showMessage = true}) async {
    if (await checkInternet(endPoint)) {
      try {
        httpClient.maxRedirects = 1;
        httpClient.timeout = const Duration(seconds: 60);
        final storage = GetStorage();
        final token = storage.read('tokenLamb');
        final headers = {'Authorization': token.toString()};
        final response = await put(endPoint, params, headers: headers);
        return returnResponseOrThrowException(
            response.status, response.statusCode, response.body, showMessage);
      } catch (e) {
        _showDialog('danger',
            'Ocurrió un error al realizar la petición, intente nuevamente.');
        return ApiResponse.fromJsonNull();
      }
    } else {
      return ApiResponse.fromJsonNull();
    }
  }

  Future<ApiResponse> deleteId(
      {required String endPoint,
      required String id,
      bool showMessage = true}) async {
    if (await checkInternet(endPoint)) {
      try {
        httpClient.maxRedirects = 1;
        httpClient.timeout = const Duration(seconds: 60);
        final storage = GetStorage();
        final token = storage.read('tokenLamb');
        final headers = {'Authorization': token.toString()};
        final response = await delete('$endPoint/$id', headers: headers);
        return returnResponseOrThrowException(
            response.status, response.statusCode, response.body, showMessage);
      } catch (e) {
        _showDialog('danger',
            'Ocurrió un error al realizar la petición, intente nuevamente.');
        return ApiResponse.fromJsonNull();
      }
    } else {
      return ApiResponse.fromJsonNull();
    }
  }

  static ApiResponse _parseJsonResponse(response) {
    try {
      final resp = response != null
          ? ApiResponse.fromJson(response)
          : ApiResponse.fromJsonNull();
      return resp;
    } catch (e) {
      _showDialog('danger',
          'Ocurrió un error al realizar la petición, intente nuevamente.');
      return ApiResponse.fromJsonNull();
    }
  }

  static ApiResponse returnResponseOrThrowException(
      HttpStatus status, statusCode, data, showMessageSuccess) {
    try {
      if (status.isUnauthorized) {
        _showDialog('danger',
            'Token vencido o no tienes permiso, vuelva a iniciar sesión o intente nuevamente.');
        // Get.offAllNamed(RoutesName.login);
        return ApiResponse.fromJsonNull();
      } else if (status.code == 302) {
        _showDialog(
            'danger', 'Verifica tu conexión a internet o intente más tarde',
            icon: const Icon(Icons.wifi_off));
        return ApiResponse.fromJsonNull();
      } else if (status.connectionError) {
        _showDialog('danger',
            'La petición esta demorando demasiado, verifique su conexión a internet o intente nuevamente.');
        return ApiResponse.fromJsonNull();
      } else {
        final parseResponse = _parseJsonResponse(data);
        if (statusCode > 500) {
          _showDialog(
              'danger',
              parseResponse.message.isNotEmpty
                  ? parseResponse.message
                  : 'El servidor no responde. Intente más tarde o comunícase con DTH.');
          return ApiResponse.fromJsonNull();
          //throw UnKnowApiException(response.statusCode);
        } else if (statusCode > 400) {
          if (statusCode == 403) {
            _showDialog(
                'danger',
                parseResponse.message.isNotEmpty
                    ? parseResponse.message
                    : 'No tienes permiso.');
            return ApiResponse.fromJsonNull();
            //throw ItemNotFoundException();
          } else {
            _showDialog(
                'danger',
                parseResponse.message.isNotEmpty
                    ? parseResponse.message
                    : 'Ocurrió un error al realizar la petición, intente nuevamente.');
            return ApiResponse.fromJsonNull();
          } //throw ItemNotFoundException();
        } else if (statusCode > 300) {
          _showDialog(
              'danger',
              parseResponse.message.isNotEmpty
                  ? parseResponse.message
                  : 'Ocurrió un error al realizar la petición, intente nuevamente.');
          return ApiResponse.fromJsonNull();
          //throw UnKnowApiException(response.statusCode);
        } else {
          if (parseResponse.success == false &&
              parseResponse.message.isNotEmpty) {
            _showDialog('danger', parseResponse.message);
          } else if (showMessageSuccess && parseResponse.message.isNotEmpty) {
            _showDialog('success', parseResponse.message);
          }
          return parseResponse;
        }
      }
    } catch (e) {
      _showDialog('danger',
          'Ocurrió un error al realizar la petición, intente nuevamente.');
      return ApiResponse.fromJsonNull();
    }
  }

  static void _showDialog(String option, String message,
      {Icon? icon,
      EdgeInsets? margin,
      SnackPosition position = SnackPosition.TOP}) {
    Get.until((route) => !Get.isDialogOpen!);
    switch (option) {
      case 'danger':
        Get.snackbar('Mensaje:', message,
            duration: const Duration(seconds: 8),
            colorText: ColorsApp.white,
            backgroundColor: ColorsApp.danger,
            icon: icon,
            snackPosition: position,
            margin: margin);
        break;
      case 'success':
        Get.snackbar('Mensaje:', message,
            duration: const Duration(seconds: 8),
            colorText: ColorsApp.white,
            backgroundColor: ColorsApp.success,
            icon: icon,
            margin: margin);
        break;
      case 'warning':
        Get.snackbar('Mensaje:', message,
            duration: const Duration(seconds: 8),
            colorText: ColorsApp.white,
            backgroundColor: ColorsApp.warning,
            icon: icon,
            margin: margin);
        break;
    }
  }
}
