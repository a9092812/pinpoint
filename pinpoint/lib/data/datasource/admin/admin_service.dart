import 'package:dio/dio.dart';
import 'package:pinpoint/DTO/auth.dart';
import 'package:pinpoint/model/admin/admin_request.dart';
import 'package:pinpoint/model/admin/admin_response.dart';
import 'package:pinpoint/model/message_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:pinpoint/resources/constant/string/appString.dart';

part 'admin_service.g.dart';

@RestApi(baseUrl: "${AppString.baseUrl}/api/admins")
abstract class AdminService {
  factory AdminService(Dio dio, {String baseUrl}) = _AdminService;

  @POST("")
  Future<HttpResponse<MessageResponse>> createAdmin(
    @Body() AuthRequest request,
  );
  @GET("/email/{email}")
Future<HttpResponse<AdminResponse>> getAdminByEmail(
  @Path("email") String email,
);


  @GET("/{adminId}")
  Future<HttpResponse<AdminResponse>> getAdminById(
    @Path("adminId") String adminId,
  );

  @GET("/institute/{instituteId}")
  Future<HttpResponse<List<AdminResponse>>> getAdminsByInstitute(
    @Path("instituteId") String instituteId,
  );

  @PUT("/{adminId}")
  Future<HttpResponse<MessageResponse>> updateAdmin(
    @Path("adminId") String adminId,
    @Body() AdminRequest request,
  );

  @DELETE("/{adminId}")
  Future<HttpResponse<MessageResponse>> deleteAdmin(
    @Path("adminId") String adminId,
  );
}
