import 'package:json_annotation/json_annotation.dart';

part 'reference_data.g.dart';

@JsonSerializable()
class DriverRef {
  final String id;
  final String firstName;
  final String lastName;
  final int status;

  DriverRef({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.status,
  });

  factory DriverRef.fromJson(Map<String, dynamic> json) => _$DriverRefFromJson(json);
  Map<String, dynamic> toJson() => _$DriverRefToJson(this);

  String get fullName => '$firstName $lastName';
}

@JsonSerializable()
class VehicleRef {
  final String id;
  final String plateNumber;
  final String? categoryName;
  final int status;

  VehicleRef({
    required this.id,
    required this.plateNumber,
    this.categoryName,
    required this.status,
  });

  factory VehicleRef.fromJson(Map<String, dynamic> json) => _$VehicleRefFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleRefToJson(this);

  String get displayName => '$plateNumber${categoryName != null ? ' ($categoryName)' : ''}';
}

@JsonSerializable()
class TrailerRef {
  final String id;
  final String trailerNumber;
  final String? trailerType;
  final bool isActive;

  TrailerRef({
    required this.id,
    required this.trailerNumber,
    this.trailerType,
    required this.isActive,
  });

  factory TrailerRef.fromJson(Map<String, dynamic> json) => _$TrailerRefFromJson(json);
  Map<String, dynamic> toJson() => _$TrailerRefToJson(this);

  String get displayName => '$trailerNumber${trailerType != null ? ' ($trailerType)' : ''}';
}

@JsonSerializable()
class ClientRef {
  final String id;
  final String companyName;
  final bool isActive;

  ClientRef({
    required this.id,
    required this.companyName,
    required this.isActive,
  });

  factory ClientRef.fromJson(Map<String, dynamic> json) => _$ClientRefFromJson(json);
  Map<String, dynamic> toJson() => _$ClientRefToJson(this);
}

@JsonSerializable()
class TripCategoryMaterialRef {
  final String id;
  final String tripCategoryId;
  final String categoryName;
  final String uomId;
  final String uomCode;

  TripCategoryMaterialRef({
    required this.id,
    required this.tripCategoryId,
    required this.categoryName,
    required this.uomId,
    required this.uomCode,
  });

  factory TripCategoryMaterialRef.fromJson(Map<String, dynamic> json) => _$TripCategoryMaterialRefFromJson(json);
  Map<String, dynamic> toJson() => _$TripCategoryMaterialRefToJson(this);
}
