// To parse this JSON data, do
//
//     final deparment = deparmentFromJson(jsonString);

import 'dart:convert';

Deparment deparmentFromJson(String str) => Deparment.fromJson(json.decode(str));

String deparmentToJson(Deparment data) => json.encode(data.toJson());

class Deparment {
  Deparment({
    this.idDepto,
    this.nombre,
    this.selection,
  });

  String? idDepto;
  String? nombre;
  String? selection;

  factory Deparment.fromJson(Map<String, dynamic> json) => Deparment(
        idDepto: json["id_depto"] == null ? null : json["id_depto"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        selection: json["selection"] == null ? null : json["selection"],
      );

  Map<String, dynamic> toJson() => {
        "id_depto": idDepto == null ? null : idDepto,
        "nombre": nombre == null ? null : nombre,
        "selection": selection == null ? null : selection,
      };
}
