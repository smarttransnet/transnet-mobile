import 'package:json_annotation/json_annotation.dart';
import 'vehicle_type_enum.dart';
import 'vehicle_status_enum.dart';

part 'vehicle_model.g.dart';

@JsonSerializable()
class VehicleModel {
  final String id;
  final String chassisNumber;
  final String plateNumber;
  final String make;
  final String model;
  final int year;
  final String vehicleCategoryId;
  final String? categoryName;
  final VehicleType vehicleType;
  final VehicleStatus status;
  final String? currentDriverId;
  final String? currentLocationId;
  final double odometerReading;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VehicleModel({
    required this.id,
    required this.chassisNumber,
    required this.plateNumber,
    required this.make,
    required this.model,
    required this.year,
    required this.vehicleCategoryId,
    this.categoryName,
    required this.vehicleType,
    required this.status,
    this.currentDriverId,
    this.currentLocationId,
    required this.odometerReading,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);
}
