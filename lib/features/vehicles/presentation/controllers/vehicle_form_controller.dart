import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/vehicles_repository_impl.dart';
import 'vehicles_controller.dart';
import 'vehicle_detail_controller.dart';

class VehicleFormController {
  final Ref ref;

  VehicleFormController(this.ref);

  Future<bool> createVehicle(Map<String, dynamic> payload) async {
    try {
      final repository = ref.read(vehiclesRepositoryProvider);
      await repository.createVehicle(payload);
      ref.invalidate(vehiclesProvider);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateVehicle(String id, Map<String, dynamic> payload) async {
    try {
      final repository = ref.read(vehiclesRepositoryProvider);
      await repository.updateVehicle(id, payload);
      ref.invalidate(vehiclesProvider);
      ref.invalidate(vehicleDetailProvider(id));
      return true;
    } catch (e) {
      return false;
    }
  }
}

final vehicleFormProvider = Provider<VehicleFormController>((ref) {
  return VehicleFormController(ref);
});
