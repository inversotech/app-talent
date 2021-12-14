import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/license-permit/state_license_permit.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

class StateLicensePermitService {
  Future<List<StateLicensePermitModel>> getStateLicensePermit() async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getAll(
        endPoint: endPoints['comun']['license-permit-status']);
    _apiProvider.dispose();
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
