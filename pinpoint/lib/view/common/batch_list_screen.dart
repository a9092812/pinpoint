import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 import 'package:pinpoint/view/common/batch_detail_screen.dart';
import 'package:pinpoint/view/users/institute/create_batch_screen.dart';
import 'package:pinpoint/viewModel/batch/batch_provider.dart';
 
class BatchListScreen extends ConsumerWidget {
  final bool isSelectionMode;

  const BatchListScreen({super.key, this.isSelectionMode = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batchesAsync = ref.watch(batchControllerProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navigate to CreateBatchScreen
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateBatchScreen()),
          );
          // Refresh after returning
          ref.invalidate(batchControllerProvider);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Batch'),
      ),
      appBar: AppBar(
        title: Text(isSelectionMode ? 'Select a Batch' : 'All Batches'),
      ),
      body: batchesAsync.when(
        data: (batches) {
          if (batches.isEmpty) {
            return const Center(child: Text("No batches found."));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: batches.length,
            itemBuilder: (context, index) {
              final batch = batches[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                child: ListTile(
                  title: Text(batch.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Code: ${batch.code}'),
                  trailing: isSelectionMode
                      ? const Icon(Icons.add_circle_outline)
                      : IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            try {
                              await ref.read(batchControllerProvider.notifier).deleteBatch(batch.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Batch deleted")),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error deleting batch: $e")),
                              );
                            }
                          },
                        ),
                  onTap: () {
                    if (isSelectionMode) {
                      Navigator.of(context).pop(batch.id);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BatchDetailScreen(batchId: batch.id),
                      ));
                    }
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }
}
