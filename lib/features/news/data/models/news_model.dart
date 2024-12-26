// To parse this JSON data, do
//
//     final newsModel = newsModelFromJson(jsonString);

import 'dart:convert';

NewsModel newsModelFromJson(String str) => NewsModel.fromJson(json.decode(str));

String newsModelToJson(NewsModel data) => json.encode(data.toJson());

class NewsModel {
  int? id;
  String? title;
  String? subtitle;
  String? author;
  DateTime? createdAt;
  DateTime? updatedAt;

  NewsModel({
    this.id,
    this.title,
    this.subtitle,
    this.author,
    this.createdAt,
    this.updatedAt,
  });

  NewsModel copyWith({
    int? id,
    String? title,
    String? subtitle,
    String? author,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      NewsModel(
        id: id ?? this.id,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        author: author ?? this.author,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
    id: json["id"],
    title: json["title"],
    subtitle: json["subtitle"],
    author: json["author"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "subtitle": subtitle,
    "author": author,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
