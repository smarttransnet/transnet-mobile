import '../../data/models/trip_model.dart';
import '../../data/models/trip_enums.dart';
import 'package:cross_file/cross_file.dart';

abstract class TripsRepository {
  Future<List<TripModel>> getTrips();
  Future<TripModel> getTripById(String id);
  Future<void> createTrip(Map<String, dynamic> payload);
  Future<void> updateTripStatus({
    required String tripId,
    required TripStatus newStatus,
    String? notes,
    required StatusChangeSource source,
    XFile? photo,
  });
}
