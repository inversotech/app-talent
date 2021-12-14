// To parse this JSON data, do
//
//     final periodoVacation = periodoVacationFromJson(jsonString);

import 'dart:convert';

PeriodoVacation periodoVacationFromJson(String str) => PeriodoVacation.fromJson(json.decode(str));

String periodoVacationToJson(PeriodoVacation data) => json.encode(data.toJson());

class PeriodoVacation {
    PeriodoVacation({
        this.idPeriodoVac,
        this.nombre,
        this.minDiasPeriodo1,
        this.minDiasPeriodo2,
        this.anhoInicio,
        this.idEstadoPeriodoVac,
    });

    String? idPeriodoVac;
    String? nombre;
    String? minDiasPeriodo1;
    String? minDiasPeriodo2;
    String? anhoInicio;
    String? idEstadoPeriodoVac;

    factory PeriodoVacation.fromJson(Map<String, dynamic> json) => PeriodoVacation(
        idPeriodoVac: json["id_periodo_vac"],
        nombre: json["nombre"],
        minDiasPeriodo1: json["min_dias_periodo1"],
        minDiasPeriodo2: json["min_dias_periodo2"],
        anhoInicio: json["anho_inicio"],
        idEstadoPeriodoVac: json["id_estado_periodo_vac"],
    );

    Map<String, dynamic> toJson() => {
        "id_periodo_vac": idPeriodoVac,
        "nombre": nombre,
        "min_dias_periodo1": minDiasPeriodo1,
        "min_dias_periodo2": minDiasPeriodo2,
        "anho_inicio": anhoInicio,
        "id_estado_periodo_vac": idEstadoPeriodoVac,
    };
}
