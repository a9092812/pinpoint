import 'package:dio/dio.dart';
import 'package:pinpoint/data/datasource/subject/subject_service.dart';
import 'package:pinpoint/model/subject/subject.dart';

class SubjectRepository {
  final SubjectService _subjectService;

  SubjectRepository(this._subjectService);

   Future<List<SubjectResponse>> getSubjectsByInstitute(String instituteId) async {
    try {
      final response = await _subjectService.getSubjectsByInstitute(instituteId);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch subjects: ${e.message}');
    }
  }

  /// Creates a new subject.
  Future<SubjectResponse> createSubject(SubjectRequest subject) async {
    try {
      final response = await _subjectService.createSubject(subject);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to create subject: ${e.message}');
    }
  }

  /// Updates an existing subject.
  Future<SubjectResponse> updateSubject(String id, SubjectRequest subject) async {
    try {
      final response = await _subjectService.updateSubject(id, subject);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to update subject: ${e.message}');
    }
  }

  /// Deletes a subject by its ID.
  Future<void> deleteSubject(String id) async {
    try {
      await _subjectService.deleteSubject(id);
    } on DioException catch (e) {
      throw Exception('Failed to delete subject: ${e.message}');
    }
  }
}