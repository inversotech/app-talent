import 'package:upn_financiero_mobil/src/models/models.dart';
import 'package:upn_financiero_mobil/src/models/response.dart';
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class MarkingService {
  Future<ApiResponse> getMapCoordinates() async {
    final response = await ApiRestService.get(
        endPoint: endPoints['assistance']['map-coordinates']);
    return response;
  }

  Future<ApiResponse> showButtonAssistance(Map<String, String> params) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['assistance']['show-button-assistance'],
        body: params);
    return response;
  }

  Future<ApiResponse> workerMarking(Map<String, String> params) async {
    final response = await ApiRestService.post(
        endPoint: endPoints['assistance']['worker-marking'],
        body: params,
        showMessageSuccess: true);
    return response;
  }

  Future<PaginationModel> assistMarkings(Map<String, String> params) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['assistance']['assist-markings'], body: params);
    if (response.success) {
      PaginationModel pagination = PaginationModel.fromJson(response.data);
      return pagination;
    } else {
      return PaginationModel.fromJson({});
    }
  }

  Future<List<MarkingModel>> assistMarkingsIni(
      Map<String, String> params) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['assistance']['markings-ini'], body: params);
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<MarkingModel> list = jsonList
          .map((jsonElement) => MarkingModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }
}
