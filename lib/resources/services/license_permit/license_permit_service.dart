import 'package:get/get.dart';
import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';

class LicensePermitService {
  Future<PaginationModel> getLicensesPermits(Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['benefits']['license-permit'], params: params);
    //_apiProvider.dispose();
    if (response.success) {
      PaginationModel pagination = PaginationModel.fromJson(
          response.data.containsKey('items') ? response.data['items'] : []);
      return pagination;
    } else {
      return PaginationModel.fromJson({});
    }
  }

  Future<ApiResponse> getLicensesPermit(String id) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getAll(
        endPoint: endPoints['benefits']['license-permit-detail'] + '/' + id);
    //_apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> chageStatusLicensePermit(
      String id, Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.putWithId(
        endPoint: endPoints['benefits']['license-permit'],
        id: id,
        params: params);
    //_apiProvider.dispose();
    return response;
  }

  Future<List<TypeLicensePermitModel>> getTypeLicensePermit() async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getAll(
        endPoint: endPoints['comun']['type-licen-per']);
    //_apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<TypeLicensePermitModel> list = jsonList
          .map((jsonElement) => TypeLicensePermitModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  Future<List<TypeConceptLicensePermitModel>> getTypeConceptLicensePermit(
      Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['comun']['type-concept-licen-per'], params: params);
    //_apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<TypeConceptLicensePermitModel> list = jsonList
          .map((jsonElement) =>
              TypeConceptLicensePermitModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  Future<List<TypeInstitutionModel>> getTypeInstitution() async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getAll(
        endPoint: endPoints['comun']['type-institution']);
    //_apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<TypeInstitutionModel> list = jsonList
          .map((jsonElement) => TypeInstitutionModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  Future<List<StateLicensePermitModel>> getProcessLicensePermit(
      String id) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getAll(
        endPoint: endPoints['benefits']['process-license-permit'] + '/' + id);
    //_apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<StateLicensePermitModel> list = jsonList
          .map((jsonElement) => StateLicensePermitModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  Future<List<ValidLicensePermitModel>> getValidateLicensePermit(
      Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['benefits']['valid-license-permit'],
        params: params);
    //_apiProvider.dispose();
    if (response.success) {
      List<dynamic> jsonList = response.data as List;

      List<ValidLicensePermitModel> list = jsonList
          .map((jsonElement) => ValidLicensePermitModel.fromJson(jsonElement))
          .toList();
      return list;
    } else {
      return [];
    }
  }

  Future<ApiResponse> createLicensePermit(FormData formData) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.postUpload(
        endPoint: endPoints['workerportal']['license-permit'],
        formData: formData,
        showMessage: false);
    //_apiProvider.dispose();
    return response;
  }

  Future<ApiResponse> geFileRequest(Map<String, String> params) async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getWithParams(
        endPoint: endPoints['comun']['file-view'], params: params);
    //_apiProvider.dispose();
    return response;
  }
}
