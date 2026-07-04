import 'package:flutter/material.dart';
import '../../data/models/trip_enums.dart';

class StatusBadge extends StatelessWidget {
  final TripStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case TripStatus.scheduled:
        backgroundColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue.shade700;
        text = 'Scheduled';
        break;
      case TripStatus.inProgress:
        backgroundColor = Colors.indigo.withValues(alpha: 0.1);
        textColor = Colors.indigo.shade700;
        text = 'In Progress';
        break;
      case TripStatus.onHalt:
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange.shade700;
        text = 'On Halt';
        break;
      case TripStatus.completed:
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green.shade700;
        text = 'Completed';
        break;
      case TripStatus.pendingDriverConfirmation:
        backgroundColor = Colors.amber.withValues(alpha: 0.1);
        textColor = Colors.amber.shade800;
        text = 'Pending Driver';
        break;
      case TripStatus.pendingOfficeApproval:
        backgroundColor = Colors.amber.withValues(alpha: 0.1);
        textColor = Colors.amber.shade800;
        text = 'Pending Office';
        break;
      case TripStatus.cancelled:
      case TripStatus.deleted:
        backgroundColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red.shade700;
        text = 'Cancelled';
        break;
      case TripStatus.invoiced:
        backgroundColor = Colors.teal.withValues(alpha: 0.1);
        textColor = Colors.teal.shade700;
        text = 'Invoiced';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
