// To parse this JSON data, do
//
//     final justificationModel = justificationModelFromJson(jsonString);

import 'dart:convert';

JustificationModel justificationModelFromJson(String str) => JustificationModel.fromJson(json.decode(str));

String justificationModelToJson(JustificationModel data) => json.encode(data.toJson());

class JustificationModel {
    JustificationModel({
        this.apellidonombre,
        this.numDocumento,
        this.motivo,
        this.idSolicJustif,
        this.idEntidad,
        this.idDepto,
        this.idTrabajador,
        this.idMotivoJustif,
        this.fecha,
        this.descripcion,
        this.evidenciaAdj,
        this.idEstadoJustif,
        this.idUserReg,
        this.fechaReg,
        this.idUserMod,
        this.fechaMod,
        this.estado,
        this.estadoCorto,
        this.orden,
    });

    String? apellidonombre;
    String? numDocumento;
    String? motivo;
    String? idSolicJustif;
    String? idEntidad;
    String? idDepto;
    String? idTrabajador;
    String? idMotivoJustif;
    String? fecha;
    String? descripcion;
    String? evidenciaAdj;
    String? idEstadoJustif;
    String? idUserReg;
    DateTime? fechaReg;
    String? idUserMod;
    DateTime? fechaMod;
    String? estado;
    String? estadoCorto;
    String? orden;

    factory JustificationModel.fromJson(Map<String, dynamic> json) => JustificationModel(
        apellidonombre: json["apellidonombre"] == null ? null : json["apellidonombre"],
        numDocumento: json["num_documento"] == null ? null : json["num_documento"],
        motivo: json["motivo"] == null ? null : json["motivo"],
        idSolicJustif: json["id_solic_justif"] == null ? null : json["id_solic_justif"],
        idEntidad: json["id_entidad"] == null ? null : json["id_entidad"],
        idDepto: json["id_depto"] == null ? null : json["id_depto"],
        idTrabajador: json["id_trabajador"] == null ? null : json["id_trabajador"],
        idMotivoJustif: json["id_motivo_justif"] == null ? null : json["id_motivo_justif"],
        fecha: json["fecha"] == null ? null : json["fecha"],
        descripcion: json["descripcion"],
        evidenciaAdj: json["evidencia_adj"],
        idEstadoJustif: json["id_estado_justif"] == null ? null : json["id_estado_justif"],
        idUserReg: json["id_user_reg"] == null ? null : json["id_user_reg"],
        fechaReg: json["fecha_reg"] == null ? null : DateTime.parse(json["fecha_reg"]),
        idUserMod: json["id_user_mod"] == null ? null : json["id_user_mod"],
        fechaMod: json["fecha_mod"] == null ? null : DateTime.parse(json["fecha_mod"]),
        estado: json["estado"] == null ? null : json["estado"],
        estadoCorto: json["estado_corto"] == null ? null : json["estado_corto"],
        orden: json["orden"] == null ? null : json["orden"]
    );

    Map<String, dynamic> toJson() => {
        "apellidonombre": apellidonombre == null ? null : apellidonombre,
        "num_documento": numDocumento == null ? null : numDocumento,
        "motivo": motivo == null ? null : motivo,
        "id_solic_justif": idSolicJustif == null ? null : idSolicJustif,
        "id_entidad": idEntidad == null ? null : idEntidad,
        "id_depto": idDepto == null ? null : idDepto,
        "id_trabajador": idTrabajador == null ? null : idTrabajador,
        "id_motivo_justif": idMotivoJustif == null ? null : idMotivoJustif,
        "fecha": fecha == null ? null : fecha,
        "descripcion": descripcion,
        "evidencia_adj": evidenciaAdj,
        "id_estado_justif": idEstadoJustif == null ? null : idEstadoJustif,
        "id_user_reg": idUserReg == null ? null : idUserReg,
        "fecha_reg": fechaReg == null ? null : fechaReg!.toIso8601String(),
        "id_user_mod": idUserMod == null ? null : idUserMod,
        "fecha_mod": fechaMod == null ? null : fechaMod!.toIso8601String(),
        "estado": estado == null ? null : estado,
        "estado_corto": estadoCorto == null ? null : estadoCorto,
        "orden": orden == null ? null : orden,
    };
}
