import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/vehicle_model.dart';
import '../../data/repositories/vehicles_repository_impl.dart';
import 'vehicles_controller.dart';

final vehicleDetailProvider = FutureProvider.family<VehicleModel, String>((ref, id) async {
  final repository = ref.watch(vehiclesRepositoryProvider);
  return await repository.getVehicleById(id);
});

class VehicleDeleter {
  final Ref ref;

  VehicleDeleter(this.ref);

  Future<void> deleteVehicle(String id) async {
    final repository = ref.read(vehiclesRepositoryProvider);
    await repository.deleteVehicle(id);
    ref.invalidate(vehiclesProvider);
  }
}

final vehicleDeleterProvider = Provider<VehicleDeleter>((ref) {
  return VehicleDeleter(ref);
});
