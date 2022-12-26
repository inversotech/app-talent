import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

class PersonService {
  Future<dynamic> getSign(Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['comun']['person-signature'], params: params);
    //_apiProvider.dispose();
    if (response.success) {
      return response.data;
    } else {
      return {};
    }
  }
}
