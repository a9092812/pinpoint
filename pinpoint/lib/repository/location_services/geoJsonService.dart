import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:pinpoint/model/building/building_dto.dart';
import 'package:pinpoint/repository/storage/secure_storage_service.dart';
import 'package:pinpoint/resources/constant/string/appString.dart';

class GeoJsonUploadService {
  final SecureStorageService storage;

  GeoJsonUploadService(this.storage);

  /// Uploads a file and returns the Building object on success, or null on failure.
  Future<BuildingDto?> uploadGeoJsonFile(PlatformFile platformFile) async {
    // 1. Get the file path and auth token
    final file = File(platformFile.path!);
    final jwt = await storage.jwt;

    final uri = Uri.parse('${AppString.baseUrl}api/buildings/upload');
    
    // 2. Prepare the file stream
    var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();

    // 3. Create the multipart request
    var request = http.MultipartRequest("POST", uri);
    
    // Add Authorization header
    if (jwt != null) {
      request.headers['Authorization'] = 'Bearer $jwt';
    }
    
    // Add the file to the request
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(file.path));

    request.files.add(multipartFile);

    try {
      // 4. Send the request
      var response = await request.send();

      // 5. Parse the response
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final jsonMap = json.decode(respStr);
        return BuildingDto.fromJson(jsonMap);
      } else {
        print("Upload failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error uploading file: $e");
      return null;
    }
  }
}

