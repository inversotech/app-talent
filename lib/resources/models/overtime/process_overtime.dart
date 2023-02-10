// To parse this JSON data, do
//
//     final processOvertimeModel = processOvertimeModelFromJson(jsonString);

import 'dart:convert';

ProcessOvertimeModel processOvertimeModelFromJson(String str) =>
    ProcessOvertimeModel.fromJson(json.decode(str));

String processOvertimeModelToJson(ProcessOvertimeModel data) =>
    json.encode(data.toJson());

class ProcessOvertimeModel {
  ProcessOvertimeModel({
    this.idEstadoSobretiempo,
    this.nombre,
    this.nombrecorto,
    this.orden,
    this.idSobretiempoEstado,
    this.idEstadoSobretiempoB,
    this.comentario,
    this.idUserReg,
    this.fecha,
    this.idSobretiempo,
    this.email,
  });

  String? idEstadoSobretiempo;
  String? nombre;
  String? nombrecorto;
  String? orden;
  String? idSobretiempoEstado;
  String? idEstadoSobretiempoB;
  dynamic comentario;
  String? idUserReg;
  String? fecha;
  String? idSobretiempo;
  String? email;

  factory ProcessOvertimeModel.fromJson(Map<String, dynamic> json) =>
      ProcessOvertimeModel(
        idEstadoSobretiempo: json["id_estado_sobretiempo"],
        nombre: json["nombre"],
        nombrecorto: json["nombrecorto"],
        orden: json["orden"],
        idSobretiempoEstado: json["id_sobretiempo_estado"],
        idEstadoSobretiempoB: json["id_estado_sobretiempo_b"],
        comentario: json["comentario"],
        idUserReg: json["id_user_reg"],
        fecha: json["fecha"],
        idSobretiempo: json["id_sobretiempo"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id_estado_sobretiempo": idEstadoSobretiempo,
        "nombre": nombre,
        "nombrecorto": nombrecorto,
        "orden": orden,
        "id_sobretiempo_estado": idSobretiempoEstado,
        "id_estado_sobretiempo_b": idEstadoSobretiempoB,
        "comentario": comentario,
        "id_user_reg": idUserReg,
        "fecha": fecha,
        "id_sobretiempo": idSobretiempo,
        "email": email,
      };
}
