import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:pinpoint/data/datasource/timetable/timetable_service.dart';
 import 'package:pinpoint/model/timetable/day_schedule.dart';
import 'package:pinpoint/model/timetable/period.dart';
import 'package:pinpoint/model/timetable/timetable_detail.dart';
import 'package:pinpoint/model/timetable/timetable_summary.dart';
import 'package:pinpoint/repository/timetable/timetable_repositroy.dart';
import 'package:pinpoint/viewModel/dio/dio_provider.dart';

 

final timetableServiceProvider = Provider<TimetableService>((ref) {
  final dio = ref.watch(dioProvider);
  return TimetableService(dio);
});

// --- Repository Provider ---
final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  final service = ref.watch(timetableServiceProvider);
  return TimetableRepository(service);
});

// --- Timetable Summaries ---
final timetableListProvider =
    FutureProvider<List<TimetableSummary>>((ref) async {
  final repo = ref.watch(timetableRepositoryProvider);
  return repo.getAllTimetables();
});

// --- Timetable Detail ---
final timetableDetailProvider =
    FutureProvider.family<TimetableDetail, String>((ref, id) async {
  final repo = ref.watch(timetableRepositoryProvider);
  return repo.getTimetableById(id);
});

// --- Controller ---
class TimetableController extends StateNotifier<AsyncValue<void>> {
  final TimetableRepository repo;

  TimetableController(this.repo) : super(const AsyncData(null));

  Future<void> createTimetable(String name, String batchId) async {
    state = const AsyncLoading();
    try {
      await repo.createTimetable(name, batchId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateTimetable(String id, String name, String batchId) async {
    state = const AsyncLoading();
    try {
      await repo.updateTimetable(id, name, batchId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteTimetable(String id) async {
    state = const AsyncLoading();
    try {
      await repo.deleteTimetable(id);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateDaySchedule(DaySchedule schedule) async {
    state = const AsyncLoading();
    try {
      await repo.updateDaySchedule(schedule);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updatePeriod(Period period) async {
    state = const AsyncLoading();
    try {
      await repo.updatePeriod(period);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final timetableControllerProvider =
    StateNotifierProvider<TimetableController, AsyncValue<void>>((ref) {
  final repo = ref.watch(timetableRepositoryProvider);
  return TimetableController(repo);
});
