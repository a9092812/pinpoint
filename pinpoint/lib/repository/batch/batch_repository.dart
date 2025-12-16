
import 'package:dio/dio.dart';
import 'package:pinpoint/data/datasource/batch/batch_service.dart';
import 'package:pinpoint/model/batch/batch_detail_response.dart';
import 'package:pinpoint/model/batch/batch_list_response.dart';

class BatchRepository {
  final BatchService _batchService;

  BatchRepository(this._batchService);

   Future<List<BatchListResponse>> getAllBatches() async {
    try {
      final response = await _batchService.getAllBatches();
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch batches: ${e.message}');
    }
  }

   Future<BatchDetailResponse> getBatchById(String batchId) async {
    try {
      final response = await _batchService.getBatchById(batchId);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch batch details: ${e.message}');
    }
  }

Future<BatchDetailResponse?> createBatch(String name, String code) async {
  final data = {"name": name, "code": code};

  try {
    final response = await _batchService.createBatchRaw(data); 
     return null; 
  } on DioException catch (e) {
    print('Dio error: ${e.message}');
    return null;
  }
}


  /// Deletes a batch by its ID.
  Future<void> deleteBatch(String batchId) async {
    try {
      await _batchService.deleteBatch(batchId);
    } on DioException catch (e) {
      throw Exception('Failed to delete batch: ${e.message}');
    }
  }
}
