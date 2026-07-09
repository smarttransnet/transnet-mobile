import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/vehicles_repository.dart';
import '../data_sources/vehicles_api_client.dart';
import '../models/vehicle_model.dart';

final vehiclesRepositoryProvider = Provider<VehiclesRepository>((ref) {
  return VehiclesRepositoryImpl(ref.read(vehiclesApiClientProvider));
});

class VehiclesRepositoryImpl implements VehiclesRepository {
  final VehiclesApiClient _apiClient;

  VehiclesRepositoryImpl(this._apiClient);

  @override
  Future<List<VehicleModel>> getVehicles() async {
    return await _apiClient.getVehicles();
  }

  @override
  Future<VehicleModel> getVehicleById(String id) async {
    return await _apiClient.getVehicleById(id);
  }

  @override
  Future<String> createVehicle(Map<String, dynamic> payload) async {
    return await _apiClient.createVehicle(payload);
  }

  @override
  Future<void> updateVehicle(String id, Map<String, dynamic> payload) async {
    await _apiClient.updateVehicle(id, payload);
  }

  @override
  Future<void> deleteVehicle(String id) async {
    await _apiClient.deleteVehicle(id);
  }
}
