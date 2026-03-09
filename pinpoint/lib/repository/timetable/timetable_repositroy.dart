import 'package:dio/dio.dart';
import 'package:pinpoint/data/datasource/timetable/timetable_service.dart';
import 'package:pinpoint/model/timetable/day_schedule.dart';
import 'package:pinpoint/model/timetable/period.dart';
import 'package:pinpoint/model/timetable/timetable_detail.dart';
import 'package:pinpoint/model/timetable/timetable_summary.dart';

class TimetableRepository {
  final TimetableService _service;

  TimetableRepository(this._service);

  // ===== Timetable =====
  Future<List<TimetableSummary>> getAllTimetables() async {
    final res = await _service.getTimetables();
    return res.data;
  }

  Future<TimetableDetail> getTimetableById(String id) async {
    final res = await _service.getTimetableById(id);
    return res.data;
  }

  Future<TimetableDetail> getTimetableByBatchId(String batchId) async {
    final res = await _service.getTimetableByBatchId(batchId);
    return res.data;
  }

  Future<TimetableDetail> createTimetable(
    String name,
    String batchId,
  ) async {
    final res = await _service.createTimetable({
      "name": name,
      "batchId": batchId,
    });
    return res.data;
  }

  Future<TimetableDetail> updateTimetable(
    String id,
    String name,
    String batchId,
  ) async {
    final res = await _service.updateTimetable({
      "id": id,
      "name": name,
      "batchId": batchId,
    });
    return res.data;
  }

  Future<void> deleteTimetable(String id) async {
    await _service.deleteTimetable(id);
  }

  // ===== DaySchedule =====
  Future<DaySchedule> getDaySchedule(String id) async {
    final res = await _service.getDaySchedule(id);
    return res.data;
  }

  Future<DaySchedule> createDaySchedule(
    String timetableId,
    DaySchedule schedule,
  ) async {
    final res = await _service.createDaySchedule(
      timetableId,
      schedule.toJson(),
    );
    return res.data;
  }

  Future<DaySchedule> updateDaySchedule(
    DaySchedule schedule,
  ) async {
    final res = await _service.updateDaySchedule(
      schedule.id,
      schedule.toJson(),
    );
    return res.data;
  }

  // ===== Period =====
  Future<Period> getPeriod(String id) async {
    final res = await _service.getPeriod(id);
    return res.data;
  }

  Future<Period> createPeriod(Period period) async {
    final res = await _service.createPeriod(period.toJson());
    return res.data;
  }

  Future<Period> updatePeriod(Period period) async {
    final res = await _service.updatePeriod(
      period.id,
      period.toJson(),
    );
    return res.data;
  }
}
