import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/driver_model.dart';
import '../../data/repositories/drivers_repository_impl.dart';

final driversProvider = FutureProvider<List<DriverModel>>((ref) async {
  final repository = ref.watch(driversRepositoryProvider);
  return await repository.getDrivers();
});

final driverDetailProvider = FutureProvider.family<DriverModel, String>((ref, id) async {
  final repository = ref.watch(driversRepositoryProvider);
  return await repository.getDriverById(id);
});

class DriverDeleter {
  final Ref ref;

  DriverDeleter(this.ref);

  Future<void> deleteDriver(String id) async {
    final repository = ref.read(driversRepositoryProvider);
    await repository.deleteDriver(id);
    ref.invalidate(driversProvider);
  }
}

final driverDeleterProvider = Provider<DriverDeleter>((ref) {
  return DriverDeleter(ref);
});

class DriverFormController {
  final Ref ref;

  DriverFormController(this.ref);

  Future<bool> createDriver(Map<String, dynamic> payload) async {
    try {
      final repository = ref.read(driversRepositoryProvider);
      await repository.createDriver(payload);
      ref.invalidate(driversProvider);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDriver(String id, Map<String, dynamic> payload) async {
    try {
      final repository = ref.read(driversRepositoryProvider);
      await repository.updateDriver(id, payload);
      ref.invalidate(driversProvider);
      ref.invalidate(driverDetailProvider(id));
      return true;
    } catch (e) {
      return false;
    }
  }
}

final driverFormProvider = Provider<DriverFormController>((ref) {
  return DriverFormController(ref);
});
