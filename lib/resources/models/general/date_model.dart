// To parse this JSON data, do
//
//     final dateModel = dateModelFromJson(jsonString);

import 'dart:convert';

DateModel dateModelFromJson(String str) => DateModel.fromJson(json.decode(str));

String dateModelToJson(DateModel data) => json.encode(data.toJson());

class DateModel {
  DateModel(
      {this.day = 1,
      this.nameDay = '',
      this.month = 1,
      this.nameMonth = '',
      this.year = 0,
      this.date = '',
      this.dateTo = ''});

  int day;
  String nameDay;
  int month;
  String nameMonth;
  int year;
  String date;
  String dateTo;

  factory DateModel.fromJson(Map<String, dynamic> json) => DateModel(
        day: json["day"],
        nameDay: json["name_day"],
        month: json["month"],
        nameMonth: json["name_month"],
        year: json["year"],
        date: json["date"],
        dateTo: json["date_to"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "name_day": nameDay,
        "month": month,
        "name_month": nameMonth,
        "year": year,
        "date": date,
        "date_to": dateTo,
      };
}
