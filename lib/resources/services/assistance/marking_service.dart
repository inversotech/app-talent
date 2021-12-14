import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/assistance/marking.dart';
import 'package:lamb_talent/resources/models/general/pagination.dart';
import 'package:lamb_talent/resources/models/response.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

class MarkingService {
  Future<ApiResponse> getMapCoordinates() async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getAll(
        endPoint: endPoints['assistance']['map-coordinates']);
    _apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> showButtonAssistance(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['assistance']['show-button-assistance'],
        params: params);
    _apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> workerMarking(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.postParams(
        endPoint: endPoints['assistance']['worker-marking'],
        params: params,
        showMessage: true);
    _apiProvider.dispose();
    return response;
  }

  Future<PaginationModel> assistMarkings(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['assistance']['assist-markings'], params: params);
    _apiProvider.dispose();
    if (response.success) {
      PaginationModel pagination = PaginationModel.fromJson(response.data);
      return pagination;
    } else {
      return PaginationModel.fromJson({});
    }
  }

  Future<List<MarkingModel>> assistMarkingsIni(
      Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['assistance']['markings-ini'], params: params);
    _apiProvider.dispose();
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
