// To parse this JSON data, do
//
//     final bannermodel = bannermodelFromJson(jsonString);

import 'dart:convert';

import 'package:trip_plan/model/hotel_model.dart';

List<Bannermodel> bannermodelFromJson(String str) =>
    List<Bannermodel>.from(json.decode(str).map((x) => Bannermodel.fromJson(x)));

String bannermodelToJson(List<Bannermodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bannermodel {
  String? image;
  String? bannername;
  PlaceModel? place;

  Bannermodel({this.image, this.bannername, this.place});

  factory Bannermodel.fromJson(Map<String, dynamic> json) => Bannermodel(
    image: json["image"],
    bannername: json["bannername"],
     place: json['place'] != null
      ? PlaceModel.fromJson(json['place'] as Map<String, dynamic>)
      : null,
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "bannername": bannername,
    "place": place?.toJson(),
  };
}
