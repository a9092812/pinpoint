import 'package:dio/dio.dart';
import 'package:pinpoint/data/datasource/timetable/timetable_service.dart';
import 'package:pinpoint/model/timetable/day_schedule.dart';
import 'package:pinpoint/model/timetable/period.dart';
import 'package:pinpoint/model/timetable/timetable_detail.dart';
import 'package:pinpoint/model/timetable/timetable_summary.dart';

class TimetableRepository {
  final TimetableService _service;

  TimetableRepository(this._service);

  // === Timetable CRUD ===
  Future<List<TimetableSummary>> getAllTimetables() async {
    try {
      final response = await _service.getTimetables();
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch timetables: ${e.message}');
    }
  }

  Future<TimetableDetail> getTimetableById(String id) async {
    try {
      final response = await _service.getTimetableById(id);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch timetable detail: ${e.message}');
    }
  }

  Future<TimetableDetail?> createTimetable(String name, String batchId) async {
    final data = {"name": name, "batchId": batchId};
    try {
      final response = await _service.createTimetable(data);
      return response.data;
    } on DioException catch (e) {
      print('Dio error creating timetable: ${e.message}');
      return null;
    }
  }

    Future<TimetableDetail> getTimetableByBatchId(String batchId) async {
    try {
      final response = await _service.getTimetableByBatchId(batchId);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch timetable by batch ID: ${e.message}');
    }
  }


  Future<TimetableDetail?> updateTimetable(String id, String name, String batchId) async {
    final data = {"id": id, "name": name, "batchId": batchId};
    try {
      final response = await _service.updateTimetable(data);
      return response.data;
    } on DioException catch (e) {
      print('Dio error updating timetable: ${e.message}');
      return null;
    }
  }

  Future<void> deleteTimetable(String id) async {
    try {
      await _service.deleteTimetable(id);
    } on DioException catch (e) {
      throw Exception('Failed to delete timetable: ${e.message}');
    }
  }

  // === DaySchedule ===
  Future<DaySchedule> getDaySchedule(String id) async {
    try {
      final response = await _service.getDaySchedule(id);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch day schedule: ${e.message}');
    }
  }

  Future<DaySchedule?> updateDaySchedule(DaySchedule schedule) async {
    final data = schedule.toJson();
    try {
      final response = await _service.updateDaySchedule(schedule.id, data);
      return response.data;
    } on DioException catch (e) {
      print('Dio error updating day schedule: ${e.message}');
      return null;
    }
  }

  // === Period ===
  Future<Period> getPeriod(String id) async {
    try {
      final response = await _service.getPeriod(id);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch period: ${e.message}');
    }
  }

  Future<Period?> updatePeriod(Period period) async {
    final data = period.toJson();
    try {
      final response = await _service.updatePeriod(period.id, data);
      return response.data;
    } on DioException catch (e) {
      print('Dio error updating period: ${e.message}');
      return null;
    }
  }
}
