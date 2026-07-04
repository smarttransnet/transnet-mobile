import 'package:json_annotation/json_annotation.dart';
import 'trip_enums.dart';
import 'trip_status_history_model.dart';

part 'trip_model.g.dart';

@JsonSerializable()
class TripModel {
  final String id;
  final String tripNumber;
  final String driverId;
  final String vehicleId;
  final String? trailerId;
  final TripStatus status;
  final DateTime scheduledStartAt;
  final DateTime? actualStartAt;
  final DateTime? actualEndAt;
  final double? totalDistanceKm;
  final bool isImported;
  final String? importBatchId;
  final String? origin;
  final String? destination;
  final DateTime? driverConfirmedAt;
  final DateTime? officeApprovedAt;
  final String? officeApprovedByUserId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? driverName;
  final String? vehicleRegistrationNumber;
  final String? clientName;
  final String? clientId;
  final String? responseVersion;
  final String? vehiclePlateNumber;
  final String? vehicleCategoryName;
  final String? tripCategoryMaterialId;
  final String? categoryName;
  final String? uomCode;
  final double? quantity;
  final List<TripStatusHistoryModel> statusHistory;

  TripModel({
    required this.id,
    required this.tripNumber,
    required this.driverId,
    required this.vehicleId,
    this.trailerId,
    required this.status,
    required this.scheduledStartAt,
    this.actualStartAt,
    this.actualEndAt,
    this.totalDistanceKm,
    required this.isImported,
    this.importBatchId,
    this.origin,
    this.destination,
    this.driverConfirmedAt,
    this.officeApprovedAt,
    this.officeApprovedByUserId,
    required this.createdAt,
    required this.updatedAt,
    this.driverName,
    this.vehicleRegistrationNumber,
    this.clientName,
    this.clientId,
    this.responseVersion,
    this.vehiclePlateNumber,
    this.vehicleCategoryName,
    this.tripCategoryMaterialId,
    this.categoryName,
    this.uomCode,
    this.quantity,
    this.statusHistory = const [],
  });

  factory TripModel.fromJson(Map<String, dynamic> json) =>
      _$TripModelFromJson(json);

  Map<String, dynamic> toJson() => _$TripModelToJson(this);
}
