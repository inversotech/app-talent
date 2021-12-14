// To parse this JSON data, do
//
//     final scheduleWorkerModel = scheduleWorkerModelFromJson(jsonString);

import 'dart:convert';

ScheduleWorkerModel scheduleWorkerModelFromJson(String str) => ScheduleWorkerModel.fromJson(json.decode(str));

String scheduleWorkerModelToJson(ScheduleWorkerModel data) => json.encode(data.toJson());

class ScheduleWorkerModel {
    ScheduleWorkerModel({
        this.nombreDia,
        this.nombreModalidad,
        this.idTrabajador,
        this.idTipoHorario,
        this.nombreAsist,
        this.idHorarioMensualDet,
        this.codigo,
        this.nombreCodigo,
        this.fechahoraEntrada,
        this.fechahoraSalidaRef,
        this.fechahoraEntradaRef,
        this.fechahoraSalida,
        this.horas,
        this.numHoras,
        this.salDiasig,
        this.idSituacionEspecial,
    });

    String? nombreDia;
    String? nombreModalidad;
    String? idTrabajador;
    String? idTipoHorario;
    String? nombreAsist;
    String? idHorarioMensualDet;
    String? codigo;
    String? nombreCodigo;
    String? fechahoraEntrada;
    String? fechahoraSalidaRef;
    String? fechahoraEntradaRef;
    String? fechahoraSalida;
    String? horas;
    String? numHoras;
    String? salDiasig;
    String? idSituacionEspecial;

    factory ScheduleWorkerModel.fromJson(Map<String, dynamic> json) => ScheduleWorkerModel(
        nombreDia: json["nombre_dia"],
        nombreModalidad: json["nombre_modalidad"],
        idTrabajador: json["id_trabajador"],
        idTipoHorario: json["id_tipo_horario"],
        nombreAsist: json["nombre_asist"],
        idHorarioMensualDet: json["id_horario_mensual_det"],
        codigo: json["codigo"],
        nombreCodigo: json["nombre_codigo"],
        fechahoraEntrada: json["fechahora_entrada"],
        fechahoraSalidaRef: json["fechahora_salida_ref"],
        fechahoraEntradaRef: json["fechahora_entrada_ref"],
        fechahoraSalida: json["fechahora_salida"],
        horas: json["horas"],
        numHoras: json["num_horas"],
        salDiasig: json["sal_diasig"],
        idSituacionEspecial: json["id_situacion_especial"],
    );

    Map<String, dynamic> toJson() => {
        "nombre_dia": nombreDia,
        "nombre_modalidad": nombreModalidad,
        "id_trabajador": idTrabajador,
        "id_tipo_horario": idTipoHorario,
        "nombre_asist": nombreAsist,
        "id_horario_mensual_det": idHorarioMensualDet,
        "codigo": codigo,
        "nombre_codigo": nombreCodigo,
        "fechahora_entrada": fechahoraEntrada,
        "fechahora_salida_ref": fechahoraSalidaRef,
        "fechahora_entrada_ref": fechahoraEntradaRef,
        "fechahora_salida": fechahoraSalida,
        "horas": horas,
        "num_horas": numHoras,
        "sal_diasig": salDiasig,
        "id_situacion_especial": idSituacionEspecial,
    };
}
