// To parse this JSON data, do
//
//     final fileModel = fileModelFromJson(jsonString);

import 'dart:convert';

FileModel fileModelFromJson(String str) => FileModel.fromJson(json.decode(str));

String fileModelToJson(FileModel data) => json.encode(data.toJson());

class FileModel {
  FileModel({
    this.file = '',
    this.fileName = '',
    this.clave = '',
    this.base = '',
  });

  String file;
  String fileName;
  String clave;
  String base;

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
        file: json["file"] ?? '',
        fileName: json["file_name"] ?? '',
        clave: json["clave"] ?? '',
        base: json["base"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "file": file,
        "file_name": fileName,
        "clave": clave,
        "base": base,
      };
}
