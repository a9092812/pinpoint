import 'package:json_annotation/json_annotation.dart';
import 'package:pinpoint/model/address/address.dart';
import 'package:pinpoint/model/batch/batch_list_response.dart';
import 'package:pinpoint/model/notice/notice.dart';

part 'admin_response.g.dart';


@JsonSerializable()
class AdminResponse {
  final String id;
  final String email;
  final String phone;
  final String? name;
  final String role;
  final Address? address;
  final String instituteId;
  final List<BatchListResponse> batches;
  final List<NoticeDto> notices;
  final String createdAt;
  final String updatedAt;
  @JsonKey(name: 'verified')
  final bool isVerified;

  AdminResponse({
    required this.id,
    required this.email,
    required this.phone,
    this.name,
    required this.role,
    this.address,
    required this.instituteId,
    required this.batches,
    required this.notices,
    required this.createdAt,
    required this.updatedAt,
    required this.isVerified,
  });

  factory AdminResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AdminResponseToJson(this);
}
