import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/model/batch/batch_list_response.dart';
import 'package:pinpoint/view/widget/custom_text_field.dart';
import 'package:pinpoint/viewModel/batch/batch_provider.dart';
 
class CreateBatchScreen extends ConsumerStatefulWidget {
  const CreateBatchScreen({super.key});

  @override
  ConsumerState<CreateBatchScreen> createState() => _CreateBatchScreenState();
}

class _CreateBatchScreenState extends ConsumerState<CreateBatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    final name = _nameController.text;
    final code = _codeController.text;

    try {
       await ref.read(batchControllerProvider.notifier).createBatch(name, code);

       ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Batch created successfully!')),
        );

       Navigator.of(context).pop();
    } catch (e) {
       ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Error creating batch: $e')),
        );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: Theme.of(context).textTheme.titleMedium,
          ),
          label: const Text('Create Batch'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(title: const Text('Create New Batch')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: _nameController,
                  labelText: 'Batch Name',
                  icon: Icons.school_outlined,
                  validator: (value) => (value == null || value.isEmpty) ? 'Please enter a batch name' : null,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _codeController,
                  labelText: 'Batch Code',
                  icon: Icons.code_outlined,
                  validator: (value) => (value == null || value.isEmpty) ? 'Please enter a unique batch code' : null,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
