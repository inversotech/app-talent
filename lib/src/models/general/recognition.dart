// To parse this JSON data, do
//
//     final recognitionModel = recognitionModelFromJson(jsonString);

import 'dart:convert';

RecognitionModel recognitionModelFromJson(String str) =>
    RecognitionModel.fromJson(json.decode(str));

String recognitionModelToJson(RecognitionModel data) =>
    json.encode(data.toJson());

class RecognitionModel {
  RecognitionModel({
    required this.confidence,
    required this.index,
    required this.label,
  });

  double confidence;
  int index;
  String label;

  factory RecognitionModel.fromJson(Map<String, dynamic> json) =>
      RecognitionModel(
        confidence:
            json["confidence"] == null ? 0 : json["confidence"].toDouble(),
        index: json["index"] == null ? 0 : int.parse(json["index"].toString()),
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "confidence": confidence,
        "index": index,
        "label": label,
      };
}
