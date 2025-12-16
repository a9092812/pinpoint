import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/model/timetable/timetable_detail.dart';
import 'package:pinpoint/model/timetable/day_schedule.dart';
import 'package:pinpoint/model/timetable/period.dart';
import 'package:pinpoint/view/users/institute/create_edit_timetable_screen.dart';
import 'package:pinpoint/viewModel/timetable/timetable_provider.dart';

class TimetableDetailScreen extends ConsumerWidget {
  final String timetableId;
  final String batchId;

  const TimetableDetailScreen({
    super.key,
    required this.timetableId,
    required this.batchId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(timetableDetailProvider(timetableId));

    return detailAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, st) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (timetable) => DefaultTabController(
        length: timetable.schedules.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(timetable.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async {
                  final updated = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => CreateOrEditTimetableScreen(
                      existingTimetable: timetable,
                      batchId: batchId,
                    ),
                  ));
                  if (updated == true) {
                    ref.invalidate(timetableDetailProvider(timetableId));
                    ref.invalidate(timetableListProvider);
                  }
                },
              ),
            ],
            bottom: TabBar(
              isScrollable: true,
              tabs: timetable.schedules
                  .map((s) => Tab(text: s.day.toUpperCase()))
                  .toList(),
            ),
          ),
          body: TabBarView(
            children: timetable.schedules
                .map((s) => _buildDayScheduleView(s))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDayScheduleView(DaySchedule schedule) {
    if (schedule.periods.isEmpty) {
      return const Center(child: Text('No periods scheduled for this day.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: schedule.periods.length,
      itemBuilder: (context, index) {
        final period = schedule.periods[index];
        return _PeriodCard(period: period);
      },
    );
  }
}

class _PeriodCard extends StatelessWidget {
  final Period period;
  const _PeriodCard({required this.period});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.primary,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${period.startTime} - ${period.endTime}', style: timeStyle),
            const SizedBox(height: 8),
            Text(period.subject,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _buildInfoRow(context, Icons.person_outline, period.teacher),
            const SizedBox(height: 8),
            _buildInfoRow(context, Icons.location_on_outlined, period.roomName),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
