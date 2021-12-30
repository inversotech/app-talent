// To parse this JSON data, do
//
//     final holidayModel = holidayModelFromJson(jsonString);

import 'dart:convert';

HolidayModel holidayModelFromJson(String str) => HolidayModel.fromJson(json.decode(str));

String holidayModelToJson(HolidayModel data) => json.encode(data.toJson());

class HolidayModel {
    HolidayModel({
        this.idRolVacacion,
        this.idPeriodoVacTrab,
        this.fechaIni,
        this.fechaFin,
        this.orden,
        this.padre,
        this.dias,
        this.diasEfect,
        this.condicion,
        this.idParent,
        this.estado,
        this.confirmacionSalida,
        this.inihabilitar,
        this.finhabilitar,
        this.confirmacionRetorno,
        this.motivoRepro,
        this.idTipoRolVac,
        this.estadoTrab,
        this.idEstadoVacTrab,
        this.nombrePeriodo,
        this.correo,
        this.fechaCalculado,
    });

    String? idRolVacacion;
    String? idPeriodoVacTrab;
    String? fechaIni;
    String? fechaFin;
    String? orden;
    String? padre;
    String? dias;
    String? diasEfect;
    String? condicion;
    String? idParent;
    String? estado;
    String? confirmacionSalida;
    String? inihabilitar;
    String? finhabilitar;
    String? confirmacionRetorno;
    String? motivoRepro;
    String? idTipoRolVac;
    String? estadoTrab;
    String? idEstadoVacTrab;
    String? nombrePeriodo;
    String? correo;
    String? fechaCalculado;

    factory HolidayModel.fromJson(Map<String, dynamic> json) => HolidayModel(
        idRolVacacion: json["id_rol_vacacion"],
        idPeriodoVacTrab: json["id_periodo_vac_trab"],
        fechaIni: json["fecha_ini"],
        fechaFin: json["fecha_fin"],
        orden: json["orden"],
        padre: json["padre"],
        dias: json["dias"],
        diasEfect: json["dias_efect"],
        condicion: json["condicion"],
        idParent: json["id_parent"],
        estado: json["estado"],
        confirmacionSalida: json["confirmacion_salida"],
        inihabilitar: json["inihabilitar"] == null ? '' : json["inihabilitar"].toString(),
        finhabilitar: json["finhabilitar"] == null ? '' : json["finhabilitar"].toString(),
        confirmacionRetorno: json["confirmacion_retorno"],
        motivoRepro: json["motivo_repro"],
        idTipoRolVac: json["id_tipo_rol_vac"],
        estadoTrab: json["estado_trab"],
        idEstadoVacTrab: json["id_estado_vac_trab"],
        nombrePeriodo: json["nombre_periodo"],
        correo: json["correo"],
        fechaCalculado: json["fecha_calculado"],
    );

    Map<String, dynamic> toJson() => {
        "id_rol_vacacion": idRolVacacion,
        "id_periodo_vac_trab": idPeriodoVacTrab,
        "fecha_ini": fechaIni,
        "fecha_fin": fechaFin,
        "orden": orden,
        "padre": padre,
        "dias": dias,
        "dias_efect": diasEfect,
        "condicion": condicion,
        "id_parent": idParent,
        "estado": estado,
        "confirmacion_salida": confirmacionSalida,
        "inihabilitar": inihabilitar,
        "finhabilitar": finhabilitar,
        "confirmacion_retorno": confirmacionRetorno,
        "motivo_repro": motivoRepro,
        "id_tipo_rol_vac": idTipoRolVac,
        "estado_trab": estadoTrab,
        "id_estado_vac_trab": idEstadoVacTrab,
        "nombre_periodo": nombrePeriodo,
        "correo": correo,
        "fecha_calculado": fechaCalculado,
    };
}
