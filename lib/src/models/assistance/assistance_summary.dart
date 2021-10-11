import 'dart:convert';

AssistanceSummaryModel assistanceSummaryModelFromJson(String str) =>
    AssistanceSummaryModel.fromJson(json.decode(str));

String assistanceSummaryModelToJson(AssistanceSummaryModel data) =>
    json.encode(data.toJson());

class AssistanceSummaryModel {
  AssistanceSummaryModel(
      {required this.nombre,
      required this.cantidad,
      this.otraCantidad,
      required this.code});

  String nombre;
  int cantidad;
  int? otraCantidad;
  String code;

  factory AssistanceSummaryModel.fromJson(Map<String, dynamic> json) =>
      AssistanceSummaryModel(
          nombre: json["nombre"],
          cantidad: int.parse(json["cantidad"]),
          otraCantidad: json["otra_cantidad"] != null
              ? int.parse(json["otra_cantidad"])
              : null,
          code: json["codigo"]);

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "cantidad": cantidad,
        "otra_cantidad": otraCantidad,
        "code": code
      };
}
