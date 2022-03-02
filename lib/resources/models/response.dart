import 'dart:convert';

class ApiResponse {
  bool success = false;
  String message = '';
  dynamic data;
  Meta? meta;

  ApiResponse accessFromJson(String str) =>
      ApiResponse.fromJson(json.decode(str));

  String accessToJson(ApiResponse data) => json.encode(data.toJson());
  ApiResponse(
      {required this.success,
      required this.message,
      required this.data,
      this.meta});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] ?? '',
      meta: json["meta"] == null
          ? Meta.fromJson({})
          : Meta.fromJson(json["meta"]),
    );
  }

  factory ApiResponse.fromJsonNull() {
    return ApiResponse(
        success: false, message: '', data: '', meta: Meta.fromJson({}));
  }
  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data,
        "meta": meta == null ? null : meta!.toJson(),
      };
}

class Meta {
  Meta({
    this.currentPage = 0,
    this.from = 0,
    this.lastPage = 0,
    this.path = '',
    this.perPage = 0,
    this.to = 0,
    this.total = 0,
  });

  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: int.parse((json["current_page"] ?? 0).toString()),
        from: int.parse((json["from"] ?? 0).toString()),
        lastPage: int.parse((json["last_page"] ?? 0).toString()),
        path: json["path"] ?? '',
        perPage: int.parse((json["per_page"] ?? 0).toString()),
        to: int.parse((json["to"] ?? 0).toString()),
        total: int.parse((json["total"] ?? 0).toString()),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}
