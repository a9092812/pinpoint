
import 'package:dio/dio.dart';
import 'package:pinpoint/data/datasource/institute/institute_service.dart';
import 'package:pinpoint/model/institute/institute.dart';
import 'package:pinpoint/model/institute/institute_request.dart';
 
class InstituteRepository {
  final InstituteApi _instituteApi;
 
  InstituteRepository(this._instituteApi);



   Future<InstituteResponse> getInstitute() async {
    try {
        return await _instituteApi.getInstitute();
    } on DioException catch (e) {
      throw Exception('Failed to fetch institute profile: ${e.message}');
    }
  }

   Future<void> updateInstitute(InstituteRequest request) async {
    try {
    
      await _instituteApi.updateInstitute(request);
    } on DioException catch (e) {
      throw Exception('Failed to update institute profile: ${e.message}');
    }
  }
}
