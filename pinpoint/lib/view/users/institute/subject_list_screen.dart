import 'package:flutter/material.dart';
import 'package:pinpoint/model/subject/subject.dart';
import 'package:pinpoint/view/users/institute/edit_subject_screen.dart';

 class SelectedSubject {
  final String id;
  final String name;
  SelectedSubject(this.id, this.name);
}

class SubjectsListScreen extends StatefulWidget {
  final bool selectMode;

  const SubjectsListScreen({
    super.key,
    this.selectMode = false,
  });

  @override
  State<SubjectsListScreen> createState() => _SubjectsListScreenState();
}

class _SubjectsListScreenState extends State<SubjectsListScreen> {
  // Mock data (same as yours)
  final List<SubjectResponse> _subjects = [
    SubjectResponse(
        id: 'subj-001',
        name: 'Data Structures',
        code: 'CS101',
        instituteId: 'inst-A'),
    SubjectResponse(
        id: 'subj-002',
        name: 'Algorithms',
        code: 'CS102',
        instituteId: 'inst-A'),
    SubjectResponse(
        id: 'subj-003',
        name: 'Operating Systems',
        code: 'CS201',
        instituteId: 'inst-A'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectMode
            ? 'Select Subject'
            : 'Manage Subjects'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _subjects.length,
        itemBuilder: (context, index) {
          final subject = _subjects[index];
          return Card(
            margin:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: ListTile(
              leading: const Icon(Icons.book_outlined),
              title: Text(
                subject.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Code: ${subject.code}'),
              trailing: widget.selectMode
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          size: 20),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                AddEditSubjectScreen(subject: subject),
                          ),
                        );
                      },
                    ),
              onTap: widget.selectMode
                  ? () {
                      Navigator.pop(
                        context,
                        SelectedSubject(subject.id, subject.name),
                      );
                    }
                  : null,
            ),
          );
        },
      ),
      floatingActionButton: widget.selectMode
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const AddEditSubjectScreen(),
                ));
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Subject'),
            ),
    );
  }
}
