import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class PersonYearService {
  Future getPersonsYear(Map<String, String> entity) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['account-status']['person-year'], body: entity);
    if (response.success) {
      return response.data;
    } else {
      return [];
    }
  }
}
