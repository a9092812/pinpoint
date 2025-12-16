import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/view/common/admin_list_screen.dart';
import 'package:pinpoint/view/common/batch_list_screen.dart';
import 'package:pinpoint/view/users/institute/building_detail_screen.dart';
import 'package:pinpoint/view/users/institute/edit_institute_screen.dart';
import 'package:pinpoint/view/users/institute/subject_list_screen.dart';
import 'package:pinpoint/view/users/institute/upload_building_screen.dart';
import 'package:pinpoint/view/users/institute/user_list_screen.dart';
import 'package:pinpoint/view/widget/stat_card.dart';
import 'package:pinpoint/viewModel/building/building_provider.dart';
 import 'package:pinpoint/viewModel/institute/institute_provider.dart';

class InstituteScreen extends ConsumerWidget {
  const InstituteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instituteAsync = ref.watch(instituteControllerProvider);

    return instituteAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error loading institute: $e')),
      ),
      data: (profile) {
        // Redirect if required field is missing
        if (profile.name == null || profile.name!.isEmpty) {
          Future.microtask(() {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const CompleteInstituteProfileScreen(),
              ),
            );
          });
        }

        // Normal dashboard
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Text
                    Text(
                      "Dashboard",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 24),

                    // Quick Statistics Grid
                    _buildStatsGrid(context),

                    const SizedBox(height: 32),

                    // Main Action Button
                    _buildUploadButton(context),

                    const SizedBox(height: 32),

                    // Buildings Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Buildings",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            ref.invalidate(buildingControllerProvider);
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildBuildingList(context, ref),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBuildingList(BuildContext context, WidgetRef ref) {
    final buildingsAsync = ref.watch(buildingControllerProvider);

    return buildingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (buildings) {
        if (buildings.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No buildings uploaded yet.'),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: buildings.length,
          itemBuilder: (context, index) {
            final building = buildings[index];
            return Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              child: ListTile(
                leading: const Icon(Icons.business_outlined, size: 40),
                title: Text(
                  building.name ?? 'Unnamed Building',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                 trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  // Navigate to the details screen using the ID
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BuildingDetailScreen(
                        buildingId: building.id,
                        buildingName: building.name,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final stats = [
      {
        'icon': Icons.admin_panel_settings_rounded,
        'label': 'Total Admins',
        'count': '12',
        'screen': const AdminListScreen(),
      },
      {
        'icon': Icons.school_rounded,
        'label': 'Total Students',
        'count': '450',
        'screen': const StudentListScreen(),
      },
      {
        'icon': Icons.groups_rounded,
        'label': 'Total Batches',
        'count': '15',
        'screen': const BatchListScreen(),
      },
      {
        'icon': Icons.subject_rounded,
        'label': 'Total Subjects',
        'count': '30',
        'screen': const SubjectsListScreen(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return StatCard(
          icon: stat['icon'] as IconData,
          label: stat['label'] as String,
          count: stat['count'] as String,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => stat['screen'] as Widget),
          ),
        );
      },
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.upload_file_rounded),
        label: const Text("Upload Building Plan"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UploadBuildingPlanScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}