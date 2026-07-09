import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/drivers_repository.dart';
import '../data_sources/drivers_api_client.dart';
import '../models/driver_model.dart';

final driversRepositoryProvider = Provider<DriversRepository>((ref) {
  return DriversRepositoryImpl(ref.read(driversApiClientProvider));
});

class DriversRepositoryImpl implements DriversRepository {
  final DriversApiClient _apiClient;

  DriversRepositoryImpl(this._apiClient);

  @override
  Future<List<DriverModel>> getDrivers() async {
    return await _apiClient.getDrivers();
  }

  @override
  Future<DriverModel> getDriverById(String id) async {
    return await _apiClient.getDriverById(id);
  }

  @override
  Future<String> createDriver(Map<String, dynamic> payload) async {
    return await _apiClient.createDriver(payload);
  }

  @override
  Future<void> updateDriver(String id, Map<String, dynamic> payload) async {
    await _apiClient.updateDriver(id, payload);
  }

  @override
  Future<void> deleteDriver(String id) async {
    await _apiClient.deleteDriver(id);
  }
}
