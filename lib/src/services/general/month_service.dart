import 'package:upn_financiero_mobil/src/models/models.dart';
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class MonthService {
  Future<List<MonthModel>> getMonths() async {
    final response =
        await ApiRestService.get(endPoint: endPoints['comun']['months']);
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<MonthModel> list = jsonList
          .map((jsonElement) => MonthModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }
}
