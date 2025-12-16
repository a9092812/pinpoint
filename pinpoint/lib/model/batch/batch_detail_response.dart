import 'package:json_annotation/json_annotation.dart';

part 'batch_detail_response.g.dart';

@JsonSerializable()
class BatchDetailResponse {
  final String? id;  
  final String name;
  final String code;
  final List<BatchUser> students;  
  final List<BatchAdmin> admins;  
  final String? timetableId;

  BatchDetailResponse({
    this.id,
    required this.name,
    required this.code,
    this.students = const [],
    this.admins = const [],
    this.timetableId,
  });

  factory BatchDetailResponse.fromJson(Map<String, dynamic> json) {
    return BatchDetailResponse(
      id: (json['id'] == null || json['id'] == '') ? null : json['id'].toString(),
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      students: (json['students'] as List<dynamic>?)
              ?.map((e) => BatchUser.fromJson(e))
              .toList() ?? [],
      admins: (json['admins'] as List<dynamic>?)
              ?.map((e) => BatchAdmin.fromJson(e))
              .toList() ?? [],
     timetableId: (json['timetableId'] == null || json['timetableId'] == '')
    ? null
    : json['timetableId'].toString(),

    );
  }

  Map<String, dynamic> toJson() => _$BatchDetailResponseToJson(this);
}

@JsonSerializable()
class BatchUser {
  final String id;
  final String name;
  final String phone;

  BatchUser({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory BatchUser.fromJson(Map<String, dynamic> json) =>
      _$BatchUserFromJson(json);

  Map<String, dynamic> toJson() => _$BatchUserToJson(this);
}

@JsonSerializable()
class BatchAdmin {
  final String id;
  final String name;

  BatchAdmin({
    required this.id,
    required this.name,
  });

  factory BatchAdmin.fromJson(Map<String, dynamic> json) =>
      _$BatchAdminFromJson(json);

  Map<String, dynamic> toJson() => _$BatchAdminToJson(this);
}
