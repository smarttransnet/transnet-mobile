import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/vehicle_model.dart';
import '../../data/repositories/vehicles_repository_impl.dart';

final vehiclesProvider = FutureProvider<List<VehicleModel>>((ref) async {
  final repository = ref.watch(vehiclesRepositoryProvider);
  return await repository.getVehicles();
});
