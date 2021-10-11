import 'package:upn_financiero_mobil/src/models/models.dart'
    show ApiResponse, HolidayModel;
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class HolidayService {
  Future<List<HolidayModel>> getHolidays(Map<String, String> params) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['workerportal']['holiday'], body: params);
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

  Future<ApiResponse> signHoliday(Map<String, String> params,String iRrolVacacion) async {
    final response = await ApiRestService.putNotId(
        endPoint: endPoints['benefits']['holiday']+ '/pro-holidays/' + iRrolVacacion + '/confirmacion',
        body: params);
    return response;
  }
}
