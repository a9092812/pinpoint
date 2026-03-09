import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/view/users/institute/subject_list_screen.dart';
import 'package:uuid/uuid.dart';

import 'package:pinpoint/model/timetable/timetable_detail.dart';
import 'package:pinpoint/model/timetable/day_schedule.dart';
import 'package:pinpoint/model/timetable/period.dart';
import 'package:pinpoint/view/users/institute/institute_building_picker_screen.dart';
import 'package:pinpoint/viewModel/timetable/timetable_provider.dart';

class CreateOrEditTimetableScreen extends ConsumerStatefulWidget {
  final TimetableDetail? existingTimetable;
  final String batchId;

  const CreateOrEditTimetableScreen({
    super.key,
    this.existingTimetable,
    required this.batchId,
  });

  @override
  ConsumerState<CreateOrEditTimetableScreen> createState() =>
      _CreateOrEditTimetableScreenState();
}

class _CreateOrEditTimetableScreenState
    extends ConsumerState<CreateOrEditTimetableScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late List<DaySchedule> _schedules;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(text: widget.existingTimetable?.name ?? '');

    _schedules = widget.existingTimetable?.schedules
            .map((d) => DaySchedule(
                  id: d.id,
                  day: d.day,
                  periods: List.from(d.periods),
                ))
            .toList() ??
        [
          DaySchedule(id: 'mon', day: 'Monday', periods: const []),
          DaySchedule(id: 'tue', day: 'Tuesday', periods: const []),
          DaySchedule(id: 'wed', day: 'Wednesday', periods: const []),
          DaySchedule(id: 'thu', day: 'Thursday', periods: const []),
          DaySchedule(id: 'fri', day: 'Friday', periods: const []),
          DaySchedule(id: 'sat', day: 'Saturday', periods: const []),
        ];
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final controller =
        ref.read(timetableControllerProvider.notifier);

    widget.existingTimetable == null
        ? await controller.createTimetable(
            _nameController.text,
            widget.batchId,
          )
        : await controller.updateTimetable(
            widget.existingTimetable!.id,
            _nameController.text,
            widget.batchId,
          );

    if (mounted) Navigator.pop(context, true);
  }

  void _addOrEditPeriod(DaySchedule day, {Period? existing}) async {
    final period = await showDialog<Period>(
      context: context,
      builder: (_) => _AddEditPeriodDialog(
        dayScheduleId: day.id,
        existing: existing,
      ),
    );

    if (period == null) return;

    setState(() {
      final index = _schedules.indexWhere((d) => d.id == day.id);
      existing == null
          ? _schedules[index].periods.add(period)
          : _schedules[index]
              .periods[_schedules[index]
                  .periods
                  .indexWhere((p) => p.id == existing.id)] = period;

      _schedules[index].periods
          .sort((a, b) => a.startTime.compareTo(b.startTime));
    });
  }

  @override
  Widget build(BuildContext context) {
    final loading =
        ref.watch(timetableControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingTimetable == null
            ? 'Create Timetable'
            : 'Edit Timetable'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _save,
        icon: const Icon(Icons.save),
        label: const Text('Save'),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Timetable Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 24),
                ..._schedules.map(_buildDayCard),
              ],
            ),
          ),
          if (loading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildDayCard(DaySchedule day) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            title: Text(day.day,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _addOrEditPeriod(day),
            ),
          ),
          if (day.periods.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('No periods added'),
            )
          else
            ...day.periods.map(
              (p) => ListTile(
                title: Text(p.subject),
                subtitle: Text('${p.startTime} - ${p.endTime}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () =>
                      _addOrEditPeriod(day, existing: p),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/* ---------------- PERIOD DIALOG ---------------- */

class _AddEditPeriodDialog extends StatefulWidget {
  final String dayScheduleId;
  final Period? existing;

  const _AddEditPeriodDialog({
    required this.dayScheduleId,
    this.existing,
  });

  @override
  State<_AddEditPeriodDialog> createState() =>
      _AddEditPeriodDialogState();
}

class _AddEditPeriodDialogState
    extends State<_AddEditPeriodDialog> {
  SelectedSubject? subject;
  SelectedRoom? room;

  late TextEditingController teacher;
  late TextEditingController start;
  late TextEditingController end;

  @override
  void initState() {
    super.initState();
    subject = widget.existing == null
        ? null
        : SelectedSubject(
            widget.existing!.subjectId, widget.existing!.subject);
    room = widget.existing == null
        ? null
        : SelectedRoom(
            widget.existing!.roomId, widget.existing!.roomName);

    teacher =
        TextEditingController(text: widget.existing?.teacher);
    start =
        TextEditingController(text: widget.existing?.startTime);
    end =
        TextEditingController(text: widget.existing?.endTime);
  }

  void _submit() {
    if (subject == null || room == null) return;

    Navigator.pop(
      context,
      Period(
        id: widget.existing?.id ?? const Uuid().v4(),
        name: 'Period',
        subject: subject!.name,
        subjectId: subject!.id,
        teacher: teacher.text,
        roomName: room!.name,
        roomId: room!.id,
        startTime: start.text,
        endTime: end.text,
        scheduleDayId: widget.dayScheduleId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add Period' : 'Edit Period'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(subject?.name ?? 'Select Subject'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              final s = await Navigator.push<SelectedSubject>(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const SubjectsListScreen(selectMode: true),
                ),
              );
              if (s != null) setState(() => subject = s);
            },
          ),
          ListTile(
            title: Text(room?.name ?? 'Select Room'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              final r = await Navigator.push<SelectedRoom>(
                context,
                MaterialPageRoute(
                  builder: (_) => const BuildingPickerScreen(),
                ),
              );
              if (r != null) setState(() => room = r);
            },
          ),
          TextField(
              controller: teacher,
              decoration:
                  const InputDecoration(labelText: 'Teacher')),
          TextField(
            controller: start,
            readOnly: true,
            decoration:
                const InputDecoration(labelText: 'Start Time'),
            onTap: () async {
              final t = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());
              if (t != null) start.text = t.format(context);
            },
          ),
          TextField(
            controller: end,
            readOnly: true,
            decoration:
                const InputDecoration(labelText: 'End Time'),
            onTap: () async {
              final t = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());
              if (t != null) end.text = t.format(context);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
