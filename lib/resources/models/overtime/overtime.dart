// To parse this JSON data, do
//
//     final overtimeModel = overtimeModelFromJson(jsonString);

import 'dart:convert';

OvertimeModel overtimeModelFromJson(String str) =>
    OvertimeModel.fromJson(json.decode(str));

String overtimeModelToJson(OvertimeModel data) => json.encode(data.toJson());

class OvertimeModel {
  OvertimeModel({
    this.rn,
    this.idSobretiempo,
    this.idTrabajador,
    this.idEntidad,
    this.idDepto,
    this.fecha,
    this.motivo,
    this.comentario,
    this.horaDesde,
    this.horaHasta,
    this.compensado,
    this.fechaCompensar,
    this.comentarioCompensar,
    this.idEstadoSobretiempo,
    this.documentoUrl,
    this.paterno,
    this.materno,
    this.nombre,
    this.apellidonombre,
    this.numDocumento,
    this.estadoNombre,
    this.tipoSobretiempo,
    this.codigoSobretiempo,
    this.departamento,
    this.compensadoValor,
    this.periodo,
    this.codigoPeriodo,
    this.area,
    this.horas,
    this.horaDesdeReal,
    this.horaHastaReal,
    this.numHorasReal,
  });

  String? rn;
  String? idSobretiempo;
  String? idTrabajador;
  String? idEntidad;
  String? idDepto;
  DateTime? fecha;
  String? motivo;
  dynamic comentario;
  String? horaDesde;
  String? horaHasta;
  dynamic compensado;
  dynamic fechaCompensar;
  dynamic comentarioCompensar;
  String? idEstadoSobretiempo;
  String? documentoUrl;
  String? paterno;
  String? materno;
  String? nombre;
  String? apellidonombre;
  String? numDocumento;
  String? estadoNombre;
  String? tipoSobretiempo;
  String? codigoSobretiempo;
  String? departamento;
  dynamic compensadoValor;
  String? periodo;
  String? codigoPeriodo;
  String? area;
  String? horas;
  dynamic horaDesdeReal;
  dynamic horaHastaReal;
  dynamic numHorasReal;

  factory OvertimeModel.fromJson(Map<String, dynamic> json) => OvertimeModel(
        rn: json["rn"],
        idSobretiempo: json["id_sobretiempo"],
        idTrabajador: json["id_trabajador"],
        idEntidad: json["id_entidad"],
        idDepto: json["id_depto"],
        fecha: DateTime.parse(json["fecha"]),
        motivo: json["motivo"],
        comentario: json["comentario"],
        horaDesde: json["hora_desde"],
        horaHasta: json["hora_hasta"],
        compensado: json["compensado"],
        fechaCompensar: json["fecha_compensar"],
        comentarioCompensar: json["comentario_compensar"],
        idEstadoSobretiempo: json["id_estado_sobretiempo"],
        documentoUrl: json["documento_url"],
        paterno: json["paterno"],
        materno: json["materno"],
        nombre: json["nombre"],
        apellidonombre: json["apellidonombre"],
        numDocumento: json["num_documento"],
        estadoNombre: json["estado_nombre"],
        tipoSobretiempo: json["tipo_sobretiempo"],
        codigoSobretiempo: json["codigo_sobretiempo"],
        departamento: json["departamento"],
        compensadoValor: json["compensado_valor"],
        periodo: json["periodo"],
        codigoPeriodo: json["codigo_periodo"],
        area: json["area"],
        horas: json["horas"],
        horaDesdeReal: json["hora_desde_real"],
        horaHastaReal: json["hora_hasta_real"],
        numHorasReal: json["num_horas_real"],
      );

  Map<String, dynamic> toJson() => {
        "rn": rn,
        "id_sobretiempo": idSobretiempo,
        "id_trabajador": idTrabajador,
        "id_entidad": idEntidad,
        "id_depto": idDepto,
        "fecha": fecha,
        "motivo": motivo,
        "comentario": comentario,
        "hora_desde": horaDesde,
        "hora_hasta": horaHasta,
        "compensado": compensado,
        "fecha_compensar": fechaCompensar,
        "comentario_compensar": comentarioCompensar,
        "id_estado_sobretiempo": idEstadoSobretiempo,
        "documento_url": documentoUrl,
        "paterno": paterno,
        "materno": materno,
        "nombre": nombre,
        "apellidonombre": apellidonombre,
        "num_documento": numDocumento,
        "estado_nombre": estadoNombre,
        "tipo_sobretiempo": tipoSobretiempo,
        "codigo_sobretiempo": codigoSobretiempo,
        "departamento": departamento,
        "compensado_valor": compensadoValor,
        "periodo": periodo,
        "codigo_periodo": codigoPeriodo,
        "area": area,
        "horas": horas,
        "hora_desde_real": horaDesdeReal,
        "hora_hasta_real": horaHastaReal,
        "num_horas_real": numHorasReal,
      };
}
