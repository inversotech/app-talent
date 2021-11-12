import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:upn_financiero_mobil/enviroment/enviroment.dart';
import 'package:upn_financiero_mobil/src/models/general/action.dart';
import 'package:upn_financiero_mobil/src/models/general/menu.dart';
import 'package:upn_financiero_mobil/src/models/response.dart';
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/toast.dart' as toast;
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class AuthService {
  Future<ApiResponse> loginLamb(Map<String, String> params) async {
    try {
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var request = http.Request(
          'POST', Uri.parse(endPoints['oauth']['login'].toString()));
      request.bodyFields = params;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final resp = await response.stream.bytesToString();
      final parseResp = _parseJsonResponse(resp);
      if (response.statusCode >= 100 && response.statusCode < 300) {
        if (parseResp.success == false) {
          toast.ToastCustom().danger(message: parseResp.message, time: 10);
        } else if (parseResp.success) {
          final storage = new FlutterSecureStorage();
          storage.write(
              key: 'access_token',
              value: parseResp.data!['access_token'].toString());
          await userInfo();
        } else {
          toast.ToastCustom().danger(
              message: parseResp.message.isNotEmpty
                  ? parseResp.message
                  : 'Ocurrió un error. Intente nuevamente.',
              time: 10);
        }
        return parseResp;
        //throw ItemNotFoundException();
      } else if (response.statusCode == 401) {
        toast.ToastCustom().danger(
            message: parseResp.message.isNotEmpty
                ? parseResp.message
                : 'Usuario o contraseña incorrectas.',
            time: 10);
        return ApiResponse.fromJsonNull();
        //throw ItemNotFoundException();
      } else if (response.statusCode == 403) {
        toast.ToastCustom().danger(
            message: parseResp.message.isNotEmpty
                ? parseResp.message
                : 'No tienes permiso.',
            time: 10);
        return ApiResponse.fromJsonNull();
        //throw ItemNotFoundException();
      } else if (response.statusCode > 500) {
        toast.ToastCustom().danger(
            message: parseResp.message.isNotEmpty
                ? parseResp.message
                : 'El servidor no responde. Intente más tarde.',
            time: 10);
        return ApiResponse.fromJsonNull();
        //throw UnKnowApiException(response.statusCode);
      } else {
        toast.ToastCustom().danger(
            message: parseResp.message.isNotEmpty
                ? parseResp.message
                : 'Ocurrió un error. Intente más tarde.',
            time: 10);
        return ApiResponse.fromJsonNull();
      }
    } on IOException {
      toast.ToastCustom()
          .danger(message: 'Ocurrió un error. Intente más tarde.', time: 10);
      return ApiResponse.fromJsonNull();
    }
  }

  static ApiResponse _parseJsonResponse(response) {
    try {
      final decoded = json.decode(response);
      return ApiResponse.fromJson(decoded);
    } catch (e) {
      return ApiResponse.fromJsonNull();
    }
  }

  Future<ApiResponse> validToken() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'access_token');
    if (token != null) {
      final response = await ApiRestService.post(
          endPoint: endPoints['oauth']['valid-tokens-oauth'], body: {});
      if (response.success) {
        return await userInfo();
      }
      return response;
    } else {
      return ApiResponse.fromJsonNull();
    }
  }

  Future<ApiResponse> userInfo() async {
    Map<String, String> params = {
      'codigo_padre': codeModule,
      'id_tipoplataforma': '2'
    };
    final response = await ApiRestService.post(
        endPoint: endPoints['oauth']['user-info'], body: params);
    if (response.success) {
      final prefs = new UserPreferences();
      final user = response.data!['user'] as Map<String, dynamic>;
      List<dynamic> jsonList = response.data['menu'] != null
          ? response.data['menu'] as List<dynamic>
          : [];
      prefs.idPerson = int.parse(user['id_persona'].toString());
      prefs.nroDocument = user['num_documento'].toString();
      prefs.fullnamePerson = user['user_name'].toString();
      prefs.idEntity = int.parse(user['entity_id'].toString());
      prefs.nameEntity = user['entity_name'].toString();
      prefs.idDeparment = user['departament_id'].toString();
      prefs.nameDeparment = user['departament_name'].toString();
      prefs.photoUrl = user['foto'].toString();
      prefs.idWorker = int.parse(user['id_trabajador'].toString());
      if (jsonList.isNotEmpty) {
        List<Menu> list =
            jsonList.map((jsonElement) => Menu.fromJson(jsonElement)).toList();
        prefs.menu = list;
      } else {
        prefs.menu = [];
      }
    }
    return response;
  }

  Future<List<ActionModule>> getActionsByModule(Map<String, String> params) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['comun']['actions-by-module'], body: params);
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

       List<ActionModule> list = jsonList
          .map((jsonElement) => ActionModule.fromJson(jsonElement))
          .toList(); 
      return list;
    } else {
      return [];
    }
  }
}
