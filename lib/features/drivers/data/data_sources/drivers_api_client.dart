import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../models/driver_model.dart';

final driversApiClientProvider = Provider<DriversApiClient>((ref) {
  return DriversApiClient(ref.read(apiClientProvider));
});

class DriversApiClient {
  final ApiClient _apiClient;

  DriversApiClient(this._apiClient);

  Future<List<DriverModel>> getDrivers() async {
    final response = await _apiClient.dio.get('drivers');
    
    dynamic data = response.data;
    if (data is Map<String, dynamic>) {
      if (data.containsKey('value')) {
        data = data['value'];
      } else if (data.containsKey('items')) {
        data = data['items'];
      }
    }

    if (data is List) {
      return data.map((e) => DriverModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<DriverModel> getDriverById(String id) async {
    final response = await _apiClient.dio.get('drivers/$id');
    
    dynamic data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('value')) {
      data = data['value'];
    }
    return DriverModel.fromJson(data);
  }

  Future<String> createDriver(Map<String, dynamic> payload) async {
    final response = await _apiClient.dio.post('drivers', data: payload);
    dynamic data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('value')) {
      return data['value'].toString();
    }
    return data.toString();
  }

  Future<void> updateDriver(String id, Map<String, dynamic> payload) async {
    await _apiClient.dio.put('drivers/$id', data: payload);
  }

  Future<void> deleteDriver(String id) async {
    await _apiClient.dio.delete('drivers/$id');
  }
}
