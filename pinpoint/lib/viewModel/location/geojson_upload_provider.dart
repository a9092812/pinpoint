import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/repository/location_services/geoJsonService.dart';
import 'package:pinpoint/viewModel/storage/secure_storage_provider.dart';

final geoJsonUploadServiceProvider = Provider<GeoJsonUploadService>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return GeoJsonUploadService(storage);
});