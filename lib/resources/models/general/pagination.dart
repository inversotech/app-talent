// To parse this JSON data, do
//
//     final paginationModel = paginationModelFromJson(jsonString);

import 'dart:convert';

PaginationModel paginationModelFromJson(String str) => PaginationModel.fromJson(json.decode(str));

String paginationModelToJson(PaginationModel data) => json.encode(data.toJson());

class PaginationModel {
    PaginationModel({
        this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total = 0
    });

    int? currentPage;
    List<dynamic>? data;
    String? firstPageUrl;
    int? from;
    int? lastPage;
    String? lastPageUrl;
    String? nextPageUrl;
    String? path;
    int? perPage;
    String? prevPageUrl;
    int? to;
    int total = 0;

    factory PaginationModel.fromJson(Map<String, dynamic> json) => PaginationModel(
        currentPage: json["current_page"] ?? 0,
        data: json["data"] == null ? null : List<dynamic>.from(json["data"].map((x) => x)),
        firstPageUrl: json["first_page_url"],
        from: json["from"] ?? 0,
        lastPage: json["last_page"] ?? 0,
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"] ?? 0,
        prevPageUrl: json["prev_page_url"],
        to: json["to"] ?? 0,
        total: json["total"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x)),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
    };
    
}
