import 'dart:convert';

AssistanceSummaryModel assistanceSummaryModelFromJson(String str) =>
    AssistanceSummaryModel.fromJson(json.decode(str));

String assistanceSummaryModelToJson(AssistanceSummaryModel data) =>
    json.encode(data.toJson());

class AssistanceSummaryModel {
  AssistanceSummaryModel(
      {required this.nombre,
      required this.cantidad,
      required this.code});

  String nombre;
  int cantidad;
  String code;

  factory AssistanceSummaryModel.fromJson(Map<String, dynamic> json) =>
      AssistanceSummaryModel(
          nombre: json["nombre"],
          cantidad: int.parse((json["cantidad"] ?? 0).toString()),
          code: json["codigo"]);

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "cantidad": cantidad,
        "code": code
      };
}
