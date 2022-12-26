import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/assistance/assistance_summary.dart';
import 'package:lamb_talent/resources/models/response.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

class AssistanceSummaryService {
  Future<List<AssistanceSummaryModel>> getAssistanceSummaryChart(
      Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['report']['monthly-assistance-summary-chart'],
        params: params);
    //_apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<AssistanceSummaryModel> list = jsonList
          .map((jsonElement) => AssistanceSummaryModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  Future<ApiResponse> getAssistanceSummary(Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['report']['monthly-assistance-summary'],
        params: params);
    //_apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> getInfoAssistance(Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['report']['info-assistance'], params: params);
    return response;
  }
}
