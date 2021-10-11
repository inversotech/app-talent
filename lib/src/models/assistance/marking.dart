// To parse this JSON data, do
//
//     final markingModel = markingModelFromJson(jsonString);

import 'dart:convert';

MarkingModel markingModelFromJson(String str) => MarkingModel.fromJson(json.decode(str));

String markingModelToJson(MarkingModel data) => json.encode(data.toJson());

class MarkingModel {
    MarkingModel({
        this.idAsistencia,
        this.idTrabajador,
        this.fecha,
        this.idAnho,
        this.idMes,
        this.idDia,
        this.nroDia,
        this.horaBaseEnt,
        this.horaBaseSal,
        this.horaBaseEntRef,
        this.horaBaseSalRef,
        this.numHorasBase,
        this.numRefrigerio,
        this.horaEntrada,
        this.horaSalida,
        this.horaEntradaRef,
        this.horaSalidaRef,
        this.numHoras,
        this.numToleTar,
        this.numMinutosTarEnt,
        this.numToleTarRef,
        this.numMinutosTarRef,
        this.numMinutosTarSal,
        this.numMinutosTarSalRef,
        this.numMinutosTar,
        this.horaEntradaReal,
        this.horaSalidaReal,
        this.horaEntradaRefReal,
        this.horaSalidaRefReal,
        this.numHorasReal,
        this.idMapaPoligono,
        this.idSituacionEspecial,
        this.idTipoControlPersonal,
        this.idTipoTiempoTrabajo,
        this.idTipoHorario,
        this.idCondicionLaboral,
        this.idUserdevice,
        this.salDiasig,
        this.permHora,
        this.idMotivoAsist,
        this.apellidonombre,
        this.siglas,
        this.numDocumento,
        this.area,
        this.puesto,
        this.motivoAsist,
        this.tipoControlPersonal,
        this.tipoTiempoTrabajo,
        this.dia,
        this.horaEntJust,
        this.horaSalRefJust,
        this.horaEntRefJust,
        this.horaSalJust,
    });

    String? idAsistencia;
    String? idTrabajador;
    DateTime? fecha;
    String? idAnho;
    String? idMes;
    String? idDia;
    String? nroDia;
    String? horaBaseEnt;
    String? horaBaseSal;
    String? horaBaseEntRef;
    String? horaBaseSalRef;
    String? numHorasBase;
    String? numRefrigerio;
    String? horaEntrada;
    String? horaSalida;
    String? horaEntradaRef;
    String? horaSalidaRef;
    String? numHoras;
    String? numToleTar;
    String? numMinutosTarEnt;
    String? numToleTarRef;
    String? numMinutosTarRef;
    String? numMinutosTarSal;
    String? numMinutosTarSalRef;
    String? numMinutosTar;
    String? horaEntradaReal;
    String? horaSalidaReal;
    String? horaEntradaRefReal;
    String? horaSalidaRefReal;
    String? numHorasReal;
    String? idMapaPoligono;
    String? idSituacionEspecial;
    String? idTipoControlPersonal;
    String? idTipoTiempoTrabajo;
    String? idTipoHorario;
    String? idCondicionLaboral;
    String? idUserdevice;
    String? salDiasig;
    String? permHora;
    String? idMotivoAsist;
    String? apellidonombre;
    String? siglas;
    String? numDocumento;
    String? area;
    String? puesto;
    String? motivoAsist;
    String? tipoControlPersonal;
    String? tipoTiempoTrabajo;
    String? dia;
    String? horaEntJust;
    String? horaSalRefJust;
    String? horaEntRefJust;
    String? horaSalJust;

