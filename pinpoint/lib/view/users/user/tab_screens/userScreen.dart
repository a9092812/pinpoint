import 'package:flutter/material.dart';
import 'package:pinpoint/model/timetable/timetable_detail.dart';
import 'package:pinpoint/view/common/notes_screen.dart';
import 'package:pinpoint/view/common/student_attendance_history_screen.dart';
import 'package:pinpoint/view/common/time_table_detail_screen.dart';
// Import your models and other screens as needed
// import 'package:pinpoint/model/user/user_detail_dto.dart';
// import 'student_attendance_history_screen.dart';
// import 'student_notes_screen.dart';
// import 'student_profile_screen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'My Profile',
            onPressed: () {
              // TODO: Navigate to StudentProfileScreen
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildGreeting(context, "Alice"),
          const SizedBox(height: 24),
          _buildUpNextCard(context), // Added the "Up Next" card back
          const SizedBox(height: 24),
          _buildAttendanceStatusCard(context),
          const SizedBox(height: 24),
          _buildQuickActions(context),
          const SizedBox(height: 24),
          _buildSectionHeader(context, "Recent Notices"),
          const SizedBox(height: 12),
          _buildRecentNotices(context),
        ],
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, String studentName) {
    return Text(
      "Hi, $studentName!",
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildUpNextCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Up Next",
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "Data Structures",
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(context, Icons.access_time_filled, "10:00 AM - 11:00 AM"),
            const SizedBox(height: 8),
            _buildInfoRow(context, Icons.location_on, "Room 101, Main Building"),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {

                  Navigator.push(context,MaterialPageRoute(builder: (context) => TimetableDetailScreen( timetableId: '', batchId: '',)      ));
TimetableDetailScreen( timetableId: '', batchId: '',)     ;           },
                child: const Text("View Full Timetable"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceStatusCard(BuildContext context) {
    final theme = Theme.of(context);
    // This state would come from a provider
    const bool isPresent = true; 
    const String currentClass = "Data Structures";

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isPresent ? Colors.green.shade50 : theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isPresent ? Icons.check_circle : Icons.location_off,
                  color: isPresent ? Colors.green.shade700 : Colors.red.shade700,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPresent ? "You are Marked Present" : "Attendance Not Marked",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isPresent ? Colors.green.shade800 : theme.colorScheme.onSurface,
                      ),
                    ),
                    if (isPresent)
                      Text(
                        "For: $currentClass",
                        style: TextStyle(color: Colors.green.shade800),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Your location is being monitored for automatic attendance. Ensure location services are enabled.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.history_outlined,
            label: 'Attendance History',
            onTap: () {
Navigator.push(context, MaterialPageRoute(builder: (context) => StudentAttendanceHistoryScreen(),))   ;         },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.note_alt_outlined,
            label: 'My Notes',
            onTap: () {
Navigator.push(context, MaterialPageRoute(builder: (context) => NotesScreen()))    ;        },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentNotices(BuildContext context) {
    // Mock data
    final notices = [
      "Reminder: Guest lecture on AI tomorrow at 10 AM.",
      "Mid-term exam results have been declared.",
    ];

    return Column(
      children: notices.map((notice) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: const Icon(Icons.campaign_outlined),
          title: Text(notice),
        ),
      )).toList(),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
