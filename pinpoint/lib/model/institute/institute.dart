import 'package:pinpoint/model/address/address.dart';

import 'package:json_annotation/json_annotation.dart';

part 'institute.g.dart';

@JsonSerializable()
class InstituteResponse {
  final String? id;
  final String? email;
  final String? phone;
  final String? name;
  final String? geoJsonUrl;
  final Address? address;
  final String? createdAt;
  final String? updatedAt;

  @JsonKey(name: "verified")
  final bool? isVerified;

  final String? baseAltitude; // make it nullable

  InstituteResponse({
    this.id,
    this.email,
    this.phone,
    this.name,
    this.geoJsonUrl,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.isVerified,
    this.baseAltitude,
  });

  factory InstituteResponse.fromJson(Map<String, dynamic> json) =>
      _$InstituteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InstituteResponseToJson(this);
}
