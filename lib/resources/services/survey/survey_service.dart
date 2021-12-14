

import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/general/pagination.dart';
import 'package:lamb_talent/resources/models/response.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

class SurveyService {
  Future<ApiResponse> getQuizCovid(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['assistance']['survey-detail'], params: params);
    _apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> getQuizAnswerCovidDetail(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['assistance']['survey-answer-covid-detail'], params: params);
    _apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> saveAnswers(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.postParams(
        endPoint: endPoints['assistance']['survey-answer'],
        params: params,
        showMessage: false);
    _apiProvider.dispose();
    return response;
  }

  Future<PaginationModel> getSurveyAnswers(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['assistance']['survey-answer-covid'], params: params);
    _apiProvider.dispose();
    if (response.success) {
      PaginationModel pagination = PaginationModel.fromJson(response.data);
      return pagination;
    } else {
      return PaginationModel.fromJson({});
    }
  }
}
