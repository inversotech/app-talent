import 'package:lamb_talent/resources/models/procesos/documento_gasto.dart';

class SolicitudPagoModel {
  int? id;
  String? descripcion;
  String? fecha;
  double? montoTotal;
  String? estado; // 'pendiente', 'aprobado', 'rechazado'
  List<DocumentoGastoModel>? documentos;

  SolicitudPagoModel({
    this.id,
    this.descripcion,
    this.fecha,
    this.montoTotal,
    this.estado,
    this.documentos,
  });

  factory SolicitudPagoModel.fromJson(Map<String, dynamic> json) =>
      SolicitudPagoModel(
        id: json['id'],
        descripcion: json['descripcion'],
        fecha: json['fecha'],
        montoTotal: json['monto_total'] != null
            ? double.parse(json['monto_total'].toString())
            : null,
        estado: json['estado'],
        documentos: json['documentos'] != null
            ? (json['documentos'] as List)
                .map((e) => DocumentoGastoModel.fromJson(e))
                .toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'descripcion': descripcion,
        'fecha': fecha,
        'monto_total': montoTotal,
        'estado': estado,
        'documentos': documentos?.map((e) => e.toJson()).toList() ?? [],
      };
}
