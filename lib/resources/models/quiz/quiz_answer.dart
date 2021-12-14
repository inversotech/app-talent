// To parse this JSON data, do
//
//     final surveyItem = surveyItemFromJson(jsonString);

import 'dart:convert';

SurveyAnswer surveyAnswerFromJson(String str) =>
    SurveyAnswer.fromJson(json.decode(str));

String surveyAnswerToJson(SurveyAnswer data) => json.encode(data.toJson());

class SurveyAnswer {
  SurveyAnswer({this.idAlternativa, this.idPregunta, this.respuesta, this.tipo,this.tipoPreguntaCodigo});

  String? idAlternativa;
  String? idPregunta;
  String? respuesta;
  String? tipo;
  String? tipoPreguntaCodigo;

  factory SurveyAnswer.fromJson(Map<String, dynamic> json) => SurveyAnswer(
      idAlternativa:
          json["id_alternativa"],
      idPregunta: json["id_pregunta"],
      respuesta: json["respuesta"],
      tipo: json["tipo"],
      tipoPreguntaCodigo: json["tipo_pregunta_codigo"]);

  Map<String, dynamic> toJson() => {
        "id_alternativa": idAlternativa,
        "id_pregunta": idPregunta,
        "respuesta": respuesta,
        "tipo": tipo,
        "tipo_pregunta_codigo": tipoPreguntaCodigo
      };
}
