import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/trip_model.dart';
import 'status_badge.dart';

class TripCard extends StatelessWidget {
  final TripModel trip;
  final VoidCallback onTap;

  const TripCard({super.key, required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    trip.tripNumber,
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  StatusBadge(status: trip.status),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 20, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(trip.origin ?? 'Unknown Origin', style: textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                  ),
                  Expanded(child: Text(trip.destination ?? 'Unknown Destination', style: textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoItem(
                    icon: Icons.person_outline,
                    text: trip.driverName ?? 'Unassigned',
                  ),
                  _InfoItem(
                    icon: Icons.directions_car_outlined,
                    text: trip.vehiclePlateNumber ?? trip.vehicleRegistrationNumber ?? 'N/A',
                  ),
                  _InfoItem(
                    icon: Icons.calendar_today_outlined,
                    text: DateFormat('MMM dd, yyyy').format(trip.scheduledStartAt),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
