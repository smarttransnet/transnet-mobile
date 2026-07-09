import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../controllers/trip_detail_controller.dart';
import '../widgets/status_badge.dart';
import '../../data/models/trip_enums.dart';
import '../../data/models/trip_model.dart';

class TripDetailScreen extends ConsumerStatefulWidget {
  final String tripId;

  const TripDetailScreen({super.key, required this.tripId});

  @override
  ConsumerState<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen> {
  final _meterReadingController = TextEditingController();
  final _commentController = TextEditingController();
  XFile? _workflowPhoto;
  bool _actionLoading = false;

  @override
  void dispose() {
    _meterReadingController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _workflowPhoto = image;
      });
    }
  }

  Future<void> _performAction(Future<void> Function() action) async {
    try {
      setState(() => _actionLoading = true);
      await action();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Action failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _actionLoading = false);
      }
    }
  }

  void _handleStartWorkflow(TripModel trip) {
    _performAction(() async {
      final success = await ref.read(tripStatusUpdaterProvider).updateStatus(
            trip.id,
            TripStatus.inProgress,
            notes: 'Start Meter: ${_meterReadingController.text}',
            photo: _workflowPhoto,
          );
      if (success && mounted) {
        _meterReadingController.clear();
        setState(() => _workflowPhoto = null);
        context.go('/trips');
      }
    });
  }

  void _handlePickedUpWorkflow(TripModel trip) {
    _performAction(() async {
      final notes = _commentController.text.isNotEmpty
          ? 'Picked up goods. Notes: ${_commentController.text}'
          : 'Picked up goods.';
      final success = await ref.read(tripStatusUpdaterProvider).updateStatus(
            trip.id,
            TripStatus.onHalt,
            notes: notes,
            photo: _workflowPhoto,
          );
      if (success && mounted) {
        _commentController.clear();
        setState(() => _workflowPhoto = null);
        context.go('/trips');
      }
    });
  }

  void _handleCompleteDeliveryWorkflow(TripModel trip) {
    _performAction(() async {
      final success = await ref.read(tripStatusUpdaterProvider).updateStatus(
            trip.id,
            TripStatus.pendingOfficeApproval,
            notes: 'Receiver Comment: ${_commentController.text}',
            photo: _workflowPhoto,
          );
      if (success && mounted) {
        _commentController.clear();
        setState(() => _workflowPhoto = null);
        context.go('/trips');
      }
    });
  }

  void _handleFinishWorkflow(TripModel trip) {
    _performAction(() async {
      final success = await ref.read(tripStatusUpdaterProvider).updateStatus(
            trip.id,
            TripStatus.pendingOfficeApproval,
            notes: 'Final Meter: ${_meterReadingController.text}',
            photo: _workflowPhoto,
          );
      if (success && mounted) {
        _meterReadingController.clear();
        setState(() => _workflowPhoto = null);
        context.go('/trips');
      }
    });
  }

  Widget _buildWorkflowCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<Widget> children,
    Color? borderColor,
    Color? backgroundColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? colorScheme.surface,
          border: Border(
            left: BorderSide(
              color: borderColor ?? colorScheme.primary,
              width: 5,
            ),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: borderColor ?? colorScheme.primary,
                  ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _renderWorkflowActionPanel(TripModel trip, BuildContext context) {
    final bool isFinalMeterSubmitted = trip.statusHistory.any((h) =>
        h.newStatus == TripStatus.pendingOfficeApproval &&
        (h.notes?.contains('Final Meter:') ?? false));

    switch (trip.status) {
      case TripStatus.scheduled:
        return _buildWorkflowCard(
          context: context,
          title: 'Workflow Stage 1: Trip Dispatch',
          subtitle: 'This action must be completed before starting the vehicle.',
          children: [
            TextField(
              controller: _meterReadingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Current Meter Reading',
                hintText: 'Enter current odometer reading...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.cloud_upload),
              label: Text(_workflowPhoto != null
                  ? _workflowPhoto!.name
                  : 'Take/Upload Photo (Optional)'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _actionLoading ? null : () => _handleStartWorkflow(trip),
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _actionLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Start Trip', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _actionLoading ? null : () => context.go('/trips'),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Cancel / Go Back', style: TextStyle(fontSize: 16)),
            ),
          ],
        );

      case TripStatus.inProgress:
        return _buildWorkflowCard(
          context: context,
          title: 'Workflow Stage 2: Pick Up Goods',
          subtitle: 'Please confirm the items have been picked up and are ready for delivery.',
          children: [
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Comment / Notes',
                hintText: 'Enter any notes about the pickup...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.cloud_upload),
              label: Text(_workflowPhoto != null
                  ? _workflowPhoto!.name
                  : 'Take/Upload Photo (Optional)'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _actionLoading ? null : () => _handlePickedUpWorkflow(trip),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
              ),
              child: _actionLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Picked up goods', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _actionLoading ? null : () => context.go('/trips'),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Cancel / Go Back', style: TextStyle(fontSize: 16)),
            ),
          ],
        );

      case TripStatus.onHalt:
        return _buildWorkflowCard(
          context: context,
          title: 'Workflow Stage 3: Arrived at Destination / Unloading',
          subtitle: 'Enter any feedback or comment to complete the delivery.',
          children: [
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Comment / Notes',
                hintText: 'Enter any comment from the receiver...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.cloud_upload),
              label: Text(_workflowPhoto != null
                  ? _workflowPhoto!.name
                  : 'Take/Upload Photo (Optional)'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _actionLoading ? null : () => _handleCompleteDeliveryWorkflow(trip),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
              ),
              child: _actionLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Complete Delivery', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _actionLoading ? null : () => context.go('/trips'),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Cancel / Go Back', style: TextStyle(fontSize: 16)),
            ),
          ],
        );

      case TripStatus.pendingOfficeApproval:
        if (!isFinalMeterSubmitted) {
          return _buildWorkflowCard(
            context: context,
            title: 'Workflow Stage 4: Final Return (Arrived to Office)',
            subtitle: 'Enter the final vehicle odometer reading to finish the trip.',
            children: [
              TextField(
                controller: _meterReadingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Final Odometer Reading',
                  hintText: 'Enter final odometer reading...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.cloud_upload),
                label: Text(_workflowPhoto != null
                    ? _workflowPhoto!.name
                    : 'Take/Upload Photo (Optional)'),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _actionLoading ? null : () => _handleFinishWorkflow(trip),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
                child: _actionLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Finish Trip', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _actionLoading ? null : () => context.go('/trips'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Cancel / Go Back', style: TextStyle(fontSize: 16)),
              ),
            ],
          );
        } else {
          return _buildWorkflowCard(
            context: context,
            title: 'Trip Status: Pending Office Approval',
            subtitle: 'The workflow for this trip has been completed and is now waiting for office approval.',
            borderColor: Colors.grey,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            children: [
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/trips'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Back to Trips', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          );
        }

      case TripStatus.completed:
        return _buildWorkflowCard(
          context: context,
          title: 'Trip Status: Completed',
          subtitle: 'The workflow for this trip has been completed and is now closed.',
          borderColor: Colors.grey,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          children: [
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go('/trips'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Back to Trips', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        );

      default:
        return _buildWorkflowCard(
          context: context,
          title: 'Trip Status: ${trip.status.name}',
          subtitle: 'The workflow for this trip has been closed.',
          borderColor: Colors.grey,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          children: [
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go('/trips'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Back to Trips', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        );
    }
  }

  String? _getMilestoneTime(TripModel trip, TripStatus targetStatus, {bool isFinalMeter = false}) {
    if (targetStatus == TripStatus.pendingOfficeApproval) {
      if (isFinalMeter) {
        final h = trip.statusHistory.where((h) => 
            h.newStatus == TripStatus.pendingOfficeApproval && 
            (h.notes?.contains('Final Meter:') ?? false)).lastOrNull;
        return h != null ? DateFormat('MMM dd, HH:mm').format(h.changedAt) : null;
      } else {
        final h = trip.statusHistory.where((h) => 
            h.newStatus == TripStatus.pendingOfficeApproval && 
            !(h.notes?.contains('Final Meter:') ?? false)).lastOrNull;
        return h != null ? DateFormat('MMM dd, HH:mm').format(h.changedAt) : null;
      }
    }

    final historyRecord = trip.statusHistory.where((h) => h.newStatus == targetStatus).lastOrNull;
    if (historyRecord != null) {
      return DateFormat('MMM dd, HH:mm').format(historyRecord.changedAt);
    }
    if (targetStatus == TripStatus.inProgress && trip.actualStartAt != null) {
      return DateFormat('MMM dd, HH:mm').format(trip.actualStartAt!);
    }
    if (targetStatus == TripStatus.completed && trip.actualEndAt != null) {
      return DateFormat('MMM dd, HH:mm').format(trip.actualEndAt!);
    }
    return null;
  }

  Widget _buildMilestone({
    required BuildContext context,
    required String title,
    required String? time,
    required String pendingText,
    required bool isFirst,
    required bool isLast,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = time != null;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : colorScheme.outlineVariant,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isCompleted ? colorScheme.onSurface : colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCompleted ? 'Completed At: $time' : pendingText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isCompleted ? colorScheme.onSurfaceVariant : colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(tripDetailProvider(widget.tripId));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
      ),
      body: tripAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: TextStyle(color: colorScheme.error)),
        ),
        data: (trip) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trip ${trip.tripNumber}',
                            style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Created ${DateFormat.yMMMd().format(trip.createdAt)}',
                            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    StatusBadge(status: trip.status),
                  ],
                ),
                const SizedBox(height: 24),

                // Workflow Action Panel
                _renderWorkflowActionPanel(trip, context),

                // Trip Milestones
                Text('Trip Milestones', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildMilestone(
                  context: context,
                  title: '1. Trip Scheduled',
                  time: DateFormat('MMM dd, HH:mm').format(trip.scheduledStartAt),
                  pendingText: '',
                  isFirst: true,
                  isLast: false,
                ),
                _buildMilestone(
                  context: context,
                  title: '2. Trip Started',
                  time: _getMilestoneTime(trip, TripStatus.inProgress),
                  pendingText: 'Pending start',
                  isFirst: false,
                  isLast: false,
                ),
                _buildMilestone(
                  context: context,
                  title: '3. Goods Picked Up / Delivering',
                  time: _getMilestoneTime(trip, TripStatus.onHalt),
                  pendingText: 'Pending pick up',
                  isFirst: false,
                  isLast: false,
                ),
                _buildMilestone(
                  context: context,
                  title: '4. Delivery Completed',
                  time: _getMilestoneTime(trip, TripStatus.pendingOfficeApproval, isFinalMeter: false),
                  pendingText: 'Pending delivery completion',
                  isFirst: false,
                  isLast: false,
                ),
                _buildMilestone(
                  context: context,
                  title: '5. Trip Finished',
                  time: _getMilestoneTime(trip, TripStatus.pendingOfficeApproval, isFinalMeter: true),
                  pendingText: 'Pending final return',
                  isFirst: false,
                  isLast: false,
                ),
                _buildMilestone(
                  context: context,
                  title: '6. Trip Approved (Completed)',
                  time: _getMilestoneTime(trip, TripStatus.completed),
                  pendingText: 'Pending office approval',
                  isFirst: false,
                  isLast: true,
                ),

                const SizedBox(height: 32),
                // Details Grid
                Text('Trip Information', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _InfoCard(
                  children: [
                    _DetailRow(label: 'Origin', value: trip.origin ?? 'Unknown'),
                    _DetailRow(label: 'Destination', value: trip.destination ?? 'Unknown'),
                    _DetailRow(
                      label: 'Scheduled Start',
                      value: DateFormat('MMM dd, yyyy HH:mm').format(trip.scheduledStartAt),
                    ),
                    _DetailRow(label: 'Driver', value: trip.driverName ?? 'Unassigned'),
                    _DetailRow(label: 'Vehicle', value: trip.vehiclePlateNumber ?? trip.vehicleRegistrationNumber ?? 'N/A'),
                    _DetailRow(label: 'Quantity', value: trip.quantity != null ? '${trip.quantity} ${trip.uomCode ?? ''}' : 'N/A'),
                    _DetailRow(label: 'Client', value: trip.clientName ?? 'N/A'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
