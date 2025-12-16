import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/model/address/address.dart';
import 'package:pinpoint/viewModel/address/address_provider.dart';

 class AddEditAddressScreen extends ConsumerStatefulWidget {
  final Address? address; 

  const AddEditAddressScreen({super.key, this.address});

  @override
  ConsumerState<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends ConsumerState<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();

  bool get _isEditing => widget.address != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      // Pre-fill fields if editing an existing address
      _streetController.text = widget.address!.streetAddress;
      _cityController.text = widget.address!.city;
      _stateController.text = widget.address!.state;
      _zipController.text = widget.address!.postalCode;
      _countryController.text = widget.address!.country;
    }
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(addressControllerProvider.notifier);
      final addressData = Address(
        id: widget.address?.id,
        streetAddress: _streetController.text,
        city: _cityController.text,
        state: _stateController.text,
        postalCode: _zipController.text,
        country: _countryController.text,
      );

      if (_isEditing) {
        notifier.updateAddress(addressData);
      } else {
        notifier.createAddress(addressData);
      }

      // **MODIFICATION**: Return the saved address object when popping the screen.
      Navigator.of(context).pop(addressData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Address' : 'Add New Address'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextFormField(
                  controller: _streetController,
                  labelText: 'Street Address',
                  icon: Icons.location_on_outlined,
                  validator: (v) => (v == null || v.isEmpty) ? 'Please enter a street address' : null,
                ),
                _buildTextFormField(
                  controller: _cityController,
                  labelText: 'City',
                  icon: Icons.location_city_outlined,
                  validator: (v) => (v == null || v.isEmpty) ? 'Please enter a city' : null,
                ),
                _buildTextFormField(
                  controller: _stateController,
                  labelText: 'State / Province',
                  icon: Icons.map_outlined,
                  validator: (v) => (v == null || v.isEmpty) ? 'Please enter a state' : null,
                ),
                _buildTextFormField(
                  controller: _zipController,
                  labelText: 'ZIP / Postal Code',
                  icon: Icons.local_post_office_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.isEmpty) ? 'Please enter a postal code' : null,
                ),
                _buildTextFormField(
                  controller: _countryController,
                  labelText: 'Country',
                  icon: Icons.public_outlined,
                  validator: (v) => (v == null || v.isEmpty) ? 'Please enter a country' : null,
                ),
                const SizedBox(height: 32),
                 SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save_outlined),
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    label: Text(_isEditing ? 'Save Changes' : 'Save Address'),
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface.withAlpha(50),
        ),
        validator: validator,
      ),
    );
  }
}

