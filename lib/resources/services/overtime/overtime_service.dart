import 'package:get/get.dart';
import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/resources/models/overtime/process_overtime.dart';
import 'package:lamb_talent/resources/models/overtime/schedule_worker_overtime.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

import '../../models/overtime/type_overtime.dart';

class OvertimeService {
  Future<PaginationModel> getOvertimes(Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['assistance']['register'], params: params);
    if (response.success) {
      PaginationModel pagination =
          response.data.runtimeType.toString() == 'List<dynamic>'
              ? PaginationModel()
              : PaginationModel.fromJson(response.data);
      return pagination;
    } else {
      return PaginationModel.fromJson({});
    }
  }

  Future<ApiResponse> getOvertime(String id) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getAll(
        endPoint: endPoints['comun']['show-overtime'] + '/' + id);
    //_apiProvider.dispose();
    return response;
  }

  Future<List<TypeOvertimeModel>> getTypeOvertime() async {
    final apiProvider = ApiProvider();
    final response =
        await apiProvider.getAll(endPoint: endPoints['comun']['overtime-type']);
    //_apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<TypeOvertimeModel> list = jsonList
          .map((jsonElement) => TypeOvertimeModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  Future<ScheduleWorkerOvertimeModel> getScheduleWorker(
      Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['assistance']['worker-scheduled-hours'],
        params: params);
    if (response.success) {
      ScheduleWorkerOvertimeModel res =
          ScheduleWorkerOvertimeModel.fromJson(response.data);
      return res;
    } else {
      return ScheduleWorkerOvertimeModel.fromJson({});
    }
  }

  Future<List<ActionModule>> getActionsByModule(
      Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['comun']['actions-by-module'], params: params);
    //_apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<ActionModule> list = jsonList
          .map((jsonElement) => ActionModule.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  Future<List<ProcessOvertimeModel>> getProcessOvertime(String id) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getAll(
        endPoint: endPoints['comun']['get-process-overtime'] + '/' + id);
    //_apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<ProcessOvertimeModel> list = jsonList
          .map((jsonElement) => ProcessOvertimeModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  Future<ApiResponse> chageStatusOvertime(
      String id, Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.putWithId(
        endPoint: endPoints['assistance']['registerStatus'],
        id: id,
        params: params);
    //_apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> createOvertime(Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.postParams(
        endPoint: endPoints['assistance']['register'], params: params);
    return response;
  }
}
