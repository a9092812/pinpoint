
 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/data/datasource/batch/batch_service.dart';
import 'package:pinpoint/model/batch/batch_detail_response.dart';
import 'package:pinpoint/model/batch/batch_list_response.dart';
import 'package:pinpoint/repository/batch/batch_repository.dart';
import 'package:pinpoint/viewModel/dio/dio_provider.dart';

final batchServiceProvider = Provider<BatchService>((ref) {
  return BatchService(ref.watch(dioProvider));
});

 final batchRepositoryProvider = Provider<BatchRepository>((ref) {
  return BatchRepository(ref.watch(batchServiceProvider));
});

 
class BatchController extends AutoDisposeAsyncNotifier<List<BatchListResponse>> {
  
  @override
  Future<List<BatchListResponse>> build() async {
    final repository = ref.watch(batchRepositoryProvider);
     return repository.getAllBatches();
  }

 Future<void> createBatch(String name, String code) async {
  final repository = ref.read(batchRepositoryProvider);
  try {
    final batch = await repository.createBatch(name, code);
    ref.invalidateSelf(); // refresh list
    // print("Created batch: ${batch.id}");
  } catch (e) {
    print(e);
    rethrow;
  }
}



   Future<void> deleteBatch(String batchId) async {
    final repository = ref.read(batchRepositoryProvider);
    try {
       state = state.whenData(
        (batches) => batches.where((b) => b.id != batchId).toList(),
      );
      await repository.deleteBatch(batchId);
    } catch (e) {
      print(e);
       ref.invalidateSelf();
      rethrow;
    }
  }
}

 final batchControllerProvider = AutoDisposeAsyncNotifierProvider<BatchController, List<BatchListResponse>>(() {
  return BatchController();
});

 final batchDetailProvider = FutureProvider.autoDispose.family<BatchDetailResponse, String>((ref, batchId) {
  final repository = ref.watch(batchRepositoryProvider);
  return repository.getBatchById(batchId);
});
