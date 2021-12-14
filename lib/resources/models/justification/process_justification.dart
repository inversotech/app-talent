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
        idEstadoJustif: json["id_estado_justif"],
        nombre: json["nombre"],
        nombrecorto: json["nombrecorto"],
        orden: json["orden"],
        vigencia: json["vigencia"],
        email: json["email"],
        fecha: json["fecha"],
        idSolicJustif: json["id_solic_justif"],
        comentario: json["comentario"],
    );

    Map<String, dynamic> toJson() => {
        "id_estado_justif": idEstadoJustif,
        "nombre": nombre,
        "nombrecorto": nombrecorto,
        "orden": orden,
        "vigencia": vigencia,
        "email": email,
        "fecha": fecha,
        "id_solic_justif": idSolicJustif,
        "comentario": comentario,
    };
}
