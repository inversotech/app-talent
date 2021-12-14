// To parse this JSON data, do
//
//     final workerHoliday = workerHolidayFromJson(jsonString);

import 'dart:convert';

WorkerHolidayModel workerHolidayFromJson(String str) => WorkerHolidayModel.fromJson(json.decode(str));

String workerHolidayToJson(WorkerHolidayModel data) => json.encode(data.toJson());

class WorkerHolidayModel {
    WorkerHolidayModel({
        this.idPersona,
        this.idTrabajador,
        this.nombres,
        this.numDocumento,
        this.periodoIni,
        this.periodoFin,
        this.totalDias,
        this.totalDiasEfect,
        this.estado,
        this.idEstadoVacTrab,
        this.idPeriodoVac,
        this.idPeriodoVacTrab,
        this.diasAnho,
        this.firmadosSalida,
        this.firmadosRetorno,
        this.totalFirmmar,
        this.editar,
    });

    String? idPersona;
    String? idTrabajador;
    String? nombres;
    String? numDocumento;
    DateTime? periodoIni;
    DateTime? periodoFin;
    String? totalDias;
    String? totalDiasEfect;
    String? estado;
    String? idEstadoVacTrab;
    String? idPeriodoVac;
    String? idPeriodoVacTrab;
    String? diasAnho;
    String? firmadosSalida;
    String? firmadosRetorno;
    String? totalFirmmar;
    String? editar;

    factory WorkerHolidayModel.fromJson(Map<String, dynamic> json) => WorkerHolidayModel(
        idPersona: json["id_persona"],
        idTrabajador: json["id_trabajador"],
        nombres: json["nombres"],
        numDocumento: json["num_documento"],
        periodoIni: json["periodo_ini"] == null ? null : DateTime.parse(json["periodo_ini"]),
        periodoFin: json["periodo_fin"] == null ? null : DateTime.parse(json["periodo_fin"]),
        totalDias: json["total_dias"],
        totalDiasEfect: json["total_dias_efect"],
        estado: json["estado"],
        idEstadoVacTrab: json["id_estado_vac_trab"],
        idPeriodoVac: json["id_periodo_vac"],
        idPeriodoVacTrab: json["id_periodo_vac_trab"],
        diasAnho: json["dias_anho"],
        firmadosSalida: json["firmados_salida"],
        firmadosRetorno: json["firmados_retorno"],
        totalFirmmar: json["total_firmmar"],
        editar: json["editar"],
    );

    Map<String, dynamic> toJson() => {
        "id_persona": idPersona,
        "id_trabajador": idTrabajador,
        "nombres": nombres,
        "num_documento": numDocumento,
        "periodo_ini": periodoIni == null ? null : "${periodoIni!.year.toString().padLeft(4, '0')}-${periodoIni!.month.toString().padLeft(2, '0')}-${periodoIni!.day.toString().padLeft(2, '0')}",
        "periodo_fin": periodoFin == null ? null : "${periodoFin!.year.toString().padLeft(4, '0')}-${periodoFin!.month.toString().padLeft(2, '0')}-${periodoFin!.day.toString().padLeft(2, '0')}",
        "total_dias": totalDias,
        "total_dias_efect": totalDiasEfect,
        "estado": estado,
        "id_estado_vac_trab": idEstadoVacTrab,
        "id_periodo_vac": idPeriodoVac,
        "id_periodo_vac_trab": idPeriodoVacTrab,
        "dias_anho": diasAnho,
        "firmados_salida": firmadosSalida,
        "firmados_retorno": firmadosRetorno,
        "total_firmmar": totalFirmmar,
        "editar": editar,
    };
}
