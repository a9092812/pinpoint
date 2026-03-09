import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pinpoint/model/building/room_dto.dart';
import 'package:pinpoint/viewModel/building/building_provider.dart';

/* -------- RETURN MODEL -------- */
class SelectedRoom {
  final String id;
  final String name;
  SelectedRoom(this.id, this.name);
}

class BuildingPickerScreen extends ConsumerWidget {
  const BuildingPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buildingsAsync = ref.watch(buildingControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Room')),
      body: buildingsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (buildings) {
          if (buildings.isEmpty) {
            return const Center(child: Text('No buildings found'));
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: buildings.map((building) {
              return Card(
                child: ExpansionTile(
                  title: Text(
                    building.name ?? 'Building',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                  children: [
                    _FloorsView(buildingId: building.id),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

/* ---------------- FLOORS ---------------- */

class _FloorsView extends ConsumerWidget {
  final String buildingId;

  const _FloorsView({required this.buildingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final floorsAsync = ref.watch(floorsProvider(buildingId));

    return floorsAsync.when(
      loading: () =>
          const Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
      error: (e, _) => Text('Error: $e'),
      data: (floors) {
        floors.sort((a, b) => a.level.compareTo(b.level));

        return Column(
          children: floors.map((floor) {
            return ExpansionTile(
              title: Text('Floor ${floor.level}'),
              children: [
                _RoomsView(floorLevel: floor.level),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}

/* ---------------- ROOMS ---------------- */

class _RoomsView extends ConsumerWidget {
  final int floorLevel;

  const _RoomsView({required this.floorLevel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(roomsProvider(floorLevel));

    return roomsAsync.when(
      loading: () =>
          const Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
      error: (e, _) => Text('Error: $e'),
      data: (rooms) {
        if (rooms.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8),
            child: Text('No rooms on this floor'),
          );
        }

        return Column(
          children: rooms.map((room) {
            return _RoomTile(room: room);
          }).toList(),
        );
      },
    );
  }
}

/* ---------------- ROOM TILE ---------------- */

class _RoomTile extends StatelessWidget {
  final RoomDto room;

  const _RoomTile({required this.room});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(room.name),
      subtitle: Text('Type: ${room.type}'),
      trailing: const Icon(Icons.check_circle_outline),
      onTap: () {
        Navigator.pop(
          context,
          SelectedRoom(room.id, room.name),
        );
      },
    );
  }
}
