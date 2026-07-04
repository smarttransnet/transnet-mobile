import 'package:json_annotation/json_annotation.dart';
import 'trip_enums.dart';

part 'trip_status_history_model.g.dart';

@JsonSerializable()
class TripStatusHistoryModel {
  final String id;
  final String tripId;
  final TripStatus previousStatus;
  final TripStatus newStatus;
  final String? changedByUserId;
  final String? changedByDriverId;
  final DateTime changedAt;
  final String? notes;
  final StatusChangeSource source;

  TripStatusHistoryModel({
    required this.id,
    required this.tripId,
    required this.previousStatus,
    required this.newStatus,
    this.changedByUserId,
    this.changedByDriverId,
    required this.changedAt,
    this.notes,
    required this.source,
  });

  factory TripStatusHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$TripStatusHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$TripStatusHistoryModelToJson(this);
}
