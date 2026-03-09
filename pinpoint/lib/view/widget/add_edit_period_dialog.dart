import 'package:flutter/material.dart';
import 'package:pinpoint/view/users/institute/institute_building_picker_screen.dart';
import 'package:uuid/uuid.dart';

import 'package:pinpoint/model/timetable/period.dart';
import 'package:pinpoint/view/users/institute/subject_list_screen.dart';
 
 
class SelectedSubject {
  final String id;
  final String name;
  SelectedSubject(this.id, this.name);
}

class SelectedRoom {
  final String id;
  final String name;
  SelectedRoom(this.id, this.name);
}

/* -------------------- DIALOG -------------------- */

class AddEditPeriodDialog extends StatefulWidget {
  final String dayScheduleId;
  final Period? existing;

  const AddEditPeriodDialog({
    super.key,
    required this.dayScheduleId,
    this.existing,
  });

  @override
  State<AddEditPeriodDialog> createState() => _AddEditPeriodDialogState();
}

class _AddEditPeriodDialogState extends State<AddEditPeriodDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _startCtrl;
  late TextEditingController _endCtrl;
  late TextEditingController _teacherCtrl;

  SelectedSubject? _subject;
  SelectedRoom? _room;

  @override
  void initState() {
    super.initState();

    _startCtrl =
        TextEditingController(text: widget.existing?.startTime ?? '');
    _endCtrl =
        TextEditingController(text: widget.existing?.endTime ?? '');
    _teacherCtrl =
        TextEditingController(text: widget.existing?.teacher ?? '');

    if (widget.existing != null) {
      _subject = SelectedSubject(
        widget.existing!.subjectId,
        widget.existing!.subject,
      );
      _room = SelectedRoom(
        widget.existing!.roomId,
        widget.existing!.roomName,
      );
    }
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      controller.text = time.format(context);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    if (_subject == null || _room == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select subject and room')),
      );
      return;
    }

    Navigator.pop(
      context,
      Period(
        id: widget.existing?.id ?? const Uuid().v4(),
        name: 'Period',
        startTime: _startCtrl.text,
        endTime: _endCtrl.text,
        subject: _subject!.name,
        subjectId: _subject!.id,
        teacher: _teacherCtrl.text,
        roomName: _room!.name,
        roomId: _room!.id,
        scheduleDayId: widget.dayScheduleId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add Period' : 'Edit Period'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              /* ---------- SUBJECT PICKER ---------- */
              ListTile(
                title: Text(
                  _subject?.name ?? 'Select Subject',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  final result =
                      await Navigator.push<SelectedSubject>(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const SubjectsListScreen(selectMode: true),
                    ),
                  );
                  if (result != null) {
                    setState(() => _subject = result);
                  }
                },
              ),

              /* ---------- ROOM PICKER ---------- */
              ListTile(
                title: Text(
                  _room?.name ?? 'Select Room',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  final result =
                      await Navigator.push<SelectedRoom>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BuildingPickerScreen(),
                    ),
                  );
                  if (result != null) {
                    setState(() => _room = result);
                  }
                },
              ),

              const Divider(),

              TextFormField(
                controller: _teacherCtrl,
                decoration:
                    const InputDecoration(labelText: 'Teacher (optional)'),
              ),

              TextFormField(
                controller: _startCtrl,
                readOnly: true,
                decoration:
                    const InputDecoration(labelText: 'Start Time'),
                onTap: () => _pickTime(_startCtrl),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),

              TextFormField(
                controller: _endCtrl,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'End Time'),
                onTap: () => _pickTime(_endCtrl),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
