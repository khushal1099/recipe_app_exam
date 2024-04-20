// To parse this JSON data, do
//
//     final authUser = authUserFromJson(jsonString);

import 'dart:convert';

AuthUser authUserFromJson(String str) => AuthUser.fromJson(json.decode(str));

String authUserToJson(AuthUser data) => json.encode(data.toJson());

class AuthUser {
  String? name;
  String? email;
  String? number;
  String? image;

  AuthUser({
    this.name,
    this.email,
    this.number,
    this.image,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    name: json["name"],
    email: json["email"],
    number: json["number"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "number": number,
    "image": image,
  };
}
