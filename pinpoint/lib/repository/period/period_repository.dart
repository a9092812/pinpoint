
import 'package:dio/dio.dart';
import 'package:pinpoint/data/datasource/period/period_service.dart';
import 'package:pinpoint/model/period/period.dart';

class PeriodRepository {
  final PeriodService _periodService;

  PeriodRepository(this._periodService);

  /// Fetches all periods for a specific batch.
  Future<List<PeriodResponse>> getPeriodsByBatch(String batchId) async {
    try {
      final response = await _periodService.getPeriodsByBatch(batchId);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch periods: ${e.message}');
    }
  }

  /// Creates a new period.
  Future<void> createPeriod(PeriodRequest request) async {
    try {
      await _periodService.createPeriod(request);
    } on DioException catch (e) {
      throw Exception('Failed to create period: ${e.message}');
    }
  }

  /// Updates an existing period.
  Future<void> updatePeriod(String periodId, PeriodRequest request) async {
    try {
      await _periodService.updatePeriod(periodId, request);
    } on DioException catch (e) {
      throw Exception('Failed to update period: ${e.message}');
    }
  }

  /// Deletes a period by its ID.
  Future<void> deletePeriod(String periodId) async {
    try {
      await _periodService.deletePeriod(periodId);
    } on DioException catch (e) {
      throw Exception('Failed to delete period: ${e.message}');
    }
  }
}