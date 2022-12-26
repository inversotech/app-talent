import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

class StateJustifService {
  Future<List<ProcessJustifcationModel>> getStateJustification() async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getAll(
        endPoint: endPoints['comun']['justification-status']);
    //_apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<ProcessJustifcationModel> list = jsonList
          .map((jsonElement) => ProcessJustifcationModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }
}
