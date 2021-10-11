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
        nombreDia: json["nombre_dia"] == null ? null : json["nombre_dia"],
        nombreModalidad: json["nombre_modalidad"] == null ? null : json["nombre_modalidad"],
        idTrabajador: json["id_trabajador"] == null ? null : json["id_trabajador"],
        idTipoHorario: json["id_tipo_horario"] == null ? null : json["id_tipo_horario"],
        nombreAsist: json["nombre_asist"] == null ? null : json["nombre_asist"],
        idHorarioMensualDet: json["id_horario_mensual_det"],
        codigo: json["codigo"],
        nombreCodigo: json["nombre_codigo"],
        fechahoraEntrada: json["fechahora_entrada"] == null ? null : json["fechahora_entrada"],
        fechahoraSalidaRef: json["fechahora_salida_ref"],
        fechahoraEntradaRef: json["fechahora_entrada_ref"],
        fechahoraSalida: json["fechahora_salida"] == null ? null : json["fechahora_salida"],
        horas: json["horas"] == null ? null : json["horas"],
        numHoras: json["num_horas"] == null ? null : json["num_horas"],
        salDiasig: json["sal_diasig"] == null ? null : json["sal_diasig"],
        idSituacionEspecial: json["id_situacion_especial"] == null ? null : json["id_situacion_especial"],
    );

    Map<String, dynamic> toJson() => {
        "nombre_dia": nombreDia == null ? null : nombreDia,
        "nombre_modalidad": nombreModalidad == null ? null : nombreModalidad,
        "id_trabajador": idTrabajador == null ? null : idTrabajador,
        "id_tipo_horario": idTipoHorario == null ? null : idTipoHorario,
        "nombre_asist": nombreAsist == null ? null : nombreAsist,
        "id_horario_mensual_det": idHorarioMensualDet,
        "codigo": codigo,
        "nombre_codigo": nombreCodigo,
        "fechahora_entrada": fechahoraEntrada == null ? null : fechahoraEntrada,
        "fechahora_salida_ref": fechahoraSalidaRef,
        "fechahora_entrada_ref": fechahoraEntradaRef,
        "fechahora_salida": fechahoraSalida == null ? null : fechahoraSalida,
        "horas": horas == null ? null : horas,
        "num_horas": numHoras == null ? null : numHoras,
        "sal_diasig": salDiasig == null ? null : salDiasig,
        "id_situacion_especial": idSituacionEspecial == null ? null : idSituacionEspecial,
    };
}
