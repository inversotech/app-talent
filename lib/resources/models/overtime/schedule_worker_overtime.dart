// To parse this JSON data, do
//
//     final scheduleWorkerOvertimeModel = scheduleWorkerOvertimeModelFromJson(jsonString);

import 'dart:convert';

ScheduleWorkerOvertimeModel scheduleWorkerOvertimeModelFromJson(String str) =>
    ScheduleWorkerOvertimeModel.fromJson(json.decode(str));

String scheduleWorkerOvertimeModelToJson(ScheduleWorkerOvertimeModel data) =>
    json.encode(data.toJson());

class ScheduleWorkerOvertimeModel {
  ScheduleWorkerOvertimeModel({
    this.horaEntrada,
    this.horaSalida,
    this.horaEntradaRef,
    this.horaSalidaRef,
    this.salDiasig,
    this.horas,
    this.numHoras,
    this.tipoHora,
    this.idTipoHorario,
    this.idEntidad,
    this.idDeptoPadre,
    this.nroDia,
    this.idTipoControlPersonal,
    this.idTipoTiempoTrabajo,
    this.idSedearea,
    this.tipoTiempoTrabajo,
    this.tipoControlPersonal,
    this.marcacion,
    this.controlAsist,
    this.salidaSig,
    this.tieneHorario,
    this.maxHoraExt,
  });

  String? horaEntrada;
  String? horaSalida;
  String? horaEntradaRef;
  String? horaSalidaRef;
  String? salDiasig;
  String? horas;
  String? numHoras;
  String? tipoHora;
  String? idTipoHorario;
  String? idEntidad;
  String? idDeptoPadre;
  String? nroDia;
  String? idTipoControlPersonal;
  String? idTipoTiempoTrabajo;
  String? idSedearea;
  String? tipoTiempoTrabajo;
  String? tipoControlPersonal;
  String? marcacion;
  String? controlAsist;
  String? salidaSig;
  String? tieneHorario;
  String? maxHoraExt;

  factory ScheduleWorkerOvertimeModel.fromJson(Map<String, dynamic> json) =>
      ScheduleWorkerOvertimeModel(
        horaEntrada: json["hora_entrada"],
        horaSalida: json["hora_salida"],
        horaEntradaRef: json["hora_entrada_ref"],
        horaSalidaRef: json["hora_salida_ref"],
        salDiasig: json["sal_diasig"],
        horas: json["horas"],
        numHoras: json["num_horas"],
        tipoHora: json["tipo_hora"],
        idTipoHorario: json["id_tipo_horario"],
        idEntidad: json["id_entidad"],
        idDeptoPadre: json["id_depto_padre"],
        nroDia: json["nro_dia"],
        idTipoControlPersonal: json["id_tipo_control_personal"],
        idTipoTiempoTrabajo: json["id_tipo_tiempo_trabajo"],
        idSedearea: json["id_sedearea"],
        tipoTiempoTrabajo: json["tipo_tiempo_trabajo"],
        tipoControlPersonal: json["tipo_control_personal"],
        marcacion: json["marcacion"],
        controlAsist: json["control_asist"],
        salidaSig: json["salida_sig"],
        tieneHorario: json["tiene_horario"],
        maxHoraExt: json["max_hora_ext"],
      );

  Map<String, dynamic> toJson() => {
        "hora_entrada": horaEntrada,
        "hora_salida": horaSalida,
        "hora_entrada_ref": horaEntradaRef,
        "hora_salida_ref": horaSalidaRef,
        "sal_diasig": salDiasig,
        "horas": horas,
        "num_horas": numHoras,
        "tipo_hora": tipoHora,
        "id_tipo_horario": idTipoHorario,
        "id_entidad": idEntidad,
        "id_depto_padre": idDeptoPadre,
        "nro_dia": nroDia,
        "id_tipo_control_personal": idTipoControlPersonal,
        "id_tipo_tiempo_trabajo": idTipoTiempoTrabajo,
        "id_sedearea": idSedearea,
        "tipo_tiempo_trabajo": tipoTiempoTrabajo,
        "tipo_control_personal": tipoControlPersonal,
        "marcacion": marcacion,
        "control_asist": controlAsist,
        "salida_sig": salidaSig,
        "tiene_horario": tieneHorario,
        "max_hora_ext": maxHoraExt,
      };
}
