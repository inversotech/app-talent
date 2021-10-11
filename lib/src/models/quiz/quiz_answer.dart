// To parse this JSON data, do
//
//     final surveyItem = surveyItemFromJson(jsonString);

import 'dart:convert';

SurveyAnswer surveyAnswerFromJson(String str) =>
    SurveyAnswer.fromJson(json.decode(str));

String surveyAnswerToJson(SurveyAnswer data) => json.encode(data.toJson());

class SurveyAnswer {
  SurveyAnswer({this.idAlternativa, this.idPregunta, this.respuesta, this.tipo});

  String? idAlternativa;
  String? idPregunta;
  String? respuesta;
  String? tipo;

  factory SurveyAnswer.fromJson(Map<String, dynamic> json) => SurveyAnswer(
      idAlternativa:
          json["id_alternativa"] == null ? null : json["id_alternativa"],
      idPregunta: json["id_pregunta"] == null ? null : json["id_pregunta"],
      respuesta: json["respuesta"] == null ? null : json["respuesta"],
      tipo: json["tipo"] == null ? null : json["tipo"]);

  Map<String, dynamic> toJson() => {
        "id_alternativa": idAlternativa == null ? null : idAlternativa,
        "id_pregunta": idPregunta == null ? null : idPregunta,
        "respuesta": respuesta == null ? null : respuesta,
        "tipo": respuesta == null ? null : tipo
      };
}
