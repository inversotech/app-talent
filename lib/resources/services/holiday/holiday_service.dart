import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

class HolidayService {

  Future<PaginationModel> getWorkersHoliday(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['benefits']['pro-holiday'], params: params);
    _apiProvider.dispose();
    if (response.success) {
      PaginationModel pagination = PaginationModel.fromJson(
          response.data.containsKey('items') ? response.data['items'] : []);
      return pagination;
    } else {
      return PaginationModel.fromJson({});
    }
  }

  Future<List<HolidayModel>> getHolidays(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['workerportal']['holiday'], params: params);
    _apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<HolidayModel> list = jsonList
          .map((jsonElement) => HolidayModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  Future<ApiResponse> signHoliday(
      Map<String, String> params, String iRrolVacacion) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.putNotId(
        endPoint: endPoints['benefits']['holiday'] +
            '/pro-holidays/' +
            iRrolVacacion +
            '/confirmacion',
        params: params);
    _apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> changeStatusHoliday(
      String id, Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.putWithId(
        endPoint: endPoints['benefits']['pro-holiday'].toString() +
            '/update-vacacion',
        id: id,
        params: params);
    _apiProvider.dispose();
    return response;
  }
}
