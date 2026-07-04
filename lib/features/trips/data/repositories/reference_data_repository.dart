import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_sources/reference_data_api_client.dart';
import '../models/reference_data.dart';

final referenceDataRepositoryProvider = Provider<ReferenceDataRepository>((ref) {
  return ReferenceDataRepository(ref.read(referenceDataApiClientProvider));
});

// Provides the combined reference data for the Create Trip form
final tripReferenceDataProvider = FutureProvider.autoDispose<TripReferenceData>((ref) async {
  final repo = ref.watch(referenceDataRepositoryProvider);
  return repo.fetchAllReferenceData();
});

class TripReferenceData {
  final List<DriverRef> drivers;
  final List<VehicleRef> vehicles;
  final List<TrailerRef> trailers;
  final List<ClientRef> clients;
  final List<TripCategoryMaterialRef> categories;

  TripReferenceData({
    required this.drivers,
    required this.vehicles,
    required this.trailers,
    required this.clients,
    required this.categories,
  });
}

class ReferenceDataRepository {
  final ReferenceDataApiClient _apiClient;

  ReferenceDataRepository(this._apiClient);

  Future<TripReferenceData> fetchAllReferenceData() async {
    final drivers = (await _apiClient.getDrivers()).where((d) => d.status == 0).toList();
    final vehicles = (await _apiClient.getVehicles()).where((v) => v.status == 1).toList();
    final trailers = (await _apiClient.getTrailers()).where((t) => t.isActive).toList();
    final clients = (await _apiClient.getClients()).where((c) => c.isActive).toList();
    final categories = await _apiClient.getTripCategories();

    return TripReferenceData(
      drivers: drivers,
      vehicles: vehicles,
      trailers: trailers,
      clients: clients,
      categories: categories,
    );
  }
}
