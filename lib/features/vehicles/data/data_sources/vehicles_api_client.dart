import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../models/vehicle_model.dart';

final vehiclesApiClientProvider = Provider<VehiclesApiClient>((ref) {
  return VehiclesApiClient(ref.read(apiClientProvider));
});

class VehiclesApiClient {
  final ApiClient _apiClient;

  VehiclesApiClient(this._apiClient);

  Future<List<VehicleModel>> getVehicles() async {
    final response = await _apiClient.dio.get('vehicles');
    
    dynamic data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('value')) {
      data = data['value'];
    }

    if (data is List) {
      return data.map((e) => VehicleModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<VehicleModel> getVehicleById(String id) async {
    final response = await _apiClient.dio.get('vehicles/$id');
    
    dynamic data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('value')) {
      data = data['value'];
    }
    return VehicleModel.fromJson(data);
  }

  Future<String> createVehicle(Map<String, dynamic> payload) async {
    final response = await _apiClient.dio.post('vehicles', data: payload);
    dynamic data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('value')) {
      return data['value'].toString();
    }
    return data.toString();
  }

  Future<void> updateVehicle(String id, Map<String, dynamic> payload) async {
    await _apiClient.dio.put('vehicles/$id', data: payload);
  }

  Future<void> deleteVehicle(String id) async {
    await _apiClient.dio.delete('vehicles/$id');
  }
}
