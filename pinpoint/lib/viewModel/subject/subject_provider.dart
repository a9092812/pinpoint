
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/data/datasource/subject/subject_service.dart';
import 'package:pinpoint/model/subject/subject.dart';
import 'package:pinpoint/repository/subject/subject_repository.dart';
import 'package:pinpoint/viewModel/dio/dio_provider.dart';

final subjectServiceProvider = Provider<SubjectService>((ref) {
  return SubjectService(ref.watch(dioProvider));
});

final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  return SubjectRepository(ref.watch(subjectServiceProvider));
});
 

class SubjectController
    extends AutoDisposeFamilyAsyncNotifier<List<SubjectResponse>, String> {
  @override
  Future<List<SubjectResponse>> build(String instituteId) async {
    final repository = ref.watch(subjectRepositoryProvider);
    return repository.getSubjectsByInstitute(instituteId);
  }
 
  Future<void> createSubject(SubjectRequest request) async {
    final repository = ref.read(subjectRepositoryProvider);
    try {
      await repository.createSubject(request);
      ref.invalidateSelf();  
    } catch (e) {
      print(e);
      rethrow;
    }
  }

   Future<void> updateSubject(String id, SubjectRequest request) async {
    final repository = ref.read(subjectRepositoryProvider);
    try {
      await repository.updateSubject(id, request);
      ref.invalidateSelf();  
    } catch (e) {
      print(e);
      rethrow;
    }
  }

   Future<void> deleteSubject(String id) async {
    final repository = ref.read(subjectRepositoryProvider);
    try {
       state = state.whenData(
        (subjects) => subjects.where((s) => s.id != id).toList(),
      );
      await repository.deleteSubject(id);
    } catch (e) {
      print(e);
      ref.invalidateSelf(); 
      rethrow;
    }
  }
}
 
 final subjectControllerProvider = AutoDisposeAsyncNotifierProvider.family<
    SubjectController, List<SubjectResponse>, String>(() {
  return SubjectController();
});
