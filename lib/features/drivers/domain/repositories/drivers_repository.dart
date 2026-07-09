import '../../data/models/driver_model.dart';

abstract class DriversRepository {
  Future<List<DriverModel>> getDrivers();
  Future<DriverModel> getDriverById(String id);
  Future<String> createDriver(Map<String, dynamic> payload);
  Future<void> updateDriver(String id, Map<String, dynamic> payload);
  Future<void> deleteDriver(String id);
}
