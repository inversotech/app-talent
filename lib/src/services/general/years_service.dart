import 'package:upn_financiero_mobil/src/models/models.dart';
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class YearService {
  Future<List<YearModel>> getYears() async {
    final response =
        await ApiRestService.get(endPoint: endPoints['comun']['years']);
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<YearModel> list = jsonList
          .map((jsonElement) => YearModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }
}
