// To parse this JSON data, do
//
//     final entity = entityFromJson(jsonString);

import 'dart:convert';

Entity entityFromJson(String str) => Entity.fromJson(json.decode(str));

String entityToJson(Entity data) => json.encode(data.toJson());

class Entity {
  Entity({
    this.id = 0,
    this.idEmpresa = 0,
    this.idTipoentidad = 0,
    this.name = '',
    this.tipo = '',
  });

  int id;
  int idEmpresa;
  int idTipoentidad;
  String name;
  String tipo;

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
        id: json["id"],
        idEmpresa: json["id_empresa"],
        idTipoentidad: json["id_tipoentidad"],
        name: json["name"],
        tipo: json["tipo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_empresa": idEmpresa,
        "id_tipoentidad": idTipoentidad,
        "name": name,
        "tipo": tipo,
      };
}
