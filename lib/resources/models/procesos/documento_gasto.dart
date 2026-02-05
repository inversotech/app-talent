class DocumentoGastoModel {
  int? id;
  String? nombre;
  String? tipo; // 'factura', 'boleta'
  double? monto;
  String? archivoUrl;

  DocumentoGastoModel({
    this.id,
    this.nombre,
    this.tipo,
    this.monto,
    this.archivoUrl,
  });

  factory DocumentoGastoModel.fromJson(Map<String, dynamic> json) =>
      DocumentoGastoModel(
        id: json['id'],
        nombre: json['nombre'],
        tipo: json['tipo'],
        monto: json['monto'] != null
            ? double.parse(json['monto'].toString())
            : null,
        archivoUrl: json['archivo_url'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'tipo': tipo,
        'monto': monto,
        'archivo_url': archivoUrl,
      };
}
