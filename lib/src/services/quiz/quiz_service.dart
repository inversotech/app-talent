import 'package:upn_financiero_mobil/src/models/models.dart'
    show ApiResponse, PaginationModel;
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class QuizService {
  Future<ApiResponse> getQuizCovid() async {
    final response = await ApiRestService.get(
        endPoint: endPoints['assistance']['survey-detail']);
    return response;
  }

  Future<ApiResponse> saveAnswers(Map<String, String> params) async {
    final response = await ApiRestService.post(
        endPoint: endPoints['assistance']['survey-answer'],
        body: params,
        showMessageSuccess: false);
    return response;
  }

  Future<PaginationModel> getSurveyAnswers(Map<String, String> params) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['assistance']['survey-answer-covid'], body: params);
    if (response.success) {
      PaginationModel pagination = PaginationModel.fromJson(response.data);
      return pagination;
    } else {
      return PaginationModel.fromJson({});
    }
  }
}
