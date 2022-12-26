import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

class GraphicsService {
  Future getGraphData(Map<String, String> entity) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['account-status']['account-status-graphics'],
        params: entity);
    //_apiProvider.dispose();
    if (response.success) {
      return response.data;
    } else {
      return {};
    }
  }

  Future getGraphicsDetail(Map<String, String> entity) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['account-status']['account-status-graphics-detail'],
        params: entity);
    //_apiProvider.dispose();
    if (response.success) {
      return response.data['data'];
    } else {
      return [];
    }
  }
}
