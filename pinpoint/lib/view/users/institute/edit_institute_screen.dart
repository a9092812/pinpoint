import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pinpoint/model/address/address.dart';
import 'package:pinpoint/model/institute/institute_request.dart';
import 'package:pinpoint/view/users/institute/tab_screens/institute_screen.dart';
import 'package:pinpoint/view/widget/address_selector.dart';
import 'package:pinpoint/viewModel/address/address_provider.dart';
import 'package:pinpoint/viewModel/institute/institute_provider.dart';

class CompleteInstituteProfileScreen extends ConsumerStatefulWidget {
  const CompleteInstituteProfileScreen({super.key});

  @override
  ConsumerState<CompleteInstituteProfileScreen> createState() =>
      _CompleteInstituteProfileScreenState();
}

class _CompleteInstituteProfileScreenState
    extends ConsumerState<CompleteInstituteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _baseAltitudeController = TextEditingController();

  bool _loading = false;
  bool _isFetchingLocation = false;

  Address? _selectedAddress;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final institute = ref.read(instituteControllerProvider).value;
      if (institute != null) {
        _nameController.text = institute.name ?? '';
        _baseAltitudeController.text = institute.baseAltitude ?? '';
        if (institute.address != null) {
          _selectedAddress = institute.address;
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _baseAltitudeController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentAltitude() async {
    setState(() => _isFetchingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission denied')),
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
        _baseAltitudeController.text = position.altitude.toStringAsFixed(2);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not fetch altitude: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isFetchingLocation = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an address')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final instituteAsync = ref.read(instituteControllerProvider);
      if (!instituteAsync.hasValue) {
        throw Exception("Institute profile not loaded.");
      }
      final institute = instituteAsync.value;

      // If new address, save it
      if (_selectedAddress?.id == null) {
        await ref
            .read(addressControllerProvider.notifier)
            .createAddress(_selectedAddress!);
      }

      // Prepare institute request
      final instituteDetailsRequest = InstituteRequest(
        name: _nameController.text.trim(),
        baseAltitude: _baseAltitudeController.text.trim(),
        email: institute?.email,
        phone: institute?.phone,
      );

      await ref
          .read(instituteControllerProvider.notifier)
          .updateInstitute(instituteDetailsRequest);

     if (mounted) {
  // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   Navigator.of(context).pushAndRemoveUntil(
  //     MaterialPageRoute(builder: (_) => const InstituteScreen()),
  //     (route) => false,
  //   );
  // });/
  Navigator.pop(context);
}

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Institute Profile")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextFormField(
                  controller: _nameController,
                  labelText: "Institute Name",
                  icon: Icons.business_outlined,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 24),

                // Address selector
                AddressSelectorField(
                  selectedAddress: _selectedAddress,
                  onAddressSelected: (addr) {
                    setState(() => _selectedAddress = addr);
                  },
                ),

                const SizedBox(height: 24),
                _buildTextFormField(
                  controller: _baseAltitudeController,
                  labelText: "Base Altitude (meters)",
                  icon: Icons.layers_outlined,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  suffixIcon: _isFetchingLocation
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.my_location_rounded),
                          onPressed: _getCurrentAltitude,
                          tooltip: "Get Current Altitude",
                        ),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Base Altitude is required'
                      : null,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Save & Continue"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface.withAlpha(50),
        ),
        validator: validator,
      ),
    );
  }
}
