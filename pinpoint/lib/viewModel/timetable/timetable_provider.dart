import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/data/datasource/timetable/timetable_service.dart';
import 'package:pinpoint/model/timetable/timetable_detail.dart';
import 'package:pinpoint/model/timetable/timetable_summary.dart';
import 'package:pinpoint/repository/timetable/timetable_repositroy.dart';
import 'package:pinpoint/viewModel/dio/dio_provider.dart';

final timetableServiceProvider = Provider<TimetableService>((ref) {
  final dio = ref.watch(dioProvider);
  return TimetableService(dio);
});

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return TimetableRepository(ref.watch(timetableServiceProvider));
});

// ===== Queries =====
final timetableListProvider =
    FutureProvider<List<TimetableSummary>>((ref) {
  return ref.watch(timetableRepositoryProvider).getAllTimetables();
});

final timetableDetailProvider =
    FutureProvider.family<TimetableDetail, String>((ref, id) {
  return ref.watch(timetableRepositoryProvider).getTimetableById(id);
});

final timetableByBatchProvider =
    FutureProvider.family<TimetableDetail, String>((ref, batchId) {
  return ref
      .watch(timetableRepositoryProvider)
      .getTimetableByBatchId(batchId);
});

// ===== Controller =====
class TimetableController extends StateNotifier<AsyncValue<void>> {
  final TimetableRepository repo;
  final Ref ref;

  TimetableController(this.repo, this.ref)
      : super(const AsyncData(null));

  Future<void> createTimetable(String name, String batchId) async {
    state = const AsyncLoading();
    await repo.createTimetable(name, batchId);
    ref.invalidate(timetableByBatchProvider(batchId));
    ref.invalidate(timetableListProvider);
    state = const AsyncData(null);
  }

  Future<void> updateTimetable(
    String id,
    String name,
    String batchId,
  ) async {
    state = const AsyncLoading();
    await repo.updateTimetable(id, name, batchId);
    ref.invalidate(timetableDetailProvider(id));
    ref.invalidate(timetableByBatchProvider(batchId));
    state = const AsyncData(null);
  }

  Future<void> deleteTimetable(
    String id,
    String batchId,
  ) async {
    state = const AsyncLoading();
    await repo.deleteTimetable(id);
    ref.invalidate(timetableByBatchProvider(batchId));
    ref.invalidate(timetableListProvider);
    state = const AsyncData(null);
  }
}

final timetableControllerProvider =
    StateNotifierProvider<TimetableController, AsyncValue<void>>((ref) {
  return TimetableController(
    ref.watch(timetableRepositoryProvider),
    ref,
  );
});
