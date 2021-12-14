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
        apellidonombre: json["apellidonombre"],
        numDocumento: json["num_documento"],
        motivo: json["motivo"],
        idSolicJustif: json["id_solic_justif"],
        idEntidad: json["id_entidad"],
        idDepto: json["id_depto"],
        idTrabajador: json["id_trabajador"],
        idMotivoJustif: json["id_motivo_justif"],
        fecha: json["fecha"],
        descripcion: json["descripcion"],
        evidenciaAdj: json["evidencia_adj"],
        idEstadoJustif: json["id_estado_justif"],
        idUserReg: json["id_user_reg"],
        fechaReg: json["fecha_reg"] == null ? null : DateTime.parse(json["fecha_reg"]),
        idUserMod: json["id_user_mod"],
        fechaMod: json["fecha_mod"] == null ? null : DateTime.parse(json["fecha_mod"]),
        estado: json["estado"],
        estadoCorto: json["estado_corto"],
        orden: json["orden"]
    );

    Map<String, dynamic> toJson() => {
        "apellidonombre": apellidonombre,
        "num_documento": numDocumento,
        "motivo": motivo,
        "id_solic_justif": idSolicJustif,
        "id_entidad": idEntidad,
        "id_depto": idDepto,
        "id_trabajador": idTrabajador,
        "id_motivo_justif": idMotivoJustif,
        "fecha": fecha,
        "descripcion": descripcion,
        "evidencia_adj": evidenciaAdj,
        "id_estado_justif": idEstadoJustif,
        "id_user_reg": idUserReg,
        "fecha_reg": fechaReg == null ? null : fechaReg!.toIso8601String(),
        "id_user_mod": idUserMod,
        "fecha_mod": fechaMod == null ? null : fechaMod!.toIso8601String(),
        "estado": estado,
        "estado_corto": estadoCorto,
        "orden": orden,
    };
}
