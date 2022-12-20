import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/notification/group.dart';
import 'package:lamb_talent/resources/models/notification/relation_person.dart';
import 'package:lamb_talent/resources/models/response.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

class NotificationService {
  Future<ApiResponse> getNotifications(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['messenger']['notification-event-album'],
        params: params);
    //_apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> getNotification(String id) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getAll(
        endPoint: endPoints['messenger']['notifications'] + '/' + id);
    //_apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> getEevent(String id) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getAll(
        endPoint: endPoints['messenger']['events'] + '/' + id);
    //_apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> getalbum(String id) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getAll(
        endPoint: endPoints['messenger']['albums'] + '/' + id);
    //_apiProvider.dispose();
    return response;
  }

  Future<List<GroupModel>> getGroups(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['messenger']['groups'], params: params);
    //_apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<GroupModel> list = jsonList
          .map((jsonElement) => GroupModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  Future<ApiResponse> changeRelationPerson(String origen, String idOrigen,
      String idPersona, Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.putNotId(
        endPoint: endPoints['messenger']['relation-person'].toString() +
            '/' +
            origen +
            '/' +
            idOrigen +
            '/' +
            idPersona,
        params: params,
        showMessage: false);
    //_apiProvider.dispose();
    return response;
  }

  Future<RelationPersonModel> getRelationPerson(
      String origen, String idOrigen, String idPersona) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getAll(
        endPoint: endPoints['messenger']['relation-person'].toString() +
            '/' +
            origen +
            '/' +
            idOrigen +
            '/' +
            idPersona);
    //_apiProvider.dispose();
    if (response.success) {
      RelationPersonModel pagination =
          RelationPersonModel.fromJson(response.data);
      return pagination;
    } else {
      return RelationPersonModel.fromJson({});
    }
  }

  Future<ApiResponse> saveLike(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.postParams(
        endPoint: endPoints['messenger']['like'],
        params: params,
        showMessage: false);
    //_apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> saveComment(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.postParams(
        endPoint: endPoints['messenger']['comment'],
        params: params,
        showMessage: false);
    //_apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> getComments(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['messenger']['comment'], params: params);
    //_apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> getLikes(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['messenger']['likes'], params: params);
    //_apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> deleteComment(String idComment) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.deleteId(
        endPoint: endPoints['messenger']['comment'],
        id: idComment,
        showMessage: false);
    //_apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> totalNoLeidos(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['messenger']['total-no-leidos'], params: params);
    //_apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> getRouteStorageFile(String route) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getAll(
        endPoint: endPoints['messenger']['storage'].toString() +
            '?fileName='.toString() +
            route.toString());
    //_apiProvider.dispose();
    return response;
  }
}
