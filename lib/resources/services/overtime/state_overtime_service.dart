import 'package:lamb_talent/core/end_points.dart';

import 'package:lamb_talent/resources/providers/api.provider.dart';

import '../../models/overtime/process_overtime.dart';

class StateOvertime {
  Future<List<ProcessOvertimeModel>> getStateOvertime() async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getAll(
        endPoint: endPoints['comun']['overtime-state']);
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
}
