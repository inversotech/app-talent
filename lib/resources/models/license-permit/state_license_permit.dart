// To parse this JSON data, do
//
//     final stateLicensePermitModel = stateLicensePermitModelFromJson(jsonString);

import 'dart:convert';

StateLicensePermitModel stateLicensePermitModelFromJson(String str) => StateLicensePermitModel.fromJson(json.decode(str));

String stateLicensePermitModelToJson(StateLicensePermitModel data) => json.encode(data.toJson());

class StateLicensePermitModel {
    StateLicensePermitModel({
        this.idEstadoLicaPer,
        this.nombre,
        this.nombrecorto,
        this.vigencia,
        this.comentario,
        this.email,
        this.fecha,
        this.idLicenciaPermiso,
    });

    String? idEstadoLicaPer;
    String? nombre;
    String? nombrecorto;
    String? vigencia;
    String? comentario;
    String? email;
    String? fecha;
    String? idLicenciaPermiso;

    factory StateLicensePermitModel.fromJson(Map<String, dynamic> json) => StateLicensePermitModel(
        idEstadoLicaPer: json["id_estado_lica_per"],
        nombre: json["nombre"],
        nombrecorto: json["nombrecorto"],
        vigencia: json["vigencia"],
        comentario: json["comentario"],
        email: json["email"],
        fecha: json["fecha"],
        idLicenciaPermiso: json["id_licencia_permiso"],
    );

    Map<String, dynamic> toJson() => {
        "id_estado_lica_per": idEstadoLicaPer,
        "nombre": nombre,
        "nombrecorto": nombrecorto,
        "vigencia": vigencia,
        "comentario": comentario,
        "email": email,
        "fecha": fecha,
        "id_licencia_permiso": idLicenciaPermiso,
    };
}
