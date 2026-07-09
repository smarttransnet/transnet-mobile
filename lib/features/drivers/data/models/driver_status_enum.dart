import 'package:json_annotation/json_annotation.dart';

enum DriverStatus {
  @JsonValue(0)
  active,
  @JsonValue(1)
  onLeave,
  @JsonValue(2)
  suspended,
  @JsonValue(3)
  terminated,
  @JsonValue(4)
  probation,
}
