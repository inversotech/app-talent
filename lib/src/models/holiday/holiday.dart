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
        idRolVacacion: json["id_rol_vacacion"] == null ? null : json["id_rol_vacacion"],
        idPeriodoVacTrab: json["id_periodo_vac_trab"] == null ? null : json["id_periodo_vac_trab"],
        fechaIni: json["fecha_ini"] == null ? null : json["fecha_ini"],
        fechaFin: json["fecha_fin"] == null ? null : json["fecha_fin"],
        orden: json["orden"] == null ? null : json["orden"],
        padre: json["padre"] == null ? null : json["padre"],
        dias: json["dias"] == null ? null : json["dias"],
        diasEfect: json["dias_efect"] == null ? null : json["dias_efect"],
        condicion: json["condicion"] == null ? null : json["condicion"],
        idParent: json["id_parent"] == null ? null : json["id_parent"],
        estado: json["estado"] == null ? null : json["estado"],
        confirmacionSalida: json["confirmacion_salida"] == null ? null : json["confirmacion_salida"],
        inihabilitar: json["inihabilitar"] == null ? null : json["inihabilitar"],
        finhabilitar: json["finhabilitar"] == null ? null : json["finhabilitar"],
        confirmacionRetorno: json["confirmacion_retorno"] == null ? null : json["confirmacion_retorno"],
        motivoRepro: json["motivo_repro"] == null ? null : json["motivo_repro"],
        idTipoRolVac: json["id_tipo_rol_vac"] == null ? null : json["id_tipo_rol_vac"],
        estadoTrab: json["estado_trab"] == null ? null : json["estado_trab"],
        idEstadoVacTrab: json["id_estado_vac_trab"] == null ? null : json["id_estado_vac_trab"],
        nombrePeriodo: json["nombre_periodo"] == null ? null : json["nombre_periodo"],
        correo: json["correo"] == null ? null : json["correo"],
        fechaCalculado: json["fecha_calculado"] == null ? null : json["fecha_calculado"],
    );

    Map<String, dynamic> toJson() => {
        "id_rol_vacacion": idRolVacacion == null ? null : idRolVacacion,
        "id_periodo_vac_trab": idPeriodoVacTrab == null ? null : idPeriodoVacTrab,
        "fecha_ini": fechaIni == null ? null : fechaIni,
        "fecha_fin": fechaFin == null ? null : fechaFin,
        "orden": orden == null ? null : orden,
        "padre": padre == null ? null : padre,
        "dias": dias == null ? null : dias,
        "dias_efect": diasEfect == null ? null : diasEfect,
        "condicion": condicion == null ? null : condicion,
        "id_parent": idParent == null ? null : idParent,
        "estado": estado == null ? null : estado,
        "confirmacion_salida": confirmacionSalida == null ? null : confirmacionSalida,
        "inihabilitar": inihabilitar == null ? null : inihabilitar,
        "finhabilitar": finhabilitar == null ? null : finhabilitar,
        "confirmacion_retorno": confirmacionRetorno == null ? null : confirmacionRetorno,
        "motivo_repro": motivoRepro == null ? null : motivoRepro,
        "id_tipo_rol_vac": idTipoRolVac == null ? null : idTipoRolVac,
        "estado_trab": estadoTrab == null ? null : estadoTrab,
        "id_estado_vac_trab": idEstadoVacTrab == null ? null : idEstadoVacTrab,
        "nombre_periodo": nombrePeriodo == null ? null : nombrePeriodo,
        "correo": correo == null ? null : correo,
        "fecha_calculado": fechaCalculado == null ? null : fechaCalculado,
    };
}
