import 'package:upn_financiero_mobil/src/models/general/deparment.dart';
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class DeparmentsService {
  Future getDeparmentsItems(Map<String, String> entity) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['account-status']['deparments-items'],
        body: entity);
    if (response.success) {
      return response.data;
    } else {
      return [];
    }
  }

  Future getItemDetails(Map<String, String> entity) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['account-status']['deparments-items-detail'],
        body: entity);
    if (response.success) {
      return response.data;
    } else {
      return [];
    }
  }

  Future<List<Deparment>> getListMyDeparments(
      Map<String, String> params) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['comun']['my-deptos'], body: params);
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
