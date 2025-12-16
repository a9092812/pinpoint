import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/model/building/floor_dto.dart';
import 'package:pinpoint/model/building/room_dto.dart';
import 'package:pinpoint/viewModel/building/building_provider.dart';
// import 'package:pinpoint/view/users/institute/temp_map/map_view_screen.dart'; // Uncomment when map view is ready
 
class BuildingDetailScreen extends ConsumerWidget {
  final String buildingId;
  final String? buildingName;

  const BuildingDetailScreen({
    super.key,
    required this.buildingId,
    this.buildingName,
  });

@override
Widget build(BuildContext context, WidgetRef ref) {
  final theme = Theme.of(context);

  final floorsAsync = ref.watch(floorsProvider(buildingId));

  return Scaffold(
    appBar: AppBar(
      title: Text(buildingName ?? 'Building Details'),
    ),
    body: floorsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (floors) {
        if (floors.isEmpty) {
          return const Center(child: Text('No floors found for this building.'));
        }

        floors.sort((a, b) => a.level.compareTo(b.level));

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Floors',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...floors.map((floor) =>
                _buildFloorExpansionTile(context, ref, floor)),
          ],
        );
      },
    ),
  );
}

 Widget _buildFloorExpansionTile(
    BuildContext context, WidgetRef ref, FloorDto floor) {

final roomsAsync= ref.watch(roomsProvider(floor.level));

  return Card(
    child: ExpansionTile(
      leading: CircleAvatar(child: Text('${floor.level}')),
      title: Text('Floor ${floor.level}'),
      children: [
        roomsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
          error: (e, _) => Text('Error: $e'),
          data: (rooms) => Column(
            children: rooms
                .map((room) => _buildRoomTile(context, room))
                .toList(),
          ),
        )
      ],
    ),
  );
}

  Widget _buildRoomTile(BuildContext context, RoomDto room) {
    return ListTile(
      title: Text(room.name),
      subtitle: Text('Type: ${room.type}'),
      trailing: IconButton(
        icon: const Icon(Icons.location_on_outlined,
            color: Colors.blueAccent),
        tooltip: 'View Room on Map',
        onPressed: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (_) => MapViewerScreen(
          //     building: building, // You might need to pass building down if MapViewer needs it
          //     highlightedRoom: room,
          //     title: room.name,
          //   ),
          // ));
        },
      ),
    );
  }
}