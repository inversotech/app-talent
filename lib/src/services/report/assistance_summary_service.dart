import 'package:upn_financiero_mobil/src/models/models.dart';
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class AssistanceSummaryService {
  Future<List<AssistanceSummaryModel>> getAssistanceSummaryChart(
      Map<String, String> params) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['report']['monthly-assistance-summary-chart'],
        body: params);
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
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['report']['monthly-assistance-summary'],
        body: params);
    return response;
  }
}
