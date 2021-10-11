import 'package:upn_financiero_mobil/src/models/response.dart';
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class EntityService {
  Future<ApiResponse> getListEntities() async {
    final resp = await ApiRestService.get(
        endPoint: endPoints['account-status']['entity-type']);
    return resp;
  }
}
