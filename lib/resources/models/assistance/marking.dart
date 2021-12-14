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
        idAsistencia: json["id_asistencia"],
        idTrabajador: json["id_trabajador"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        horaBaseEnt: json["hora_base_ent"],
        horaBaseSal: json["hora_base_sal"],
        horaBaseEntRef: json["hora_base_ent_ref"],
        horaBaseSalRef: json["hora_base_sal_ref"],
        numHorasBase: json["num_horas_base"] ?? '0',
        horaEntrada: json["hora_entrada"],
        horaSalida: json["hora_salida"],
        horaEntradaRef: json["hora_entrada_ref"],
        horaSalidaRef: json["hora_salida_ref"],
        numHoras: json["num_horas"] ?? '0',
        numToleTar: json["num_tole_tar"] ?? '0',
        numMinutosTarEnt: json["num_minutos_tar_ent"] ?? '0',
        numToleTarRef: json["num_tole_tar_ref"] ?? '0',
        numMinutosTarRef: json["num_minutos_tar_ref"] ?? '0',
        numMinutosTarSal: json["num_minutos_tar_sal"] ?? '0',
        numMinutosTarSalRef: json["num_minutos_tar_sal_ref"] ?? '0',
        numMinutosTar: json["num_minutos_tar"] ?? '0',
        horaEntradaReal: json["hora_entrada_real"],
        horaSalidaReal: json["hora_salida_real"],
        horaEntradaRefReal: json["hora_entrada_ref_real"],
        horaSalidaRefReal: json["hora_salida_ref_real"],
        idTipoHorario: json["id_tipo_horario"],
        idUserdevice: json["id_userdevice"],
        horaEntJust: json["hora_ent_just"] ?? '0',
        horaSalRefJust: json["hora_sal_ref_just"] ?? '0',
        horaEntRefJust: json["hora_ent_ref_just"] ?? '0',
        horaSalJust: json["hora_sal_just"] ?? '0',
    );

    Map<String, dynamic> toJson() => {
        "id_asistencia": idAsistencia,
        "id_trabajador": idTrabajador,
        "fecha": fecha == null ? null : fecha!.toIso8601String(),
        "hora_base_ent": horaBaseEnt,
        "hora_base_sal": horaBaseSal,
        "hora_base_ent_ref": horaBaseEntRef,
        "hora_base_sal_ref": horaBaseSalRef,
        "num_horas_base": numHorasBase ?? '0',
        "hora_entrada": horaEntrada,
        "hora_salida": horaSalida,
        "hora_entrada_ref": horaEntradaRef,
        "hora_salida_ref": horaSalidaRef,
        "num_horas": numHoras ?? '0',
        "num_tole_tar": numToleTar ?? '0',
        "num_minutos_tar_ent": numMinutosTarEnt ?? '0',
        "num_tole_tar_ref": numToleTarRef,
        "num_minutos_tar_ref": numMinutosTarRef ?? '0',
        "num_minutos_tar_sal": numMinutosTarSal ?? '0',
        "num_minutos_tar_sal_ref": numMinutosTarSalRef ?? '0',
        "num_minutos_tar": numMinutosTar,
        "hora_entrada_real": horaEntradaReal,
        "hora_salida_real": horaSalidaReal,
        "hora_entrada_ref_real": horaEntradaRefReal,
        "hora_salida_ref_real": horaSalidaRefReal,
        "id_tipo_horario": idTipoHorario,
        "id_userdevice": idUserdevice,
        "hora_ent_just": horaEntJust ?? '0',
        "hora_sal_ref_just": horaSalRefJust ?? '0',
        "hora_ent_ref_just": horaEntRefJust ?? '0 ',
        "hora_sal_just": horaSalJust ?? '0',
    };
}
