import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/general/pagination.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

class WorkerService {
  Future<PaginationModel> getMyWorkers(Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['comun']['my-workers'], params: params);
    //_apiProvider.dispose();
    if (response.success) {
      PaginationModel pagination = PaginationModel.fromJson(response.data);
      return pagination;
    } else {
      return PaginationModel.fromJson({});
    }
  }
}
