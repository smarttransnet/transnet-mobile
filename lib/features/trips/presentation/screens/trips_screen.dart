import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../controllers/trips_controller.dart';
import '../widgets/trip_card.dart';
import '../../data/models/trip_enums.dart';

import '../../../../core/presentation/widgets/app_drawer.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTrips = ref.watch(filteredTripsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      drawer: const AppDrawer(currentRouteName: AppRoutes.tripsName),
      appBar: AppBar(
        title: const Text('Trips Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(tripsProvider);
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              border: Border(
                bottom: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
            ),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => ref.read(tripsSearchQueryProvider.notifier).state = value,
                  decoration: InputDecoration(
                    hintText: 'Search trips...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(title: 'All', status: null),
                      _FilterChip(title: 'Pending', status: TripStatus.pendingOfficeApproval),
                      _FilterChip(title: 'In Progress', status: TripStatus.inProgress),
                      _FilterChip(title: 'Completed', status: TripStatus.completed),
                      _FilterChip(title: 'Cancelled', status: TripStatus.cancelled),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Trips List
          Expanded(
            child: ref.watch(tripsProvider).when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Error loading trips: $err', style: TextStyle(color: colorScheme.error)),
              ),
              data: (_) {
                if (filteredTrips.isEmpty) {
                  return const Center(child: Text('No trips found.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredTrips.length,
                  itemBuilder: (context, index) {
                    final trip = filteredTrips[index];
                    return TripCard(
                      trip: trip,
                      onTap: () {
                        context.goNamed(
                          AppRoutes.tripDetailsName,
                          pathParameters: {'id': trip.id},
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(AppRoutes.createTripName),
        icon: const Icon(Icons.add),
        label: const Text('New Trip'),
      ),
    );
  }
}

class _FilterChip extends ConsumerWidget {
  final String title;
  final TripStatus? status;

  const _FilterChip({required this.title, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(tripsStatusFilterProvider);
    final isSelected = currentFilter == status;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(title),
        selected: isSelected,
        onSelected: (selected) {
          ref.read(tripsStatusFilterProvider.notifier).state = selected ? status : null;
        },
        selectedColor: colorScheme.primaryContainer,
        checkmarkColor: colorScheme.onPrimaryContainer,
        labelStyle: TextStyle(
          color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
