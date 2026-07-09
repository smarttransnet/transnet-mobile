import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../controllers/drivers_controller.dart';
import '../../../../app/router.dart';

class DriverDetailScreen extends ConsumerWidget {
  final String driverId;

  const DriverDetailScreen({super.key, required this.driverId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(driverDetailProvider(driverId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Details'),
        actions: [
          if (state.hasValue && !state.isLoading && !state.hasError) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.pushNamed(AppRoutes.editDriverName, pathParameters: {'id': driverId}, extra: state.value);
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
        data: (driver) {
          final dateFormat = DateFormat('yyyy-MM-dd');
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildDetailRow('Employee Number', driver.employeeNumber),
              _buildDetailRow('Full Name', driver.fullName),
              _buildDetailRow('Phone Number', driver.phoneNumber ?? 'N/A'),
              _buildDetailRow('Email', driver.email ?? 'N/A'),
              _buildDetailRow('Licence Number', driver.licenceNumber),
              _buildDetailRow('Licence Expiry', dateFormat.format(driver.licenceExpiryDate)),
              _buildDetailRow('Nationality Code', driver.nationalityCode),
              _buildDetailRow('Sponsor', driver.sponsorName ?? 'N/A'),
              _buildDetailRow('Status', driver.status.name),
              _buildDetailRow('Is Active', driver.isActive ? 'Yes' : 'No'),
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
        title: const Text('Delete Driver'),
        content: const Text('Are you sure you want to delete this driver?'),
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
      await ref.read(driverDeleterProvider).deleteDriver(driverId);
      if (context.mounted) {
        context.pop();
      }
    }
  }
}
