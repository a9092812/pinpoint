import 'package:dio/dio.dart';
import 'package:pinpoint/model/batch/batch_detail_response.dart';
import 'package:pinpoint/model/batch/batch_list_response.dart';
import 'package:pinpoint/model/message_response.dart';
import 'package:pinpoint/resources/constant/string/appString.dart';
import 'package:retrofit/retrofit.dart';


part 'batch_service.g.dart';
@RestApi(baseUrl: AppString.baseUrl)
abstract class BatchService {
  factory BatchService(Dio dio, {String baseUrl}) = _BatchService;

  @POST("/api/batches")
  Future<HttpResponse<BatchDetailResponse>> createBatch(
    @Body() Map<String, dynamic> batch,
  );

  @GET("/api/batches")
  Future<HttpResponse<List<BatchListResponse>>> getAllBatches();

  @GET("/api/batches/{id}")
  Future<HttpResponse<BatchDetailResponse>> getBatchById(
    @Path("id") String id,
  );

  @DELETE("/api/batches/{id}")
  Future<HttpResponse<MessageResponse>> deleteBatch(
    @Path("id") String id,
  );

  @POST("/api/batches")
Future<HttpResponse<dynamic>> createBatchRaw(@Body() Map<String, dynamic> batch);

}
