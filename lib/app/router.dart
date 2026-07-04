import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/home/presentation/screens/home_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/trips/presentation/screens/trips_screen.dart';
import '../features/trips/presentation/screens/trip_detail_screen.dart';
import '../features/trips/presentation/screens/create_trip_screen.dart';
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
}

