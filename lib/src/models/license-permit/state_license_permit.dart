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
        idEstadoLicaPer: json["id_estado_lica_per"] == null ? null : json["id_estado_lica_per"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        nombrecorto: json["nombrecorto"] == null ? null : json["nombrecorto"],
        vigencia: json["vigencia"] == null ? null : json["vigencia"],
        comentario: json["comentario"] == null ? null : json["comentario"],
        email: json["email"] == null ? null : json["email"],
        fecha: json["fecha"] == null ? null : json["fecha"],
        idLicenciaPermiso: json["id_licencia_permiso"] == null ? null : json["id_licencia_permiso"],
    );

    Map<String, dynamic> toJson() => {
        "id_estado_lica_per": idEstadoLicaPer == null ? null : idEstadoLicaPer,
        "nombre": nombre == null ? null : nombre,
        "nombrecorto": nombrecorto == null ? null : nombrecorto,
        "vigencia": vigencia == null ? null : vigencia,
        "comentario": comentario == null ? null : comentario,
        "email": email == null ? null : email,
        "fecha": fecha == null ? null : fecha,
        "id_licencia_permiso": idLicenciaPermiso == null ? null : idLicenciaPermiso,
    };
}
