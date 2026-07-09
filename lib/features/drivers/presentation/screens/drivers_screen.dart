import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';
import '../../../../core/presentation/widgets/app_drawer.dart';
import '../controllers/drivers_controller.dart';

class DriversScreen extends ConsumerWidget {
  const DriversScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(driversProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drivers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(driversProvider),
          ),
        ],
      ),
      drawer: const AppDrawer(currentRouteName: AppRoutes.driversName),
      body: state.when(
        data: (drivers) {
          if (drivers.isEmpty) {
            return const Center(child: Text('No drivers found.'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(driversProvider),
            child: ListView.builder(
              itemCount: drivers.length,
              itemBuilder: (context, index) {
                final driver = drivers[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(driver.fullName),
                  subtitle: Text('Employee No: ${driver.employeeNumber}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.pushNamed(
                      AppRoutes.driverDetailsName,
                      pathParameters: {'id': driver.id},
                    );
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(AppRoutes.createDriverName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
