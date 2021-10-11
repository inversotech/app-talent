
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';
class TravelsService {

 Future getTravelsData(Map<String, String> entity) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['account-status']['travels-data'],
        body: entity);
    if (response.success) {
      return response.data;
    } else {
      return {};
    }
  } 
  Future getDetails(Map<String, String> entity) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['account-status']['travels-data-detail'],
        body: entity);
    if (response.success) {
      return response.data;
    } else {
      return [];
    }
  }
}
