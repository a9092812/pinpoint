import 'package:dio/dio.dart';
import 'package:pinpoint/model/timetable/day_schedule.dart';
import 'package:pinpoint/model/timetable/period.dart';
import 'package:pinpoint/model/timetable/timetable_detail.dart';
import 'package:pinpoint/model/timetable/timetable_summary.dart';
import 'package:pinpoint/resources/constant/string/appString.dart';
import 'package:retrofit/retrofit.dart';

part 'timetable_service.g.dart';

@RestApi(baseUrl: "${AppString.baseUrl}/api")
abstract class TimetableService {
  factory TimetableService(Dio dio, {String baseUrl}) = _TimetableService;

  // === Timetable Endpoints ===
  @GET("/timetables")
  Future<HttpResponse<List<TimetableSummary>>> getTimetables();

  @GET("/timetables/{id}")
  Future<HttpResponse<TimetableDetail>> getTimetableById(@Path("id") String id);

  @POST("/timetables")
  Future<HttpResponse<TimetableDetail>> createTimetable(@Body() Map<String, dynamic> body);

  @PUT("/timetables")
  Future<HttpResponse<TimetableDetail>> updateTimetable(@Body() Map<String, dynamic> body);

  @GET("/timetables/batch/{batchId}")
  Future<HttpResponse<TimetableDetail>> getTimetableByBatchId(@Path("batchId") String batchId);

  @DELETE("/timetables/{id}")
  Future<HttpResponse<void>> deleteTimetable(@Path("id") String id);

  // === DaySchedule Endpoints ===
  @GET("/day-schedules/{id}")
  Future<HttpResponse<DaySchedule>> getDaySchedule(@Path("id") String id);

  @PUT("/day-schedules/{id}")
  Future<HttpResponse<DaySchedule>> updateDaySchedule(
    @Path("id") String id,
    @Body() Map<String, dynamic> schedule,
  );

  // === Period Endpoints ===
  @GET("/periods/{id}")
  Future<HttpResponse<Period>> getPeriod(@Path("id") String id);

  @PUT("/periods/{id}")
  Future<HttpResponse<Period>> updatePeriod(
    @Path("id") String id,
    @Body() Map<String, dynamic> period,
  );
}
