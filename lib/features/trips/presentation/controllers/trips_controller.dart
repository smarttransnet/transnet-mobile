import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/trips_repository_impl.dart';
import '../../data/models/trip_model.dart';
import '../../data/models/trip_enums.dart';

class TripsSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
}

final tripsSearchQueryProvider = NotifierProvider<TripsSearchQueryNotifier, String>(() {
  return TripsSearchQueryNotifier();
});

class TripsStatusFilterNotifier extends Notifier<TripStatus?> {
  @override
  TripStatus? build() => null;
}

final tripsStatusFilterProvider = NotifierProvider<TripsStatusFilterNotifier, TripStatus?>(() {
  return TripsStatusFilterNotifier();
});

final tripsProvider = FutureProvider<List<TripModel>>((ref) async {
  final repository = ref.watch(tripsRepositoryProvider);
  return await repository.getTrips();
});

final filteredTripsProvider = Provider<List<TripModel>>((ref) {
  final tripsAsync = ref.watch(tripsProvider);
  final searchQuery = ref.watch(tripsSearchQueryProvider).toLowerCase();
  final statusFilter = ref.watch(tripsStatusFilterProvider);

  return tripsAsync.maybeWhen(
    data: (trips) {
      final filtered = trips.where((trip) {
        final matchesSearch = trip.tripNumber.toLowerCase().contains(searchQuery) ||
                              (trip.origin?.toLowerCase().contains(searchQuery) ?? false) ||
                              (trip.destination?.toLowerCase().contains(searchQuery) ?? false);
        final matchesStatus = statusFilter == null || trip.status == statusFilter;
        return matchesSearch && matchesStatus;
      }).toList();
      
      filtered.sort((a, b) => b.scheduledStartAt.compareTo(a.scheduledStartAt));
      return filtered;
    },
    orElse: () => [],
  );
});
