// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetableDetail _$TimetableDetailFromJson(Map<String, dynamic> json) =>
    TimetableDetail(
      id: json['id'] as String,
      name: json['name'] as String,
      schedules: (json['schedules'] as List<dynamic>?)
              ?.map((e) => DaySchedule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TimetableDetailToJson(TimetableDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'schedules': instance.schedules,
    };
