// To parse this JSON data, do
//
//     final typeOvertimeModel = typeOvertimeModelFromJson(jsonString);

import 'dart:convert';

TypeOvertimeModel typeOvertimeModelFromJson(String str) =>
    TypeOvertimeModel.fromJson(json.decode(str));

String typeOvertimeModelToJson(TypeOvertimeModel data) =>
    json.encode(data.toJson());

class TypeOvertimeModel {
  TypeOvertimeModel({
    this.idTipoSobretiempo,
    this.codigo,
    this.nombre,
    this.vigencia,
  });

  String? idTipoSobretiempo;
  String? codigo;
  String? nombre;
  String? vigencia;

  factory TypeOvertimeModel.fromJson(Map<String, dynamic> json) =>
      TypeOvertimeModel(
        idTipoSobretiempo: json["id_tipo_sobretiempo"],
        codigo: json["codigo"],
        nombre: json["nombre"],
        vigencia: json["vigencia"],
      );

  Map<String, dynamic> toJson() => {
        "id_tipo_sobretiempo": idTipoSobretiempo,
        "codigo": codigo,
        "nombre": nombre,
        "vigencia": vigencia,
      };
}
