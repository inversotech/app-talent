import 'package:upn_financiero_mobil/src/models/models.dart';
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';
import 'package:upn_financiero_mobil/src/services/services.dart';

Future getListPersons(
    AccountStatusModel accountStatusModel, String search) async {
  PersonYearService _personYearService = new PersonYearService();
  final Map<String, String> params = {
    'id_entidad': accountStatusModel.idEntity.toString(),
    'id_anho': accountStatusModel.year.toString(),
    'search': search
  };
  final resp = await _personYearService.getPersonsYear(params);
  return resp;
}

class PersonService {
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
