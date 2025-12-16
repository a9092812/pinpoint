
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/data/datasource/period/period_service.dart';
import 'package:pinpoint/model/period/period.dart';
import 'package:pinpoint/repository/period/period_repository.dart';
import 'package:pinpoint/viewModel/dio/dio_provider.dart';

final periodServiceProvider = Provider<PeriodService>((ref) {
  return PeriodService(ref.watch(dioProvider));
});

final periodRepositoryProvider = Provider<PeriodRepository>((ref) {
  return PeriodRepository(ref.watch(periodServiceProvider));
});

 

class PeriodController
    extends AutoDisposeFamilyAsyncNotifier<List<PeriodResponse>, String> {
  @override
  Future<List<PeriodResponse>> build(String batchId) async {
     final repository = ref.watch(periodRepositoryProvider);
    return repository.getPeriodsByBatch(batchId);
  }

   Future<void> createPeriod(PeriodRequest request) async {
    final repository = ref.read(periodRepositoryProvider);
    try {
      await repository.createPeriod(request);
       ref.invalidateSelf();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

   Future<void> updatePeriod(String periodId, PeriodRequest request) async {
    final repository = ref.read(periodRepositoryProvider);
    try {
      await repository.updatePeriod(periodId, request);
       ref.invalidateSelf();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

   Future<void> deletePeriod(String periodId) async {
    final repository = ref.read(periodRepositoryProvider);
    try {
       state = state.whenData(
        (periods) => periods.where((p) => p.id != periodId).toList(),
      );
      await repository.deletePeriod(periodId);
    } catch (e) {
      print(e);
       ref.invalidateSelf();
      rethrow;
    }
  }
}
 
final periodControllerProvider = AutoDisposeAsyncNotifierProvider.family<
    PeriodController, List<PeriodResponse>, String>(() {
  return PeriodController();
});
