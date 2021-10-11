import 'package:upn_financiero_mobil/src/models/models.dart' show ApiResponse;
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
        endPoint: endPoints['assistance']['survey-answer'], body: params);
    return response;
  }
}
