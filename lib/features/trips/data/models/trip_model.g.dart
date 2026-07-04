// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripModel _$TripModelFromJson(Map<String, dynamic> json) => TripModel(
  id: json['id'] as String,
  tripNumber: json['tripNumber'] as String,
  driverId: json['driverId'] as String,
  vehicleId: json['vehicleId'] as String,
  trailerId: json['trailerId'] as String?,
  status: $enumDecode(_$TripStatusEnumMap, json['status']),
  scheduledStartAt: DateTime.parse(json['scheduledStartAt'] as String),
  actualStartAt: json['actualStartAt'] == null
      ? null
      : DateTime.parse(json['actualStartAt'] as String),
  actualEndAt: json['actualEndAt'] == null
      ? null
      : DateTime.parse(json['actualEndAt'] as String),
  totalDistanceKm: (json['totalDistanceKm'] as num?)?.toDouble(),
  isImported: json['isImported'] as bool,
  importBatchId: json['importBatchId'] as String?,
  origin: json['origin'] as String?,
  destination: json['destination'] as String?,
  driverConfirmedAt: json['driverConfirmedAt'] == null
      ? null
      : DateTime.parse(json['driverConfirmedAt'] as String),
  officeApprovedAt: json['officeApprovedAt'] == null
      ? null
      : DateTime.parse(json['officeApprovedAt'] as String),
  officeApprovedByUserId: json['officeApprovedByUserId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  driverName: json['driverName'] as String?,
  vehicleRegistrationNumber: json['vehicleRegistrationNumber'] as String?,
  clientName: json['clientName'] as String?,
  clientId: json['clientId'] as String?,
  responseVersion: json['responseVersion'] as String?,
  vehiclePlateNumber: json['vehiclePlateNumber'] as String?,
  vehicleCategoryName: json['vehicleCategoryName'] as String?,
  tripCategoryMaterialId: json['tripCategoryMaterialId'] as String?,
  categoryName: json['categoryName'] as String?,
  uomCode: json['uomCode'] as String?,
  quantity: (json['quantity'] as num?)?.toDouble(),
  statusHistory:
      (json['statusHistory'] as List<dynamic>?)
          ?.map(
            (e) => TripStatusHistoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$TripModelToJson(TripModel instance) => <String, dynamic>{
  'id': instance.id,
  'tripNumber': instance.tripNumber,
  'driverId': instance.driverId,
  'vehicleId': instance.vehicleId,
  'trailerId': instance.trailerId,
  'status': _$TripStatusEnumMap[instance.status]!,
  'scheduledStartAt': instance.scheduledStartAt.toIso8601String(),
  'actualStartAt': instance.actualStartAt?.toIso8601String(),
  'actualEndAt': instance.actualEndAt?.toIso8601String(),
  'totalDistanceKm': instance.totalDistanceKm,
  'isImported': instance.isImported,
  'importBatchId': instance.importBatchId,
  'origin': instance.origin,
  'destination': instance.destination,
  'driverConfirmedAt': instance.driverConfirmedAt?.toIso8601String(),
  'officeApprovedAt': instance.officeApprovedAt?.toIso8601String(),
  'officeApprovedByUserId': instance.officeApprovedByUserId,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'driverName': instance.driverName,
  'vehicleRegistrationNumber': instance.vehicleRegistrationNumber,
  'clientName': instance.clientName,
  'clientId': instance.clientId,
  'responseVersion': instance.responseVersion,
  'vehiclePlateNumber': instance.vehiclePlateNumber,
  'vehicleCategoryName': instance.vehicleCategoryName,
  'tripCategoryMaterialId': instance.tripCategoryMaterialId,
  'categoryName': instance.categoryName,
  'uomCode': instance.uomCode,
  'quantity': instance.quantity,
  'statusHistory': instance.statusHistory,
};

const _$TripStatusEnumMap = {
  TripStatus.scheduled: 1,
  TripStatus.inProgress: 2,
  TripStatus.onHalt: 3,
  TripStatus.completed: 4,
  TripStatus.pendingDriverConfirmation: 5,
  TripStatus.pendingOfficeApproval: 6,
  TripStatus.cancelled: 7,
  TripStatus.invoiced: 8,
  TripStatus.deleted: 9,
};
