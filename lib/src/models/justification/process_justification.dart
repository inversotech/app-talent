// To parse this JSON data, do
//
//     final processJustifcationModel = processJustifcationModelFromJson(jsonString);

import 'dart:convert';

ProcessJustifcationModel processJustifcationModelFromJson(String str) => ProcessJustifcationModel.fromJson(json.decode(str));

String processJustifcationModelToJson(ProcessJustifcationModel data) => json.encode(data.toJson());

class ProcessJustifcationModel {
    ProcessJustifcationModel({
        this.idEstadoJustif,
        this.nombre,
        this.nombrecorto,
        this.orden,
        this.vigencia,
        this.email,
        this.fecha,
        this.idSolicJustif,
        this.comentario,
    });

    String? idEstadoJustif;
    String? nombre;
    String? nombrecorto;
    String? orden;
    String? vigencia;
    String? email;
    String? fecha;
    String? idSolicJustif;
    String? comentario;

    factory ProcessJustifcationModel.fromJson(Map<String, dynamic> json) => ProcessJustifcationModel(
        idEstadoJustif: json["id_estado_justif"] == null ? null : json["id_estado_justif"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        nombrecorto: json["nombrecorto"] == null ? null : json["nombrecorto"],
        orden: json["orden"] == null ? null : json["orden"],
        vigencia: json["vigencia"] == null ? null : json["vigencia"],
        email: json["email"] == null ? null : json["email"],
        fecha: json["fecha"] == null ? null : json["fecha"],
        idSolicJustif: json["id_solic_justif"] == null ? null : json["id_solic_justif"],
        comentario: json["comentario"] == null ? null : json["comentario"],
    );

    Map<String, dynamic> toJson() => {
        "id_estado_justif": idEstadoJustif == null ? null : idEstadoJustif,
        "nombre": nombre == null ? null : nombre,
        "nombrecorto": nombrecorto == null ? null : nombrecorto,
        "orden": orden == null ? null : orden,
        "vigencia": vigencia == null ? null : vigencia,
        "email": email == null ? null : email,
        "fecha": fecha == null ? null : fecha,
        "id_solic_justif": idSolicJustif == null ? null : idSolicJustif,
        "comentario": comentario == null ? null : comentario,
    };
}
