// To parse this JSON data, do
//
//     final person = personFromJson(jsonString);

import 'dart:convert';

Person personFromJson(String str) => Person.fromJson(json.decode(str));

String personToJson(Person data) => json.encode(data.toJson());

class Person {
  Person({
    this.docNumber = '',
    this.entity = '',
    this.fotoUrl = '',
    this.id = '',
    this.name = '',
  });

  String docNumber;
  String entity;
  String fotoUrl;
  String id;
  String name;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        docNumber: json["doc_number"],
        entity: json["entity"],
        fotoUrl: json["foto_url"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "doc_number": docNumber,
        "entity": entity,
        "foto_url": fotoUrl,
        "id": id,
        "name": name,
      };
}
