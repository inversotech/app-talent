import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class PersonService {
  Future getPersonsYear(Map<String, String> params) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['account-status']['person-year'], body: params);
    if (response.success) {
      return response.data;
    } else {
      return [];
    }
  }

  Future<dynamic> getSign(Map<String, String> params) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['comun']['person-signature'], body: params);
    if (response.success) {
      return response.data;
    } else {
      return {};
    }
  }
}
