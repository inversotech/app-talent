import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

class TravelsService {
  Future getTravelsData(Map<String, String> entity) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['account-status']['travels-data'], params: entity);
    //_apiProvider.dispose();
    if (response.success) {
      return response.data;
    } else {
      return {};
    }
  }

  Future getDetails(Map<String, String> entity) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['account-status']['travels-data-detail'],
        params: entity);
    //_apiProvider.dispose();
    if (response.success) {
      return response.data;
    } else {
      return [];
    }
  }
}
