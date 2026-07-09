import 'package:json_annotation/json_annotation.dart';
import 'driver_status_enum.dart';

part 'driver_model.g.dart';

@JsonSerializable()
class DriverModel {
  final String id;
  final String employeeNumber;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? email;
  final String licenceNumber;
  final DateTime licenceExpiryDate;
  final String nationalityCode;
  final String? sponsorName;
  final DriverStatus status;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DriverModel({
    required this.id,
    required this.employeeNumber,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.email,
    required this.licenceNumber,
    required this.licenceExpiryDate,
    required this.nationalityCode,
    this.sponsorName,
    required this.status,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) =>
      _$DriverModelFromJson(json);

  Map<String, dynamic> toJson() => _$DriverModelToJson(this);

  String get fullName => '$firstName $lastName';
}
