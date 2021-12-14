import 'dart:convert';

YearModel yearModelFromJson(String str) => YearModel.fromJson(json.decode(str));

String yearModelToJson(YearModel data) => json.encode(data.toJson());

class YearModel {
  YearModel({
    required this.idAnho,
  });

  int idAnho;

  factory YearModel.fromJson(Map<String, dynamic> json) => YearModel(
        idAnho: int.parse(json["id_anho"]),
      );

  Map<String, dynamic> toJson() => {
        "id_anho": idAnho,
      };
}
