import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/home/presentation/screens/home_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/trips/presentation/screens/trips_screen.dart';
import '../features/trips/presentation/screens/trip_detail_screen.dart';
import '../features/trips/presentation/screens/create_trip_screen.dart';
import '../features/vehicles/presentation/screens/vehicles_screen.dart';
import '../features/vehicles/presentation/screens/vehicle_detail_screen.dart';
import '../features/vehicles/presentation/screens/vehicle_form_screen.dart';
import '../features/vehicles/data/models/vehicle_model.dart';
import '../features/drivers/presentation/screens/drivers_screen.dart';
import '../features/drivers/presentation/screens/driver_detail_screen.dart';
import '../features/drivers/presentation/screens/driver_form_screen.dart';
import '../features/drivers/data/models/driver_model.dart';
import '../core/storage/secure_storage_service.dart';

// Provide the current auth state synchronously for the router.
// In a larger app, you might use a dedicated AuthNotifier that reads from secure storage
// on startup and exposes a boolean state.
final authStateProvider = FutureProvider<bool>((ref) async {
  final storage = ref.read(secureStorageServiceProvider);
  final token = await storage.getAccessToken();
  return token != null;
});

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) async {
      final isAuth = await ref.read(authStateProvider.future);
      
      final isLoggingIn = state.matchedLocation == AppRoutes.login;

      if (!isAuth && !isLoggingIn) {
        return AppRoutes.login;
      }
      if (isAuth && isLoggingIn) {
        return AppRoutes.home;
      }

      return null; // no redirect needed
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.trips,
        name: AppRoutes.tripsName,
        builder: (context, state) => const TripsScreen(),
      ),
      GoRoute(
        path: AppRoutes.createTrip,
        name: AppRoutes.createTripName,
        builder: (context, state) => const CreateTripScreen(),
      ),
      GoRoute(
        path: AppRoutes.tripDetails,
        name: AppRoutes.tripDetailsName,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TripDetailScreen(tripId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.vehicles,
        name: AppRoutes.vehiclesName,
        builder: (context, state) => const VehiclesScreen(),
      ),
      GoRoute(
        path: AppRoutes.createVehicle,
        name: AppRoutes.createVehicleName,
        builder: (context, state) => const VehicleFormScreen(),
      ),
      GoRoute(
        path: AppRoutes.vehicleDetails,
        name: AppRoutes.vehicleDetailsName,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return VehicleDetailScreen(vehicleId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.editVehicle,
        name: AppRoutes.editVehicleName,
        builder: (context, state) {
          final vehicle = state.extra as VehicleModel?;
          return VehicleFormScreen(vehicle: vehicle);
        },
      ),
      GoRoute(
        path: AppRoutes.drivers,
        name: AppRoutes.driversName,
        builder: (context, state) => const DriversScreen(),
      ),
      GoRoute(
        path: AppRoutes.createDriver,
        name: AppRoutes.createDriverName,
        builder: (context, state) => const DriverFormScreen(),
      ),
      GoRoute(
        path: AppRoutes.driverDetails,
        name: AppRoutes.driverDetailsName,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DriverDetailScreen(driverId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.editDriver,
        name: AppRoutes.editDriverName,
        builder: (context, state) {
          final driver = state.extra as DriverModel?;
          return DriverFormScreen(driver: driver);
        },
      ),
    ],
  );
});

class AppRoutes {
  AppRoutes._();
  static const login = '/login';
  static const loginName = 'login';
  static const home = '/home';
  static const homeName = 'home';
  static const trips = '/trips';
  static const tripsName = 'trips';
  static const createTrip = '/trips/create';
  static const createTripName = 'createTrip';
  static const tripDetails = '/trips/:id';
  static const tripDetailsName = 'tripDetails';
  static const vehicles = '/vehicles';
  static const vehiclesName = 'vehicles';
  static const createVehicle = '/vehicles/create';
  static const createVehicleName = 'createVehicle';
  static const vehicleDetails = '/vehicles/:id';
  static const vehicleDetailsName = 'vehicleDetails';
  static const editVehicle = '/vehicles/:id/edit';
  static const editVehicleName = 'editVehicle';
  static const drivers = '/drivers';
  static const driversName = 'drivers';
  static const createDriver = '/drivers/create';
  static const createDriverName = 'createDriver';
  static const driverDetails = '/drivers/:id';
  static const driverDetailsName = 'driverDetails';
  static const editDriver = '/drivers/:id/edit';
  static const editDriverName = 'editDriver';
}