    factory MarkingModel.fromJson(Map<String, dynamic> json) => MarkingModel(
        idAsistencia: json["id_asistencia"] == null ? null : json["id_asistencia"],
        idTrabajador: json["id_trabajador"] == null ? null : json["id_trabajador"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        idAnho: json["id_anho"] == null ? null : json["id_anho"],
        idMes: json["id_mes"] == null ? null : json["id_mes"],
        idDia: json["id_dia"] == null ? null : json["id_dia"],
        nroDia: json["nro_dia"] == null ? null : json["nro_dia"],
        horaBaseEnt: json["hora_base_ent"] == null ? null : json["hora_base_ent"],
        horaBaseSal: json["hora_base_sal"] == null ? null : json["hora_base_sal"],
        horaBaseEntRef: json["hora_base_ent_ref"] == null ? null : json["hora_base_ent_ref"],
        horaBaseSalRef: json["hora_base_sal_ref"] == null ? null : json["hora_base_sal_ref"],
        numHorasBase: json["num_horas_base"] == null ? '0' : json["num_horas_base"],
        numRefrigerio: json["num_refrigerio"] == null ? '0' : json["num_refrigerio"],
        horaEntrada: json["hora_entrada"] == null ? null : json["hora_entrada"],
        horaSalida: json["hora_salida"] == null ? null : json["hora_salida"],
        horaEntradaRef: json["hora_entrada_ref"] == null ? null : json["hora_entrada_ref"],
        horaSalidaRef: json["hora_salida_ref"] == null ? null : json["hora_salida_ref"],
        numHoras: json["num_horas"] == null ? '0' : json["num_horas"],
        numToleTar: json["num_tole_tar"] == null ? '0' : json["num_tole_tar"],
        numMinutosTarEnt: json["num_minutos_tar_ent"] == null ? '0' : json["num_minutos_tar_ent"],
        numToleTarRef: json["num_tole_tar_ref"] == null ? '0' : json["num_tole_tar_ref"],
        numMinutosTarRef: json["num_minutos_tar_ref"] == null ? '0' : json["num_minutos_tar_ref"],
        numMinutosTarSal: json["num_minutos_tar_sal"] == null ? '0' : json["num_minutos_tar_sal"],
        numMinutosTarSalRef: json["num_minutos_tar_sal_ref"] == null ? '0' : json["num_minutos_tar_sal_ref"],
        numMinutosTar: json["num_minutos_tar"] == null ? '0' : json["num_minutos_tar"],
        horaEntradaReal: json["hora_entrada_real"] == null ? null : json["hora_entrada_real"],
        horaSalidaReal: json["hora_salida_real"] == null ? null : json["hora_salida_real"],
        horaEntradaRefReal: json["hora_entrada_ref_real"] == null ? null : json["hora_entrada_ref_real"],
        horaSalidaRefReal: json["hora_salida_ref_real"] == null ? null : json["hora_salida_ref_real"],
        numHorasReal: json["num_horas_real"] == null ? '0' : json["num_horas_real"],
        idMapaPoligono: json["id_mapa_poligono"],
        idSituacionEspecial: json["id_situacion_especial"] == null ? null : json["id_situacion_especial"],
        idTipoControlPersonal: json["id_tipo_control_personal"] == null ? null : json["id_tipo_control_personal"],
        idTipoTiempoTrabajo: json["id_tipo_tiempo_trabajo"] == null ? null : json["id_tipo_tiempo_trabajo"],
        idTipoHorario: json["id_tipo_horario"] == null ? null : json["id_tipo_horario"],
        idCondicionLaboral: json["id_condicion_laboral"] == null ? null : json["id_condicion_laboral"],
        idUserdevice: json["id_userdevice"] == null ? null : json["id_userdevice"],
        salDiasig: json["sal_diasig"] == null ? null : json["sal_diasig"],
        permHora: json["perm_hora"],
        idMotivoAsist: json["id_motivo_asist"] == null ? null : json["id_motivo_asist"],
        apellidonombre: json["apellidonombre"] == null ? null : json["apellidonombre"],
        siglas: json["siglas"] == null ? null : json["siglas"],
        numDocumento: json["num_documento"] == null ? null : json["num_documento"],
        area: json["area"] == null ? null : json["area"],
        puesto: json["puesto"] == null ? null : json["puesto"],
        motivoAsist: json["motivo_asist"] == null ? null : json["motivo_asist"],
        tipoControlPersonal: json["tipo_control_personal"] == null ? null : json["tipo_control_personal"],
        tipoTiempoTrabajo: json["tipo_tiempo_trabajo"] == null ? null : json["tipo_tiempo_trabajo"],
        dia: json["dia"] == null ? null : json["dia"],
        horaEntJust: json["hora_ent_just"] == null ? '0' : json["hora_ent_just"],
        horaSalRefJust: json["hora_sal_ref_just"] == null ? '0' : json["hora_sal_ref_just"],
        horaEntRefJust: json["hora_ent_ref_just"] == null ? '0' : json["hora_ent_ref_just"],
        horaSalJust: json["hora_sal_just"] == null ? '0' : json["hora_sal_just"],
    );

    Map<String, dynamic> toJson() => {
        "id_asistencia": idAsistencia == null ? null : idAsistencia,
        "id_trabajador": idTrabajador == null ? null : idTrabajador,
        "fecha": fecha == null ? null : fecha!.toIso8601String(),
        "id_anho": idAnho == null ? null : idAnho,
        "id_mes": idMes == null ? null : idMes,
        "id_dia": idDia == null ? null : idDia,
        "nro_dia": nroDia == null ? null : nroDia,
        "hora_base_ent": horaBaseEnt == null ? null : horaBaseEnt,
        "hora_base_sal": horaBaseSal == null ? null : horaBaseSal,
        "hora_base_ent_ref": horaBaseEntRef == null ? null : horaBaseEntRef,
        "hora_base_sal_ref": horaBaseSalRef == null ? null : horaBaseSalRef,
        "num_horas_base": numHorasBase == null ? '0' : numHorasBase,
        "num_refrigerio": numRefrigerio == null ? '0' : numRefrigerio,
        "hora_entrada": horaEntrada == null ? null : horaEntrada,
        "hora_salida": horaSalida == null ? null : horaSalida,
        "hora_entrada_ref": horaEntradaRef == null ? null : horaEntradaRef,
        "hora_salida_ref": horaSalidaRef == null ? null : horaSalidaRef,
        "num_horas": numHoras == null ? '0' : numHoras,
        "num_tole_tar": numToleTar == null ? '0' : numToleTar,
        "num_minutos_tar_ent": numMinutosTarEnt == null ? '0' : numMinutosTarEnt,
        "num_tole_tar_ref": numToleTarRef == null ? null : numToleTarRef,
        "num_minutos_tar_ref": numMinutosTarRef == null ? '0' : numMinutosTarRef,
        "num_minutos_tar_sal": numMinutosTarSal == null ? '0' : numMinutosTarSal,
        "num_minutos_tar_sal_ref": numMinutosTarSalRef == null ? '0' : numMinutosTarSalRef,
        "num_minutos_tar": numMinutosTar == null ? null : numMinutosTar,
        "hora_entrada_real": horaEntradaReal == null ? null : horaEntradaReal,
        "hora_salida_real": horaSalidaReal == null ? null : horaSalidaReal,
        "hora_entrada_ref_real": horaEntradaRefReal == null ? null : horaEntradaRefReal,
        "hora_salida_ref_real": horaSalidaRefReal == null ? null : horaSalidaRefReal,
        "num_horas_real": numHorasReal == null ? '0' : numHorasReal,
        "id_mapa_poligono": idMapaPoligono,
        "id_situacion_especial": idSituacionEspecial == null ? null : idSituacionEspecial,
        "id_tipo_control_personal": idTipoControlPersonal == null ? null : idTipoControlPersonal,
        "id_tipo_tiempo_trabajo": idTipoTiempoTrabajo == null ? null : idTipoTiempoTrabajo,
        "id_tipo_horario": idTipoHorario == null ? null : idTipoHorario,
        "id_condicion_laboral": idCondicionLaboral == null ? null : idCondicionLaboral,
        "id_userdevice": idUserdevice == null ? null : idUserdevice,
        "sal_diasig": salDiasig == null ? null : salDiasig,
        "perm_hora": permHora,
        "id_motivo_asist": idMotivoAsist == null ? null : idMotivoAsist,
        "apellidonombre": apellidonombre == null ? null : apellidonombre,
        "siglas": siglas == null ? null : siglas,
        "num_documento": numDocumento == null ? null : numDocumento,
        "area": area == null ? null : area,
        "puesto": puesto == null ? null : puesto,
        "motivo_asist": motivoAsist == null ? null : motivoAsist,
        "tipo_control_personal": tipoControlPersonal == null ? null : tipoControlPersonal,
        "tipo_tiempo_trabajo": tipoTiempoTrabajo == null ? null : tipoTiempoTrabajo,
        "dia": dia == null ? null : dia,
        "hora_ent_just": horaEntJust == null ? '0' : horaEntJust,
        "hora_sal_ref_just": horaSalRefJust == null ? '0' : horaSalRefJust,
        "hora_ent_ref_just": horaEntRefJust == null ? '0 ': horaEntRefJust,
        "hora_sal_just": horaSalJust == null ? '0' : horaSalJust,
    };
}
