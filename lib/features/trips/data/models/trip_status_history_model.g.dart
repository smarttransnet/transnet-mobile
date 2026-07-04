// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_status_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripStatusHistoryModel _$TripStatusHistoryModelFromJson(
  Map<String, dynamic> json,
) => TripStatusHistoryModel(
  id: json['id'] as String,
  tripId: json['tripId'] as String,
  previousStatus: $enumDecode(_$TripStatusEnumMap, json['previousStatus']),
  newStatus: $enumDecode(_$TripStatusEnumMap, json['newStatus']),
  changedByUserId: json['changedByUserId'] as String?,
  changedByDriverId: json['changedByDriverId'] as String?,
  changedAt: DateTime.parse(json['changedAt'] as String),
  notes: json['notes'] as String?,
  source: $enumDecode(_$StatusChangeSourceEnumMap, json['source']),
);

Map<String, dynamic> _$TripStatusHistoryModelToJson(
  TripStatusHistoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'tripId': instance.tripId,
  'previousStatus': _$TripStatusEnumMap[instance.previousStatus]!,
  'newStatus': _$TripStatusEnumMap[instance.newStatus]!,
  'changedByUserId': instance.changedByUserId,
  'changedByDriverId': instance.changedByDriverId,
  'changedAt': instance.changedAt.toIso8601String(),
  'notes': instance.notes,
  'source': _$StatusChangeSourceEnumMap[instance.source]!,
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

const _$StatusChangeSourceEnumMap = {
  StatusChangeSource.driverApp: 1,
  StatusChangeSource.officePortal: 2,
  StatusChangeSource.systemAuto: 3,
  StatusChangeSource.bulkImport: 4,
};
