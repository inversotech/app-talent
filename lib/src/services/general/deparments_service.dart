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
}
