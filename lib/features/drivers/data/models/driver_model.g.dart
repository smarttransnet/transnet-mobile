// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverModel _$DriverModelFromJson(Map<String, dynamic> json) => DriverModel(
  id: json['id'] as String,
  employeeNumber: json['employeeNumber'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  email: json['email'] as String?,
  licenceNumber: json['licenceNumber'] as String,
  licenceExpiryDate: DateTime.parse(json['licenceExpiryDate'] as String),
  nationalityCode: json['nationalityCode'] as String,
  sponsorName: json['sponsorName'] as String?,
  status: $enumDecode(_$DriverStatusEnumMap, json['status']),
  isActive: json['isActive'] as bool,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$DriverModelToJson(DriverModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeNumber': instance.employeeNumber,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'licenceNumber': instance.licenceNumber,
      'licenceExpiryDate': instance.licenceExpiryDate.toIso8601String(),
      'nationalityCode': instance.nationalityCode,
      'sponsorName': instance.sponsorName,
      'status': _$DriverStatusEnumMap[instance.status]!,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$DriverStatusEnumMap = {
  DriverStatus.active: 0,
  DriverStatus.onLeave: 1,
  DriverStatus.suspended: 2,
  DriverStatus.terminated: 3,
  DriverStatus.probation: 4,
};
