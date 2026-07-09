import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/vehicle_detail_controller.dart';
import '../../../../app/router.dart';

class VehicleDetailScreen extends ConsumerWidget {
  final String vehicleId;

  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vehicleDetailProvider(vehicleId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
        actions: [
          if (state.hasValue && !state.isLoading && !state.hasError) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.pushNamed(AppRoutes.editVehicleName, pathParameters: {'id': vehicleId}, extra: state.value);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ]
        ],
      ),
      body: state.when(
        data: (vehicle) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildDetailRow('Plate Number', vehicle.plateNumber),
              _buildDetailRow('Chassis Number', vehicle.chassisNumber),
              _buildDetailRow('Make', vehicle.make),
              _buildDetailRow('Model', vehicle.model),
              _buildDetailRow('Year', vehicle.year.toString()),
              _buildDetailRow('Status', vehicle.status.name),
              _buildDetailRow('Odometer', '${vehicle.odometerReading} km'),
              _buildDetailRow('Is Active', vehicle.isActive ? 'Yes' : 'No'),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
          const Divider(),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: const Text('Are you sure you want to delete this vehicle?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(vehicleDeleterProvider).deleteVehicle(vehicleId);
      if (context.mounted) {
        context.pop();
      }
    }
  }
}
