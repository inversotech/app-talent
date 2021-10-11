import 'package:upn_financiero_mobil/src/models/models.dart'
    show StateLicensePermitModel;
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class StateLicensePermitService {
  Future<List<StateLicensePermitModel>> getStateLicensePermit() async {
    final response = await ApiRestService.get(
        endPoint: endPoints['comun']['license-permit-status']);
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<StateLicensePermitModel> list = jsonList
          .map((jsonElement) => StateLicensePermitModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }
}
