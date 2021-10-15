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
        this.children,
    });

    String? title;
    String? icon;
    String? url;
    String? type;
    String? priority;
    List<Menu>? children;

    factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        title: json["title"] == null ? null : json["title"],
        icon: json["icon"] == null ? null : json["icon"],
        url: json["url"] == null ? null : json["url"],
        type: json["type"] == null ? null : json["type"],
        priority: json["priority"] == null ? null : json["priority"],
        children: json["children"] == null ? [] : List<Menu>.from(json["children"].map((x) => Menu.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "icon": icon == null ? null : icon,
        "url": url == null ? null : url,
        "type": type == null ? null : type,
        "priority": priority == null ? null : priority,
        "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x.toJson())),
    };
}
