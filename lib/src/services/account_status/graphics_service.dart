
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class GraphicsService {
  Future getGraphData(Map<String, String> entity) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['account-status']['account-status-graphics'],
        body: entity);
    if (response.success) {
      return response.data;
    } else {
      return {};
    }
  }

  Future getGraphicsDetail(Map<String, String>  entity) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['account-status']['account-status-graphics-detail'],
        body: entity);
    if (response.success) {
      return response.data['data'];
    } else {
      return [];
    }
  }
}
