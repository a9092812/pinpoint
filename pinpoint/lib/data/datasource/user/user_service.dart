 
import 'package:dio/dio.dart';
import 'package:pinpoint/model/user/user_detail_dto.dart';
import 'package:pinpoint/model/user/user_list_dto.dart';
import 'package:retrofit/retrofit.dart';

 part 'user_service.g.dart';

 @RestApi()
abstract class UserApiService {
   factory UserApiService(Dio dio, {String baseUrl}) = _UserApiService;

   @GET('/api/users/all/{id}')
  Future<List<UserListDto>> getAllUsers(
    @Path('id') String instituteOrAdminId,
    @Header('Authorization') String token,
  );

   @GET('/api/users/{id}')
  Future<UserDetailDto> getUserById(
    @Path('id') String userId,
    @Header('Authorization') String token,
  );

   @PUT('/api/users/{id}')
  Future<void> updateUser(
    @Path('id') String userId,
    @Header('Authorization') String token,
    @Body() Map<String, dynamic> body,
  );

   @DELETE('/api/users/{id}')
  Future<void> deleteUser(
    @Path('id') String userId,
    @Header('Authorization') String token,
  );
}