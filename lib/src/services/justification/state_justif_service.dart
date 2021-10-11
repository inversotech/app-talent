import 'package:upn_financiero_mobil/src/models/models.dart' show ProcessJustifcationModel;
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class StateJustifService {
  Future<List<ProcessJustifcationModel>> getStateJustification() async {
    final response = await ApiRestService.get(
        endPoint: endPoints['comun']['justification-status']);
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