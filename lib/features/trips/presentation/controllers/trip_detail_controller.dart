import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/trips_repository_impl.dart';
import '../../data/models/trip_model.dart';
import '../../data/models/trip_enums.dart';
import 'trips_controller.dart';

import 'package:cross_file/cross_file.dart';

final tripDetailProvider = FutureProvider.family<TripModel, String>((ref, id) async {
  final repository = ref.watch(tripsRepositoryProvider);
  return await repository.getTripById(id);
});

class TripStatusUpdater {
  final Ref ref;

  TripStatusUpdater(this.ref);

  Future<bool> updateStatus(String tripId, TripStatus newStatus, {String? notes, XFile? photo}) async {
      final repository = ref.read(tripsRepositoryProvider);
      await repository.updateTripStatus(
        tripId: tripId,
        newStatus: newStatus,
        notes: notes,
        source: StatusChangeSource.driverApp,
        photo: photo,
      );
      
      // Refresh the trip details and trips list
      ref.invalidate(tripDetailProvider(tripId));
      ref.invalidate(tripsProvider);
      return true;
  }
}

final tripStatusUpdaterProvider = Provider<TripStatusUpdater>((ref) {
  return TripStatusUpdater(ref);
});
