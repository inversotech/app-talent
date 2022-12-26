import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/general/entity.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

class EntityService {
  Future<List<Entity>> getListMyEntities() async {
    final apiProvider = ApiProvider();
    final response =
        await apiProvider.getAll(endPoint: endPoints['comun']['my-entities']);
    //_apiProvider.dispose();
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
