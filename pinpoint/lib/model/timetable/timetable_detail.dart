import 'package:json_annotation/json_annotation.dart';
 import 'day_schedule.dart';

part 'timetable_detail.g.dart';

@JsonSerializable()
class TimetableDetail {
  final String id;
  final String name;
  final List<DaySchedule> schedules;

  TimetableDetail({
    required this.id,
    required this.name,
    this.schedules = const [],   
  });

  factory TimetableDetail.fromJson(Map<String, dynamic> json) =>
      _$TimetableDetailFromJson(json);

  Map<String, dynamic> toJson() => _$TimetableDetailToJson(this);
}
