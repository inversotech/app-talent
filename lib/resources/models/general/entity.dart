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
        estado: json["estado"],
        idEntidad: json["id_entidad"],
        idPersona: json["id_persona"],
        idTrabajador: json["id_trabajador"],
        nombre: json["nombre"],
        selection: json["selection"],
      );

  Map<String, dynamic> toJson() => {
        "estado": estado,
        "id_entidad": idEntidad,
        "id_persona": idPersona,
        "id_trabajador": idTrabajador,
        "nombre": nombre,
        "selection": selection,
      };
}
