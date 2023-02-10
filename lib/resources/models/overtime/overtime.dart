// To parse this JSON data, do
//
//     final overtimeModel = overtimeModelFromJson(jsonString);

import 'dart:convert';

OvertimeModel overtimeModelFromJson(String str) =>
    OvertimeModel.fromJson(json.decode(str));

String overtimeModelToJson(OvertimeModel data) => json.encode(data.toJson());

class OvertimeModel {
  OvertimeModel({
    this.idSobretiempo,
    this.idEntidad,
    this.idDepto,
    this.idTrabajador,
    this.tipoSobretiempo,
    this.codigoSobretiempo,
    this.fecha,
    this.horaDesde,
    this.horaHasta,
    this.motivo,
    this.numHoras,
    this.horas,
    this.horaDesdeReal,
    this.horaHastaReal,
    this.numHorasReal,
    this.compensado,
    this.fechaCompensar,
    this.comentarioCompensar,
    this.idEstadoSobretiempo,
    this.estadoSobretiempo,
    this.documentoUrl,
    this.periodo,
    this.nombre,
    this.paterno,
    this.materno,
    this.numDocumento,
    this.apellidonombre,
    this.nombreapellido,
    this.estadoNombre,
    this.codigoPeriodo,
    this.maxHoraExt,
    this.idTipoSobretiempo,
  });
  String? estadoNombre;
  String? idSobretiempo;
  String? idEntidad;
  String? idDepto;
  String? idTrabajador;
  String? tipoSobretiempo;
  String? codigoSobretiempo;
  String? fecha;
  String? horaDesde;
  String? horaHasta;
  String? motivo;
  String? numHoras;
  String? horas;
  dynamic horaDesdeReal;
  dynamic horaHastaReal;
  dynamic numHorasReal;
  dynamic compensado;
  dynamic fechaCompensar;
  dynamic comentarioCompensar;
  String? idEstadoSobretiempo;
  String? estadoSobretiempo;
  dynamic documentoUrl;
  String? periodo;
  String? nombre;
  String? codigoPeriodo;
  String? idTipoSobretiempo;
  String? paterno;
  String? materno;
  String? numDocumento;
  String? apellidonombre;
  String? nombreapellido;
  String? maxHoraExt;
  factory OvertimeModel.fromJson(Map<String, dynamic> json) => OvertimeModel(
        idSobretiempo: json["id_sobretiempo"] ?? '',
        idEntidad: json["id_entidad"] ?? '',
        idDepto: json["id_depto"] ?? '',
        idTrabajador: json["id_trabajador"] ?? '',
        tipoSobretiempo: json["tipo_sobretiempo"] ?? '',
        codigoSobretiempo: json["codigo_sobretiempo"] ?? '',
        fecha: json["fecha"] ?? '',
        estadoNombre: json["estado_nombre"] ?? "",
        horaDesde: json["hora_desde"] ?? '',
        horaHasta: json["hora_hasta"] ?? '',
        motivo: json["motivo"] ?? '',
        numHoras: json["num_horas"] ?? '0',
        horas: json["horas"] ?? '00:00',
        horaDesdeReal: json["hora_desde_real"] ?? '',
        horaHastaReal: json["hora_hasta_real"] ?? '',
        numHorasReal: json["num_horas_real"] ?? '',
        compensado: json["compensado"] ?? '',
        fechaCompensar: json["fecha_compensar"] ?? '',
        comentarioCompensar: json["comentario_compensar"] ?? '',
        idEstadoSobretiempo: json["id_estado_sobretiempo"] ?? '',
        estadoSobretiempo: json["estado_sobretiempo"] ?? '',
        documentoUrl: json["documento_url"] ?? '',
        periodo: json["periodo"] ?? '',
        nombre: json["nombre"] ?? '',
        paterno: json["paterno"] ?? '',
        materno: json["materno"] ?? '',
        codigoPeriodo: json["codigo_periodo"] ?? "",
        numDocumento: json["num_documento"] ?? '',
        apellidonombre: json["apellidonombre"] ?? '',
        nombreapellido: json["nombreapellido"] ?? '',
        idTipoSobretiempo: json["id_tipo_sobretiempo"] ?? '',
        maxHoraExt: json["max_hora_ext"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id_sobretiempo": idSobretiempo,
        "id_entidad": idEntidad,
        "id_depto": idDepto,
        "id_trabajador": idTrabajador,
        "tipo_sobretiempo": tipoSobretiempo,
        "codigo_sobretiempo": codigoSobretiempo,
        "fecha": fecha,
        "estado_nombre": estadoNombre,
        "hora_desde": horaDesde,
        "hora_hasta": horaHasta,
        "motivo": motivo,
        "num_horas": numHoras,
        "horas": horas,
        "hora_desde_real": horaDesdeReal,
        "hora_hasta_real": horaHastaReal,
        "num_horas_real": numHorasReal,
        "compensado": compensado,
        "fecha_compensar": fechaCompensar,
        "comentario_compensar": comentarioCompensar,
        "id_estado_sobretiempo": idEstadoSobretiempo,
        "estado_sobretiempo": estadoSobretiempo,
        "documento_url": documentoUrl,
        "codigo_periodo": codigoPeriodo,
        "periodo": periodo,
        "nombre": nombre,
        "paterno": paterno,
        "materno": materno,
        "num_documento": numDocumento,
        "apellidonombre": apellidonombre,
        "nombreapellido": nombreapellido,
        "id_tipo_sobretiempo": idTipoSobretiempo,
        "max_hora_ext": maxHoraExt,
      };
}
