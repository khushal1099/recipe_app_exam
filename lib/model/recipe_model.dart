// To parse this JSON data, do
//
//     final recipe = recipeFromJson(jsonString);

import 'dart:convert';

Recipe recipeFromJson(String str) => Recipe.fromJson(json.decode(str));

String recipeToJson(Recipe data) => json.encode(data.toJson());

class Recipe {
  String? title;
  String? description;
  String? recipeimage;

  Recipe({
    this.title,
    this.description,
    this.recipeimage,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    title: json["title"],
    description: json["description"],
    recipeimage: json["recipeimage"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "recipeimage": recipeimage,
  };
}
