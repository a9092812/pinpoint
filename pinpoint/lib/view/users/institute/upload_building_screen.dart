import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pinpoint/viewModel/building/building_provider.dart';
import 'package:pinpoint/viewModel/location/geojson_upload_provider.dart';

class UploadBuildingPlanScreen extends ConsumerStatefulWidget {
  const UploadBuildingPlanScreen({super.key});

  @override
  ConsumerState<UploadBuildingPlanScreen> createState() =>
      _UploadBuildingPlanScreenState();
}

class _UploadBuildingPlanScreenState
    extends ConsumerState<UploadBuildingPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ceilHeightController = TextEditingController();
  final _baseHeightController = TextEditingController();

  PlatformFile? _pickedFile;
  bool _isFetchingLocation = false;
  bool _isUploading = false;

  /// Opens the device's file picker to select a GeoJSON file.
  Future<void> _pickGeoJsonFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['geojson', 'json'],
      );

      if (result != null) {
        setState(() {
          _pickedFile = result.files.single;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error picking file: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  /// Fetches the current device altitude using the geolocator package.
  Future<void> _getCurrentAltitude() async {
    setState(() => _isFetchingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied.')),
            );
          }
          setState(() => _isFetchingLocation = false);
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      setState(() {
        _baseHeightController.text = position.altitude.toStringAsFixed(2);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Could not fetch location: $e'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isFetchingLocation = false);
      }
    }
  }

  Future<void> _submitPlan() async {
    if (_formKey.currentState!.validate()) {
      if (_pickedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select a GeoJSON file.'),
              backgroundColor: Colors.red),
        );
        return;
      }

      setState(() => _isUploading = true);

      try {
        // 1. Upload the GeoJSON File
        final uploadService = ref.read(geoJsonUploadServiceProvider);
        final uploadedBuilding =
            await uploadService.uploadGeoJsonFile(_pickedFile!);

        if (uploadedBuilding != null) {
          // 2. If upload successful, update the altitude settings
          final buildingId = uploadedBuilding.id;
          final buildingName = _nameController.text.trim();
          final baseAlt = int.tryParse(_baseHeightController.text) ?? 0;
          final ceilHeight = int.tryParse(_ceilHeightController.text) ?? 0;

          // Call the repository to update altitude settings
          // This assumes updateBaseAltitude is available in your buildingRepositoryProvider
          await ref.read(buildingRepositoryProvider).updateBaseAltitude(
  buildingId,
  buildingName,        // ✅ NEW
  baseAlt,
  ceilHeight,
);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Building plan uploaded successfully!'),
                  backgroundColor: Colors.green),
            );
            ref.invalidate(buildingControllerProvider);
            Navigator.of(context).pop(); // Go back to previous screen
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Failed to upload building plan.'),
                  backgroundColor: Colors.red),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('An error occurred: $e'),
                backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isUploading = false);
      }
    }
  }

  @override
  void dispose() {
      _nameController.dispose();
    _ceilHeightController.dispose();
    _baseHeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Building Plan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
                        _buildSectionHeader('Building Name'),

            _buildTextFormField(
  controller: _nameController,
  labelText: 'Building Name',
  hintText: 'e.g., Lecture Theater Block',
  icon: Icons.apartment_outlined,
  isNumber: false
),
const SizedBox(height: 16),

            // --- File Picker Section ---
            _buildSectionHeader('Building Plan File'),
            _buildFilePickerTile(),
            const SizedBox(height: 24),

            // --- Height Configuration Section ---
            _buildSectionHeader('Floor Configuration'),
            _buildTextFormField(
              controller: _ceilHeightController,
              labelText: 'Ceiling Height (in meters)',
              hintText: 'e.g., 3.5',
              icon: Icons.height_outlined,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _baseHeightController,
              labelText: 'Base Floor Altitude (in meters)',
              hintText: 'Enter manually or get from GPS',
              icon: Icons.layers_outlined,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              suffixIcon: _isFetchingLocation
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.my_location_rounded),
                      onPressed: _getCurrentAltitude,
                      tooltip: 'Get Current Altitude',
                    ),
            ),
            const SizedBox(height: 32),

            // --- Submit Button ---
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isUploading ? null : _submitPlan,
                icon: _isUploading
                    ? const SizedBox.shrink()
                    : const Icon(Icons.cloud_upload_outlined),
                label: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Plan'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFilePickerTile() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: _pickGeoJsonFile,
        leading: const Icon(Icons.map_outlined, color: Colors.blueAccent),
        title: Text(_pickedFile?.name ?? 'Select GeoJSON file'),
        subtitle: _pickedFile != null ? const Text('File selected') : null,
        trailing: const Icon(Icons.attach_file),
      ),
    );
  }
Widget _buildTextFormField({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  required IconData icon,
  TextInputType? keyboardType,
  Widget? suffixIcon,
  bool isNumber = false, // ✅ NEW
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }

      // ✅ only validate numbers when needed
      if (isNumber && double.tryParse(value) == null) {
        return 'Please enter a valid number';
      }

      return null;
    },
  );
}
    }