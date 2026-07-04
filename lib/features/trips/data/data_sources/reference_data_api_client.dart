import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../models/reference_data.dart';

final referenceDataApiClientProvider = Provider<ReferenceDataApiClient>((ref) {
  return ReferenceDataApiClient(ref.read(apiClientProvider));
});

class ReferenceDataApiClient {
  final ApiClient _apiClient;

  ReferenceDataApiClient(this._apiClient);

  Future<List<DriverRef>> getDrivers() async {
    final response = await _apiClient.dio.get('drivers', queryParameters: {'pageSize': 1000});
    return _extractList(response.data, (json) => DriverRef.fromJson(json));
  }

  Future<List<VehicleRef>> getVehicles() async {
    final response = await _apiClient.dio.get('vehicles', queryParameters: {'pageSize': 1000});
    return _extractList(response.data, (json) => VehicleRef.fromJson(json));
  }

  Future<List<TrailerRef>> getTrailers() async {
    final response = await _apiClient.dio.get('trailers', queryParameters: {'pageSize': 1000});
    return _extractList(response.data, (json) => TrailerRef.fromJson(json));
  }

  Future<List<ClientRef>> getClients() async {
    final response = await _apiClient.dio.get('clients', queryParameters: {'pageSize': 1000});
    return _extractList(response.data, (json) => ClientRef.fromJson(json));
  }

  Future<List<TripCategoryMaterialRef>> getTripCategories() async {
    // Web app calls tripCategoryApi.getTripCategories({ isActive: true, pageSize: 1000 })
    final response = await _apiClient.dio.get('api/trip-categories', queryParameters: {
      'isActive': true,
      'pageSize': 1000,
    });
    
    dynamic listData = response.data;
    if (listData is Map<String, dynamic>) {
      if (listData.containsKey('value')) listData = listData['value'];
    }
    if (listData is Map<String, dynamic> && listData.containsKey('items')) {
      listData = listData['items'];
    }

    if (listData is! List) return [];

    final List<TripCategoryMaterialRef> flattenedList = [];

    for (var category in listData) {
      if (category is! Map<String, dynamic>) continue;
      
      final categoryId = category['categoryId'] as String?;
      final categoryName = category['categoryName'] as String?;
      final uoms = category['uoms'];
      
      if (categoryId == null || categoryName == null || uoms is! List) continue;

      for (var uom in uoms) {
        if (uom is! Map<String, dynamic>) continue;
        
        flattenedList.add(TripCategoryMaterialRef(
          id: uom['mappingId'] as String? ?? '',
          tripCategoryId: categoryId,
          categoryName: categoryName,
          uomId: uom['uomId'] as String? ?? '',
          uomCode: uom['uomCode'] as String? ?? '',
        ));
      }
    }

    return flattenedList;
  }

  List<T> _extractList<T>(dynamic data, T Function(Map<String, dynamic>) fromJson) {
    dynamic listData = data;
    
    // Handle standard generic wrapper
    if (listData is Map<String, dynamic>) {
      if (listData.containsKey('value')) {
        listData = listData['value'];
      }
    }
    
    // Handle paginated responses which typically have 'items'
    if (listData is Map<String, dynamic> && listData.containsKey('items')) {
      listData = listData['items'];
    }

    if (listData is List) {
      return listData.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    }
    
    return [];
  }
}
