import 'dart:convert';

LoginFormModel loginFormModelFromJson(String str) =>
    LoginFormModel.fromJson(json.decode(str));

String loginFormModelToJson(LoginFormModel data) => json.encode(data.toJson());

class LoginFormModel {
  LoginFormModel({
    this.username = '',
    this.password = '',
    this.noCaduca =false,
  });

  String username;
  String password;
  dynamic noCaduca;

  factory LoginFormModel.fromJson(Map<String, dynamic> json) => LoginFormModel(
        username: json["username"],
        password: json["password"],
        noCaduca: json["no_caduca"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "no_caduca": noCaduca,
      };
}
