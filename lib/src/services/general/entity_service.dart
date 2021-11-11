import 'package:upn_financiero_mobil/src/models/general/entity.dart';
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class EntityService {
  Future<List<Entity>> getListMyEntities() async {
    final response = await ApiRestService.get(
        endPoint: endPoints['comun']['my-entities']);
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<Entity> list =
          jsonList.map((jsonElement) => Entity.fromJson(jsonElement)).toList();
      return list;
    } else {
      return [];
    }
  }
}
