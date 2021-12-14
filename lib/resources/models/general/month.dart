import 'dart:convert';

MonthModel monthModelFromJson(String str) =>
    MonthModel.fromJson(json.decode(str));

String monthModelToJson(MonthModel data) => json.encode(data.toJson());

class MonthModel {
  MonthModel({
    required this.idMes,
    required this.nombre,
    this.siglas,
  });

  int idMes;
  String nombre;
  String? siglas;

  factory MonthModel.fromJson(Map<String, dynamic> json) => MonthModel(
        idMes: int.parse(json["id_mes"]),
        nombre: json["nombre"],
        siglas: json["siglas"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id_mes": idMes,
        "nombre": nombre,
        "siglas": siglas,
      };
}
