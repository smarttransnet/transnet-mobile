import '../../data/models/vehicle_model.dart';

abstract class VehiclesRepository {
  Future<List<VehicleModel>> getVehicles();
  Future<VehicleModel> getVehicleById(String id);
  Future<String> createVehicle(Map<String, dynamic> payload);
  Future<void> updateVehicle(String id, Map<String, dynamic> payload);
  Future<void> deleteVehicle(String id);
}
