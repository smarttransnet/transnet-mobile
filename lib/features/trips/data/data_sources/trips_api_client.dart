import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cross_file/cross_file.dart';

import '../../../../core/network/api_client.dart';
import '../models/trip_model.dart';
import '../models/trip_enums.dart';

final tripsApiClientProvider = Provider<TripsApiClient>((ref) {
  return TripsApiClient(ref.read(apiClientProvider));
});

class TripsApiClient {
  final ApiClient _apiClient;

  TripsApiClient(this._apiClient);

  Future<List<TripModel>> getTrips() async {
    final response = await _apiClient.dio.get(
      'trips',
      queryParameters: {'_t': DateTime.now().millisecondsSinceEpoch},
      options: Options(headers: {'Cache-Control': 'no-cache', 'Pragma': 'no-cache'}),
    );
    
    // Minimal APIs might wrap arrays in Ok(value), check if it's a map with 'value'
    dynamic data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('value')) {
      data = data['value'];
    }

    if (data is List) {
      return data.map((e) => TripModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<TripModel> getTripById(String id) async {
    final response = await _apiClient.dio.get(
      'trips/$id',
      queryParameters: {'_t': DateTime.now().millisecondsSinceEpoch},
      options: Options(headers: {'Cache-Control': 'no-cache', 'Pragma': 'no-cache'}),
    );
    
    dynamic data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('value')) {
      data = data['value'];
    }
    return TripModel.fromJson(data);
  }

  Future<void> createTrip(Map<String, dynamic> payload) async {
    await _apiClient.dio.post('trips', data: payload);
  }

  Future<void> updateTripStatus({
    required String tripId,
    required TripStatus newStatus,
    String? notes,
    required StatusChangeSource source,
    XFile? photo,
  }) async {
    final payload = {
      'newStatus': _statusToInt(newStatus),
      'source': _sourceToInt(source),
      if (notes != null) 'notes': notes,
    };

    // Note: The backend TransitionTripStatus endpoint only accepts JSON and does not handle photo uploads.
    // If photo upload is required later, a separate endpoint will be needed.

    await _apiClient.dio.put(
      'trips/$tripId/status',
      data: payload,
    );
  }

  int _statusToInt(TripStatus status) {
    switch (status) {
      case TripStatus.scheduled: return 1;
      case TripStatus.inProgress: return 2;
      case TripStatus.onHalt: return 3;
      case TripStatus.completed: return 4;
      case TripStatus.pendingDriverConfirmation: return 5;
      case TripStatus.pendingOfficeApproval: return 6;
      case TripStatus.cancelled: return 7;
      case TripStatus.invoiced: return 8;
      case TripStatus.deleted: return 9;
    }
  }

  int _sourceToInt(StatusChangeSource source) {
    switch (source) {
      case StatusChangeSource.driverApp: return 1;
      case StatusChangeSource.officePortal: return 2;
      case StatusChangeSource.systemAuto: return 3;
      case StatusChangeSource.bulkImport: return 4;
    }
  }
}
