import 'package:freezed_annotation/freezed_annotation.dart';

enum TripStatus {
  @JsonValue(1)
  scheduled,
  @JsonValue(2)
  inProgress,
  @JsonValue(3)
  onHalt,
  @JsonValue(4)
  completed,
  @JsonValue(5)
  pendingDriverConfirmation,
  @JsonValue(6)
  pendingOfficeApproval,
  @JsonValue(7)
  cancelled,
  @JsonValue(8)
  invoiced,
  @JsonValue(9)
  deleted,
}

enum StatusChangeSource {
  @JsonValue(1)
  driverApp,
  @JsonValue(2)
  officePortal,
  @JsonValue(3)
  systemAuto,
  @JsonValue(4)
  bulkImport,
}
