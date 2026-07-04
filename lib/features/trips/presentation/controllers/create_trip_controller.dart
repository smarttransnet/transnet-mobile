import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/trips_repository_impl.dart';
import 'trips_controller.dart';

final createTripControllerProvider = NotifierProvider<CreateTripController, bool>(() {
  return CreateTripController();
});

class CreateTripController extends Notifier<bool> {
  @override
  bool build() {
    return false; // isLoading = false
  }

  Future<bool> createTrip(Map<String, dynamic> payload) async {
    state = true; // Set loading
    try {
      final repository = ref.read(tripsRepositoryProvider);
      await repository.createTrip(payload);
      
      // Invalidate trips list so it refreshes when we go back
      ref.invalidate(tripsProvider);
      
      state = false;
      return true;
    } catch (e, st) {
      state = false;
      return false;
    }
  }
}
