import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/core/routers_names.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/enviroment/enviroment.dart';
import 'package:lamb_talent/resources/models/general/acceso_nivel_user.dart';
import 'package:lamb_talent/resources/models/general/action.dart';
import 'package:lamb_talent/resources/models/general/menu.dart';
import 'package:lamb_talent/resources/models/response.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

class AuthService {
  Future<ApiResponse> userInfo() async {
    final _apiProvider = ApiProvider();
    Map<String, String> params = {
      'codigo_padre': codeModule,
      'id_tipoplataforma': '2'
    };
    final response = await _apiProvider.postParams(
        endPoint: endPoints['oauth']['user-info'],
        params: params,
        showMessage: false);
    _apiProvider.dispose();
    final prefs = UserPreferences();
    if (response.success) {
      final user = response.data!['user'] as Map<String, dynamic>;
      List<dynamic> jsonList = response.data['menu'] != null
          ? response.data['menu'] as List<dynamic>
          : [];
      prefs.isWorkerChild = false;
      prefs.idPerson = int.parse(user['id_persona'].toString());
      prefs.idPersonFather = int.parse(user['id_persona'].toString());
      prefs.nroDocumentFather = user['num_documento'].toString();
      prefs.nroDocument = user['num_documento'].toString();
      prefs.fullnamePerson = user['user_name'].toString();
      prefs.fullnamePersonFather = user['user_name'].toString();
      prefs.idEntity = int.parse(user['entity_id'].toString());
      prefs.idEntityFather = int.parse(user['entity_id'].toString());
      prefs.nameEntity = user['entity_name'].toString();
      prefs.idDeparmentFathher = user['departament_id'].toString();
      prefs.idDeparment = user['departament_id'].toString();
      prefs.nameDeparment = user['departament_name'].toString();
      prefs.photoUrl = user['foto'].toString();
      prefs.idWorker = int.parse(user['id_trabajador'].toString());
      prefs.idWorkerFather = int.parse(user['id_trabajador'].toString());
      if (jsonList.isNotEmpty) {
        List<Menu> list =
            jsonList.map((jsonElement) => Menu.fromJson(jsonElement)).toList();
        prefs.menu = list;
      } else {
        prefs.menu = [];
        Get.snackbar('Mensaje:', 'No tienes acceso a éste módulo',
            duration: const Duration(seconds: 8),
            colorText: ColorsApp.white,
            backgroundColor: ColorsApp.warning);
        Get.offAllNamed(RoutesName.login);
      }

      await totalEntitiesDeptos();
    }
    return response;
  }

  Future<ApiResponse> totalEntitiesDeptos() async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getAll(
        endPoint: endPoints['comun']['total-entities-deptos']);
    _apiProvider.dispose();
    if (response.success) {
      final prefs = UserPreferences();
      prefs.cantEntities = int.parse(response.data['entities'].toString());
      prefs.cantDeptos = int.parse(response.data['deptos'].toString());
    }
    return response;
  }

  Future<List<ActionModule>> getActionsByModule(
      Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['comun']['actions-by-module'], params: params);
    _apiProvider.dispose();
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

  Future<AccesoNivelUser> getAccessNivel(Map<String, String> params) async {
    try {
      final _apiProvider = ApiProvider();
      final resp = await _apiProvider.getWithParams(
          endPoint: endPoints['comun']['acceso-nivel'], params: params);
      _apiProvider.dispose();
      final response = AccesoNivelUser.fromJson(resp.data ?? '');
      return response;
    } catch (e) {
      final response = AccesoNivelUser.fromJson({});
      return response;
    }
  }

  Future<ApiResponse> changeEntityDepto(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.postParams(
        endPoint: endPoints['comun']['change-entity-depto'], params: params);
    _apiProvider.dispose();
    return response;
  }
}
