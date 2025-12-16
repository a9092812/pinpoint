import 'package:dio/dio.dart';
import 'package:pinpoint/data/datasource/notice/notice_service.dart';
import 'package:pinpoint/model/notice/notice.dart';
import 'package:pinpoint/repository/storage/secure_storage_service.dart';

class NoticeRepository {
  final NoticeService _noticeService;
  final SecureStorageService _storageService;

  NoticeRepository(this._noticeService, this._storageService);

  Future<String> _getAdminId() async {
    final adminId = await _storageService.userId; 
    if (adminId == null) throw Exception('User not logged in or Admin ID not found.');
    return adminId;
  }

  /// Fetches all notices sent by the current admin.
  Future<List<NoticeDto>> getAllNoticesByAdmin() async {
    try {
      final adminId = await _getAdminId();
      return await _noticeService.getAllNoticesByAdmin(adminId);
    } on DioException catch (e) {
      throw Exception('Failed to fetch notices: ${e.message}');
    }
  }

  /// Creates a new notice.
  Future<NoticeDto> createNotice(NoticeDto notice) async {
    try {
      return await _noticeService.createNotice(notice);
    } on DioException catch (e) {
      throw Exception('Failed to create notice: ${e.message}');
    }
  }

  /// Updates an existing notice.
  Future<void> updateNotice(NoticeDto notice) async {
    try {
      await _noticeService.updateNotice(notice);
    } on DioException catch (e) {
      throw Exception('Failed to update notice: ${e.message}');
    }
  }

  /// Deletes a notice by its ID.
  Future<void> deleteNotice(String noticeId) async {
    try {
      await _noticeService.deleteNotice(noticeId);
    } on DioException catch (e) {
      throw Exception('Failed to delete notice: ${e.message}');
    }
  }
}