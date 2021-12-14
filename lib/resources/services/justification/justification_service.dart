import 'package:get/get.dart';
import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

class JustificationService {
  Future<PaginationModel> getJustifications(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['assistance']['request-by-worker'], params: params);
    _apiProvider.dispose();
    if (response.success) {
      PaginationModel pagination = PaginationModel.fromJson(response.data);
      return pagination;
    } else {
      return PaginationModel.fromJson({});
    }
  }

  Future<ApiResponse> getJustification(String id) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getAll(
        endPoint: endPoints['justification']['request'] + '/' + id);
    _apiProvider.dispose();
    return response;
  }

  Future<List<ReasonJustificationModel>> getReasonsJustification() async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getAll(
        endPoint: endPoints['assistance']['justification-reason']);
    _apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<ReasonJustificationModel> list = jsonList
          .map((jsonElement) => ReasonJustificationModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  Future<List<ScheduleWorkerModel>> getScheduleWorker(
      Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['assistance']['schedule-worker-by-date'],
        params: params);
    _apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<ScheduleWorkerModel> list = jsonList
          .map((jsonElement) => ScheduleWorkerModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  Future<List<MarkingWorkerModel>> getMarkingWorker(
      Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['assistance']['marking-worker-by-date'],
        params: params);
    _apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<MarkingWorkerModel> list = jsonList
          .map((jsonElement) => MarkingWorkerModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  Future<List<MarkingWorkerModel>> getJustificationMarkings(String id) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getAll(
        endPoint: endPoints['justification']['request-markings'] + '/' + id);
    _apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<MarkingWorkerModel> list = jsonList
          .map((jsonElement) => MarkingWorkerModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  Future<List<DescriptionMarkingModel>> getDescriptionsMarking() async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getAll(
        endPoint: endPoints['comun']['descriptions-marking']);
    _apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<DescriptionMarkingModel> list = jsonList
          .map((jsonElement) => DescriptionMarkingModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  Future<ApiResponse> createJustification(FormData formData) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.postUpload(
        endPoint: endPoints['assistance']['justification'],
        formData: formData,
        showMessage: false);
    _apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> updateJustification(FormData formData, String id) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.postUpload(
        endPoint: endPoints['assistance']['justification'] + '/' + id,
        formData: formData,
        showMessage: false);
    _apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> changeRequestStatus(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.postParams(
        endPoint: endPoints['justification']['request'] + '/change-status',
        params: params);
    _apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> geFileRequest(Map<String, String> params) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getWithParams(
        endPoint: endPoints['assistance']['justification'] + '/get-file',
        params: params);
    _apiProvider.dispose();
    return response;
  }

  Future<List<ProcessJustifcationModel>> getProcessJustification(
      String id) async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.getAll(
        endPoint: endPoints['assistance']['justification'] + '/process/' + id);
    _apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<ProcessJustifcationModel> list = jsonList
          .map((jsonElement) => ProcessJustifcationModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }
}
