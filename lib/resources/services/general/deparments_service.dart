import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/general/deparment.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

class DeparmentsService {
  Future getDeparmentsItems(Map<String, String> entity) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['account-status']['deparments-items'],
        params: entity);
    //_apiProvider.dispose();
    if (response.success) {
      return response.data;
    } else {
      return [];
    }
  }

  Future getItemDetails(Map<String, String> entity) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['account-status']['deparments-items-detail'],
        params: entity);
    //_apiProvider.dispose();
    if (response.success) {
      return response.data;
    } else {
      return [];
    }
  }

  Future<List<Deparment>> getListMyDeparments(
      Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['comun']['my-deptos'], params: params);
    //_apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<Deparment> list = jsonList
          .map((jsonElement) => Deparment.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }
}
