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
        this.horaBaseEnt,
        this.horaBaseSal,
        this.horaBaseEntRef,
        this.horaBaseSalRef,
        this.numHorasBase,
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
        this.idTipoHorario,
        this.idUserdevice,
        this.horaEntJust,
        this.horaSalRefJust,
        this.horaEntRefJust,
        this.horaSalJust,
    });

    String? idAsistencia;
    String? idTrabajador;
    DateTime? fecha;
    String? horaBaseEnt;
    String? horaBaseSal;
    String? horaBaseEntRef;
    String? horaBaseSalRef;
    String? numHorasBase;
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
    String? idTipoHorario;
    String? idUserdevice;
    String? horaEntJust;
    String? horaSalRefJust;
    String? horaEntRefJust;
    String? horaSalJust;

    factory MarkingModel.fromJson(Map<String, dynamic> json) => MarkingModel(
        idAsistencia: json["id_asistencia"] == null ? null : json["id_asistencia"],
        idTrabajador: json["id_trabajador"] == null ? null : json["id_trabajador"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        horaBaseEnt: json["hora_base_ent"] == null ? null : json["hora_base_ent"],
        horaBaseSal: json["hora_base_sal"] == null ? null : json["hora_base_sal"],
        horaBaseEntRef: json["hora_base_ent_ref"] == null ? null : json["hora_base_ent_ref"],
        horaBaseSalRef: json["hora_base_sal_ref"] == null ? null : json["hora_base_sal_ref"],
        numHorasBase: json["num_horas_base"] == null ? '0' : json["num_horas_base"],
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
        idTipoHorario: json["id_tipo_horario"] == null ? null : json["id_tipo_horario"],
        idUserdevice: json["id_userdevice"] == null ? null : json["id_userdevice"],
        horaEntJust: json["hora_ent_just"] == null ? '0' : json["hora_ent_just"],
        horaSalRefJust: json["hora_sal_ref_just"] == null ? '0' : json["hora_sal_ref_just"],
        horaEntRefJust: json["hora_ent_ref_just"] == null ? '0' : json["hora_ent_ref_just"],
        horaSalJust: json["hora_sal_just"] == null ? '0' : json["hora_sal_just"],
    );

    Map<String, dynamic> toJson() => {
        "id_asistencia": idAsistencia == null ? null : idAsistencia,
        "id_trabajador": idTrabajador == null ? null : idTrabajador,
        "fecha": fecha == null ? null : fecha!.toIso8601String(),
        "hora_base_ent": horaBaseEnt == null ? null : horaBaseEnt,
        "hora_base_sal": horaBaseSal == null ? null : horaBaseSal,
        "hora_base_ent_ref": horaBaseEntRef == null ? null : horaBaseEntRef,
        "hora_base_sal_ref": horaBaseSalRef == null ? null : horaBaseSalRef,
        "num_horas_base": numHorasBase == null ? '0' : numHorasBase,
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
        "id_tipo_horario": idTipoHorario == null ? null : idTipoHorario,
        "id_userdevice": idUserdevice == null ? null : idUserdevice,
        "hora_ent_just": horaEntJust == null ? '0' : horaEntJust,
        "hora_sal_ref_just": horaSalRefJust == null ? '0' : horaSalRefJust,
        "hora_ent_ref_just": horaEntRefJust == null ? '0 ': horaEntRefJust,
        "hora_sal_just": horaSalJust == null ? '0' : horaSalJust,
    };
}
