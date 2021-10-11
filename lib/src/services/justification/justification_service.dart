import 'package:upn_financiero_mobil/src/models/models.dart';
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class JustificationService {
  Future<PaginationModel> getJustifications(Map<String, String> params) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['assistance']['request-by-worker'], body: params);
    if (response.success) {
      PaginationModel pagination = PaginationModel.fromJson(response.data);
      return pagination;
    } else {
      return PaginationModel.fromJson({});
    }
  }

  Future<ApiResponse> getJustification(String id) async {
    final response = await ApiRestService.get(
        endPoint: endPoints['justification']['request'] + '/' + id);
    return response;
  }

  Future<List<ReasonJustificationModel>> getReasonsJustification() async {
    final response = await ApiRestService.get(
        endPoint: endPoints['assistance']['justification-reason']);
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
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['assistance']['schedule-worker-by-date'],
        body: params);
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
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['assistance']['marking-worker-by-date'],
        body: params);
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
    final response = await ApiRestService.get(
        endPoint: endPoints['justification']['request-markings'] + '/' + id);
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
    final response = await ApiRestService.get(
        endPoint: endPoints['comun']['descriptions-marking']);
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

  Future<ApiResponse> createJustification(Map<String, String> params) async {
    if (params['archivo']!.isNotEmpty) {
      final response = await ApiRestService.upload(
          endPoint: endPoints['assistance']['justification'],
          body: params,
          fielNameFile: 'archivo',
          filePath: params['archivo'].toString());
      return response;
    } else {
      final response = await ApiRestService.post(
          endPoint: endPoints['assistance']['justification'], body: params);
      return response;
    }
  }

  Future<ApiResponse> updateJustification(
      Map<String, String> params, String id) async {
    if (params['archivo']!.isNotEmpty) {
      final response = await ApiRestService.upload(
          endPoint: endPoints['assistance']['justification'] + '/' + id,
          body: params,
          fielNameFile: 'archivo',
          filePath: params['archivo'].toString());
      return response;
    } else {
      final response = await ApiRestService.post(
          endPoint: endPoints['assistance']['justification'] + '/' + id,
          body: params);
      return response;
    }
  }

  Future<ApiResponse> changeRequestStatus(Map<String, String> params) async {
    final response = await ApiRestService.post(
        endPoint: endPoints['justification']['request'] + '/change-status',
        body: params);
    return response;
  }

  Future<ApiResponse> geFileRequest(Map<String, String> params) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['assistance']['justification'] + '/get-file',
        body: params);
    return response;
  }

  Future<List<ProcessJustifcationModel>> getProcessJustification(
      String id) async {
    final response = await ApiRestService.get(
        endPoint: endPoints['assistance']['justification'] + '/process/' + id);
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
