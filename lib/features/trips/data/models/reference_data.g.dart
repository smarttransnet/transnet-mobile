// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverRef _$DriverRefFromJson(Map<String, dynamic> json) => DriverRef(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  status: (json['status'] as num).toInt(),
);

Map<String, dynamic> _$DriverRefToJson(DriverRef instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'status': instance.status,
};

VehicleRef _$VehicleRefFromJson(Map<String, dynamic> json) => VehicleRef(
  id: json['id'] as String,
  plateNumber: json['plateNumber'] as String,
  categoryName: json['categoryName'] as String?,
  status: (json['status'] as num).toInt(),
);

Map<String, dynamic> _$VehicleRefToJson(VehicleRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plateNumber': instance.plateNumber,
      'categoryName': instance.categoryName,
      'status': instance.status,
    };

TrailerRef _$TrailerRefFromJson(Map<String, dynamic> json) => TrailerRef(
  id: json['id'] as String,
  trailerNumber: json['trailerNumber'] as String,
  trailerType: json['trailerType'] as String?,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$TrailerRefToJson(TrailerRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trailerNumber': instance.trailerNumber,
      'trailerType': instance.trailerType,
      'isActive': instance.isActive,
    };

ClientRef _$ClientRefFromJson(Map<String, dynamic> json) => ClientRef(
  id: json['id'] as String,
  companyName: json['companyName'] as String,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$ClientRefToJson(ClientRef instance) => <String, dynamic>{
  'id': instance.id,
  'companyName': instance.companyName,
  'isActive': instance.isActive,
};

TripCategoryMaterialRef _$TripCategoryMaterialRefFromJson(
  Map<String, dynamic> json,
) => TripCategoryMaterialRef(
  id: json['id'] as String,
  tripCategoryId: json['tripCategoryId'] as String,
  categoryName: json['categoryName'] as String,
  uomId: json['uomId'] as String,
  uomCode: json['uomCode'] as String,
);

Map<String, dynamic> _$TripCategoryMaterialRefToJson(
  TripCategoryMaterialRef instance,
) => <String, dynamic>{
  'id': instance.id,
  'tripCategoryId': instance.tripCategoryId,
  'categoryName': instance.categoryName,
  'uomId': instance.uomId,
  'uomCode': instance.uomCode,
};
