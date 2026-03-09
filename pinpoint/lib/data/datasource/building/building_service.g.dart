// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _BuildingService implements BuildingService {
  _BuildingService(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'https://c5636a191455.ngrok-free.app/';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<List<BuildingDto>> getBuildingsByInstitute(
    String instituteId,
    String token,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<BuildingDto>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/buildings/institute/${instituteId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<BuildingDto> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => BuildingDto.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BuildingDto> getBuildingById(String id, String token) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BuildingDto>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/buildings/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BuildingDto _value;
    try {
      _value = BuildingDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<MessageResponse> updateBaseAltitude(
    String buildingId,
    String name,
    int baseAltitude,
    int ceilHeight,
    String token,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'name': name,
      r'baseAltitude': baseAltitude,
      r'ceilHeight': ceilHeight,
    };
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<MessageResponse>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/buildings/${buildingId}/altitude',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MessageResponse _value;
    try {
      _value = MessageResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<FloorDto>> getFloorsByBuilding(String buildingId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<FloorDto>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/floors/building/${buildingId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<FloorDto> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => FloorDto.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<RoomDto>> getRoomsByBuilding(
    String buildingId,
    String token,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<RoomDto>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/rooms/building/${buildingId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<RoomDto> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => RoomDto.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<RoomDto>> getRoomsByFloor(int floorLevel, String token) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<RoomDto>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/rooms/floor/${floorLevel}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<RoomDto> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => RoomDto.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<RoomMapDto>> getRoomsForMap(
    String buildingId,
    String token,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<RoomMapDto>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/rooms/building/${buildingId}/map',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<RoomMapDto> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => RoomMapDto.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
