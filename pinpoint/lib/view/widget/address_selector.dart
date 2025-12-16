import 'package:flutter/material.dart';
import 'package:pinpoint/model/address/address.dart';
import 'package:pinpoint/view/common/address_list_scren.dart';

class AddressSelectorField extends StatelessWidget {
  final Address? selectedAddress;
  final void Function(Address) onAddressSelected;

  const AddressSelectorField({
    super.key,
    required this.selectedAddress,
    required this.onAddressSelected,
  });

  void _selectAddress(BuildContext context) async {
    final selected = await Navigator.of(context).push<Address>(
      MaterialPageRoute(builder: (context) => const AddEditAddressScreen()),
    );

    if (selected != null) {
      onAddressSelected(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<Address>(
      validator: (_) => selectedAddress == null ? 'Please select an address.' : null,
      builder: (formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: formFieldState.hasError
                      ? theme.colorScheme.error
                      : theme.colorScheme.outline.withOpacity(0.5),
                ),
              ),
              child: InkWell(
                onTap: () => _selectAddress(context),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: theme.colorScheme.primary),
                      const SizedBox(width: 16),
                      Expanded(
                        child: selectedAddress == null
                            ? Text(
                                'Select an address',
                                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(selectedAddress!.streetAddress,
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  Text('${selectedAddress!.city}, ${selectedAddress!.state}'),
                                ],
                              ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    ],
                  ),
                ),
              ),
            ),
            if (formFieldState.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                child: Text(
                  formFieldState.errorText!,
                  style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
