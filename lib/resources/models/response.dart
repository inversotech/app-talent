import 'dart:convert';

class ApiResponse {
  bool success = false;
  String message = '';
  dynamic data;

  ApiResponse accessFromJson(String str) =>
      ApiResponse.fromJson(json.decode(str));

  String accessToJson(ApiResponse data) => json.encode(data.toJson());
  ApiResponse(
      {required this.success, required this.message, required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] ?? '');
  }

  factory ApiResponse.fromJsonNull() {
    return ApiResponse(success: false, message: '', data: '');
  }
  Map<String, dynamic> toJson() =>
      {'success': success, 'message': message, 'data': data};
}
