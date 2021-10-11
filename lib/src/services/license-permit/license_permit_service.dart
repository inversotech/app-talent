import 'package:upn_financiero_mobil/src/models/models.dart'
    show
        ApiResponse,
        PaginationModel,
        StateLicensePermitModel,
        TypeConceptLicensePermitModel,
        TypeInstitutionModel,
        TypeLicensePermitModel,
        ValidLicensePermitModel;
import 'package:upn_financiero_mobil/src/providers/utils/end_points.dart';
import 'package:upn_financiero_mobil/src/services/api_rest_service.dart';

class LicensePermitService {
  Future<PaginationModel> getLicensesPermits(Map<String, String> params) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['workerportal']['license-permit'], body: params);
    if (response.success) {
      PaginationModel pagination = PaginationModel.fromJson(response.data);
      return pagination;
    } else {
      return PaginationModel.fromJson({});
    }
  }

  Future<ApiResponse> getLicensesPermit(String id) async {
    final response = await ApiRestService.get(
        endPoint: endPoints['benefits']['license-permit-detail'] + '/' + id);
    return response;
  }

  Future<ApiResponse> chageStatusLicensePermit(
      String id, Map<String, String> params) async {
    final response = await ApiRestService.put(
        endPoint: endPoints['benefits']['license-permit'],
        id: id,
        body: params);
    return response;
  }

  Future<List<TypeLicensePermitModel>> getTypeLicensePermit() async {
    final response = await ApiRestService.get(
        endPoint: endPoints['comun']['type-licen-per']);
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
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['comun']['type-concept-licen-per'], body: params);
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
    final response = await ApiRestService.get(
        endPoint: endPoints['comun']['type-institution']);
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
    final response = await ApiRestService.get(
        endPoint: endPoints['benefits']['process-license-permit'] + '/' + id);
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
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['benefits']['valid-license-permit'], body: params);
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

  Future<ApiResponse> createLicensePermit(
      Map<String, String> params, List<Map<String, String>> files) async {
    if (files.isNotEmpty) {
      final response = await ApiRestService.uploadMultiple(
          endPoint: endPoints['workerportal']['license-permit'],
          body: params,
          files: files);
      return response;
    } else {
      final response = await ApiRestService.post(
          endPoint: endPoints['workerportal']['license-permit'], body: params);
      return response;
    }
  }

  
  Future<ApiResponse> geFileRequest(Map<String, String> params) async {
    final response = await ApiRestService.getWithParams(
        endPoint: endPoints['comun']['file-view'],
        body: params);
    return response;
  }
}
