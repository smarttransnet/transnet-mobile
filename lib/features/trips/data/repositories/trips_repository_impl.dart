import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cross_file/cross_file.dart';

import '../../domain/repositories/trips_repository.dart';
import '../data_sources/trips_api_client.dart';
import '../models/trip_model.dart';
import '../models/trip_enums.dart';

final tripsRepositoryProvider = Provider<TripsRepository>((ref) {
  return TripsRepositoryImpl(ref.read(tripsApiClientProvider));
});

class TripsRepositoryImpl implements TripsRepository {
  final TripsApiClient _apiClient;

  TripsRepositoryImpl(this._apiClient);

  @override
  Future<List<TripModel>> getTrips() {
    return _apiClient.getTrips();
  }

  @override
  Future<TripModel> getTripById(String id) {
    return _apiClient.getTripById(id);
  }

  @override
  Future<void> createTrip(Map<String, dynamic> payload) {
    return _apiClient.createTrip(payload);
  }

  @override
  Future<void> updateTripStatus({
    required String tripId,
    required TripStatus newStatus,
    String? notes,
    required StatusChangeSource source,
    XFile? photo,
  }) {
    return _apiClient.updateTripStatus(
      tripId: tripId,
      newStatus: newStatus,
      notes: notes,
      source: source,
      photo: photo,
    );
  }
}
