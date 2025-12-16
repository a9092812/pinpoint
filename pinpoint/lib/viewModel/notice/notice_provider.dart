
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/data/datasource/notice/notice_service.dart';
import 'package:pinpoint/model/notice/notice.dart';
import 'package:pinpoint/repository/notice/notice_repository.dart';
import 'package:pinpoint/viewModel/dio/dio_provider.dart';
import 'package:pinpoint/viewModel/storage/secure_storage_provider.dart';

final noticeServiceProvider = Provider<NoticeService>((ref) {
  return NoticeService(ref.watch(dioProvider));
});

final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  return NoticeRepository(
    ref.watch(noticeServiceProvider),
    ref.watch(secureStorageProvider),
  );
});

 
class NoticeController extends AutoDisposeAsyncNotifier<List<NoticeDto>> {
  @override
  Future<List<NoticeDto>> build() async {
     final repository = ref.watch(noticeRepositoryProvider);
    return repository.getAllNoticesByAdmin();
  }

   Future<void> createNotice(NoticeDto notice) async {
    final repository = ref.read(noticeRepositoryProvider);
    try {
      await repository.createNotice(notice);
       ref.invalidateSelf();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

   Future<void> updateNotice(NoticeDto updatedNotice) async {
    final repository = ref.read(noticeRepositoryProvider);
    try {
       state = state.whenData((notices) {
        return [
          for (final notice in notices)
            if (notice.id == updatedNotice.id) updatedNotice else notice,
        ];
      });
      await repository.updateNotice(updatedNotice);
    } catch (e) {
      print(e);
       ref.invalidateSelf();
      rethrow;
    }
  }

   Future<void> deleteNotice(String noticeId) async {
    final repository = ref.read(noticeRepositoryProvider);
    try {
       state = state.whenData(
        (notices) => notices.where((notice) => notice.id != noticeId).toList(),
      );
      await repository.deleteNotice(noticeId);
    } catch (e) {
      print(e);
       ref.invalidateSelf();
      rethrow;
    }
  }
}

 final noticeControllerProvider =
    AutoDisposeAsyncNotifierProvider<NoticeController, List<NoticeDto>>(() {
  return NoticeController();
});
