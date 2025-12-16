import 'package:flutter/material.dart';
import 'package:pinpoint/model/admin/admin_response.dart';
import 'package:pinpoint/view/common/admin_detail_screen.dart';
import 'package:pinpoint/view/users/institute/create_admin_screen.dart';
 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/viewModel/admin/admin_provider.dart';
 
class AdminListScreen extends ConsumerWidget {
  const AdminListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminsAsync = ref.watch(adminControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Admins')),
 body: adminsAsync.when(
  data: (admins) {
    if (admins.isEmpty) {
      return const Center(
        child: Text("No admins found for your institute."),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: admins.length,
      itemBuilder: (context, index) {
        final admin = admins[index];
        return AdminListTile(admin: admin);
      },
    );
  },
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (error, stack) => Center(child: Text(error.toString())),
),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateAdminScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Admin'),
      ),
    );
  }
}

class AdminListTile extends StatelessWidget {
  final AdminResponse admin;
  const AdminListTile({required this.admin, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            admin.name?.substring(0, 1) ?? 'A',
            style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
          ),
        ),
        title: Text(
          admin.name ?? 'No Name',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(admin.phone),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6.0,
              runSpacing: 4.0,
              children: admin.batches
                  .map((e) => Chip(
                        label: Text(e.id.split('-').last),
                        labelStyle: const TextStyle(fontSize: 12),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ))
                  .toList(),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AdminDetailScreen(admin: admin),
          ));
        },
      ),
    );
  }
}
