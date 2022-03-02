// To parse this JSON data, do
//
//     final menu = menuFromJson(jsonString);

import 'dart:convert';

Menu menuFromJson(String str) => Menu.fromJson(json.decode(str));

String menuToJson(Menu data) => json.encode(data.toJson());

class Menu {
    Menu({
        this.title,
        this.icon,
        this.url,
        this.type,
        this.priority,
        this.code,
        this.children,
    });

    String? title;
    String? icon;
    String? url;
    String? type;
    String? priority;
    String? code;
    List<Menu>? children;

    factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        title: json["title"],
        icon: json["icon"],
        url: json["url"],
        type: json["type"],
        priority: json["priority"],
        code: json["code"],
        children: json["children"] == null ? [] : List<Menu>.from(json["children"].map((x) => Menu.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "icon": icon,
        "url": url,
        "type": type,
        "priority": priority,
        "code": code,
        "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x.toJson())),
    };
}
