import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/model/batch/batch_detail_response.dart';
import 'package:pinpoint/view/common/time_table_detail_screen.dart';
import 'package:pinpoint/view/users/institute/create_edit_timetable_screen.dart';
import 'package:pinpoint/view/users/institute/user_list_screen.dart';
import 'admin_list_screen.dart';
import 'package:pinpoint/viewModel/batch/batch_provider.dart';

class BatchDetailScreen extends ConsumerStatefulWidget {
  final String batchId;

  const BatchDetailScreen({super.key, required this.batchId});

  @override
  ConsumerState<BatchDetailScreen> createState() => _BatchDetailScreenState();
}

class _BatchDetailScreenState extends ConsumerState<BatchDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final batchAsyncValue = ref.watch(batchDetailProvider(widget.batchId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Batch Details'),
      ),
      body: batchAsyncValue.when(
        data: (batch) => _buildContent(context, ref, batch),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, BatchDetailResponse batch) {
    final theme = Theme.of(context);

    // Correctly check timetable existence
    final hasTimetable = batch.timetableId != null && batch.timetableId!.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            batch.name,
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Chip(
            label: Text('Code: ${batch.code}'),
            avatar: const Icon(Icons.code_rounded),
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            context,
            icon: Icons.people_outline,
            title: 'View Students (${batch.students.length})',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => StudentListScreen(),
              ));
            },
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            context,
            icon: Icons.admin_panel_settings_outlined,
            title: 'View Admins (${batch.admins.length})',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => AdminListScreen(),
              ));
            },
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            context,
            icon: Icons.calendar_today_outlined,
            title: hasTimetable ? 'View Timetable' : 'Add Timetable',
            onTap: () async {
              if (hasTimetable) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => TimetableDetailScreen(
                    timetableId: batch.timetableId!,
                    batchId: batch.id!,
                  ),
                ));
              } else {
                final newTimetable = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateOrEditTimetableScreen(
                      batchId: batch.id!,
                    ),
                  ),
                );
                if (newTimetable != null) {
                  ref.invalidate(batchDetailProvider(widget.batchId));
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }
}
