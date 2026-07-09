// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) => VehicleModel(
  id: json['id'] as String,
  chassisNumber: json['chassisNumber'] as String,
  plateNumber: json['plateNumber'] as String,
  make: json['make'] as String,
  model: json['model'] as String,
  year: (json['year'] as num).toInt(),
  vehicleCategoryId: json['vehicleCategoryId'] as String,
  categoryName: json['categoryName'] as String?,
  vehicleType: $enumDecode(_$VehicleTypeEnumMap, json['vehicleType']),
  status: $enumDecode(_$VehicleStatusEnumMap, json['status']),
  currentDriverId: json['currentDriverId'] as String?,
  currentLocationId: json['currentLocationId'] as String?,
  odometerReading: (json['odometerReading'] as num).toDouble(),
  isActive: json['isActive'] as bool,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$VehicleModelToJson(VehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chassisNumber': instance.chassisNumber,
      'plateNumber': instance.plateNumber,
      'make': instance.make,
      'model': instance.model,
      'year': instance.year,
      'vehicleCategoryId': instance.vehicleCategoryId,
      'categoryName': instance.categoryName,
      'vehicleType': _$VehicleTypeEnumMap[instance.vehicleType]!,
      'status': _$VehicleStatusEnumMap[instance.status]!,
      'currentDriverId': instance.currentDriverId,
      'currentLocationId': instance.currentLocationId,
      'odometerReading': instance.odometerReading,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$VehicleTypeEnumMap = {VehicleType.truck: 1, VehicleType.trailer: 2};

const _$VehicleStatusEnumMap = {
  VehicleStatus.active: 1,
  VehicleStatus.maintenance: 2,
  VehicleStatus.outOfService: 3,
  VehicleStatus.sold: 4,
};
