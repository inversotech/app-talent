// To parse this JSON data, do
//
//     final entity = entityFromJson(jsonString);

import 'dart:convert';

Entity entityFromJson(String str) => Entity.fromJson(json.decode(str));

String entityToJson(Entity data) => json.encode(data.toJson());

class Entity {
  Entity({
    this.estado,
    this.idEntidad,
    this.idPersona,
    this.idTrabajador,
    this.nombre,
    this.selection,
  });

  String? estado;
  String? idEntidad;
  String? idPersona;
  String? idTrabajador;
  String? nombre;
  String? selection;

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
        estado: json["estado"] == null ? null : json["estado"],
        idEntidad: json["id_entidad"] == null ? null : json["id_entidad"],
        idPersona: json["id_persona"] == null ? null : json["id_persona"],
        idTrabajador: json["id_trabajador"] == null ? null : json["id_trabajador"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        selection: json["selection"] == null ? null : json["selection"],
      );

  Map<String, dynamic> toJson() => {
        "estado": estado == null ? null : estado,
        "id_entidad": idEntidad == null ? null : idEntidad,
        "id_persona": idPersona == null ? null : idPersona,
        "id_trabajador": idTrabajador == null ? null : idTrabajador,
        "nombre": nombre == null ? null : nombre,
        "selection": selection == null ? null : selection,
      };
}
