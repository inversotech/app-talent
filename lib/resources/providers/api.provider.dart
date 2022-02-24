import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/response.dart';

class ApiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.maxRedirects = 1;
  }

  Future<ApiResponse> loginLamb(Map<String, String> params) async {
    httpClient.timeout = const Duration(seconds: 30);
    try {
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};

      final response = await post(endPoints['oauth']['login'].toString(), null,
          query: params, headers: headers);
      final resp = _parseJsonResponse(response.body);
      if (resp.success) {
        GetStorage storage = GetStorage();
        await storage.write('tokenLamb', resp.data['access_token']);
      } else {
        _showDialog(
            'danger',
            resp.message.isNotEmpty
                ? resp.message
                : 'El servidor no responde. Intente nuevamente.');
      }
      return resp;
    } catch (e) {
      _showDialog('danger',
          'Ocurrió un error al realizar la petición, intente nuevamente.');
      return ApiResponse.fromJsonNull();
    }
  }

  Future<ApiResponse> getAll({required String endPoint}) async {
    try {
      final storage = GetStorage();
      final token = storage.read('tokenLamb');
      final headers = {'Authorization': token.toString()};
      final response = await get(endPoint, headers: headers);
      return returnResponseOrThrowException(
          response.statusCode, response.body, false);
    } catch (e) {
      print(e);
      _showDialog('danger',
          'Ocurrió un error al realizar la petición, intente nuevamente.');
      return ApiResponse.fromJsonNull();
    }
  }

  Future<ApiResponse> getWithParams({
    required String endPoint,
    required Map<String, String> params,
  }) async {
    try {
      final storage = GetStorage();
      final token = storage.read('tokenLamb');
      final headers = {'Authorization': token.toString()};
      final response = await get(endPoint, query: params, headers: headers);
      return returnResponseOrThrowException(
          response.statusCode, response.body, false);
    } catch (e) {
      print(e);
      _showDialog('danger',
          'Ocurrió un error al realizar la petición, intente nuevamente.');
      return ApiResponse.fromJsonNull();
    }
  }

  Future<ApiResponse> postParams(
      {required String endPoint,
      required Map<String, String> params,
      bool showMessage = true,
      duration = const Duration(seconds: 8)}) async {
    httpClient.timeout = duration;
    try {
      final storage = GetStorage();
      final token = storage.read('tokenLamb');
      final headers = {'Authorization': token.toString()};
      final response = await post(endPoint, params, headers: headers);
      return returnResponseOrThrowException(
          response.statusCode, response.body, showMessage);
    } catch (e) {
      print(e);
      _showDialog('danger',
          'Ocurrió un error al realizar la petición, intente nuevamente.');
      return ApiResponse.fromJsonNull();
    }
  }

  Future<ApiResponse> postUpload(
      {required String endPoint,
      required FormData formData,
      bool showMessage = true}) async {
    try {
      final storage = GetStorage();
      final token = storage.read('tokenLamb');
      final headers = {'Authorization': token.toString()};

      final response = await post(endPoint, formData, headers: headers);
      return returnResponseOrThrowException(
          response.statusCode, response.body, showMessage);
    } catch (e) {
      print(e);
      _showDialog('danger',
          'Ocurrió un error al realizar la petición, intente nuevamente.');
      return ApiResponse.fromJsonNull();
    }
  }

  Future<ApiResponse> putWithId(
      {required String endPoint,
      required Map<String, String> params,
      required String id,
      bool showMessage = true}) async {
    try {
      final storage = GetStorage();
      final token = storage.read('tokenLamb');
      final headers = {'Authorization': token.toString()};
      final response = await put(endPoint + '/' + id, params, headers: headers);
      return returnResponseOrThrowException(
          response.statusCode, response.body, showMessage);
    } catch (e) {
      print(e);
      _showDialog('danger',
          'Ocurrió un error al realizar la petición, intente nuevamente.');
      return ApiResponse.fromJsonNull();
    }
  }

  Future<ApiResponse> putNotId(
      {required String endPoint,
      required Map<String, String> params,
      bool showMessage = true}) async {
    try {
      final storage = GetStorage();
      final token = storage.read('tokenLamb');
      final headers = {'Authorization': token.toString()};
      final response = await put(endPoint, params, headers: headers);
      return returnResponseOrThrowException(
          response.statusCode, response.body, showMessage);
    } catch (e) {
      print(e);
      _showDialog('danger',
          'Ocurrió un error al realizar la petición, intente nuevamente.');
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
      print(e);
      _showDialog('danger',
          'Ocurrió un error al realizar la petición, intente nuevamente.');
      return ApiResponse.fromJsonNull();
    }
  }

  static ApiResponse returnResponseOrThrowException(
      statusCode, data, showMessageSuccess) {
    try {
      final parseResponse = _parseJsonResponse(data);
      if (statusCode > 500) {
        _showDialog(
            'danger',
            parseResponse.message.isNotEmpty
                ? parseResponse.message
                : 'El servidor no responde. Intente nuevamente.');
        return ApiResponse.fromJsonNull();
        //throw UnKnowApiException(response.statusCode);
      } else if (statusCode > 400) {
        if (statusCode == 401) {
          _showDialog(
              'danger',
              parseResponse.message.isNotEmpty
                  ? parseResponse.message
                  : 'Usuario o contraseña incorrectas.');
          return ApiResponse.fromJsonNull();
          //throw ItemNotFoundException();
        } else if (statusCode == 403) {
          _showDialog(
              'danger',
              parseResponse.message.isNotEmpty
                  ? parseResponse.message
                  : 'No tienes permiso.');
          return ApiResponse.fromJsonNull();
          //throw ItemNotFoundException();
        } else if (statusCode == 404) {
          _showDialog(
              'danger',
              parseResponse.message.isNotEmpty
                  ? parseResponse.message
                  : 'El servidor no pudo encontrar el contenido solicitado.');
          return ApiResponse.fromJsonNull();
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
    } catch (e) {
      print(e);
      _showDialog('danger',
          'Ocurrió un error al realizar la petición, intente nuevamente.');
      return ApiResponse.fromJsonNull();
    }
  }

  static void _showDialog(String option, String message) {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    switch (option) {
      case 'danger':
        Get.snackbar('Mensaje:', message,
            duration: const Duration(seconds: 8),
            colorText: ColorsApp.white,
            backgroundColor: ColorsApp.danger);
        break;
      case 'success':
        Get.snackbar('Mensaje:', message,
            duration: const Duration(seconds: 8),
            colorText: ColorsApp.white,
            backgroundColor: ColorsApp.success);
        break;
      case 'warning':
        Get.snackbar('Mensaje:', message,
            duration: const Duration(seconds: 8),
            colorText: ColorsApp.white,
            backgroundColor: ColorsApp.warning);
        break;
    }
  }
}
