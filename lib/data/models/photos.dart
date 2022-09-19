import 'dart:convert';

import 'package:hive/hive.dart';

part 'photos.g.dart';

List<Photos> photosFromJson(String str) =>
    List<Photos>.from(json.decode(str).map((x) => Photos.fromJson(x)));

String photosToJson(List<Photos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 1)
class Photos {
  Photos({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  });

  @HiveField(0)
  int? albumId;

  @HiveField(1)
  int? id;

  @HiveField(2)
  String? title;

  @HiveField(3)
  String? url;

  @HiveField(4)
  String? thumbnailUrl;

  factory Photos.fromJson(Map<String, dynamic> json) => Photos(
        albumId: json["albumId"],
        id: json["id"],
        title: json["title"],
        url: json["url"],
        thumbnailUrl: json["thumbnailUrl"],
      );

  Map<String, dynamic> toJson() => {
        "albumId": albumId,
        "id": id,
        "title": title,
        "url": url,
        "thumbnailUrl": thumbnailUrl,
      };
}
