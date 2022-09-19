import 'dart:convert';

import 'package:hive/hive.dart';

part 'album.g.dart';

List<Album> albumFromJson(String str) =>
    List<Album>.from(json.decode(str).map((x) => Album.fromJson(x)));

String albumToJson(List<Album> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 0)
class Album {
  Album({
    this.userId,
    this.id,
    this.title,
  });

  @HiveField(0)
  int? userId;

  @HiveField(1)
  int? id;

  @HiveField(2)
  String? title;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
      };
}
