import 'package:json_annotation/json_annotation.dart';

enum VehicleStatus {
  @JsonValue(1)
  active,
  @JsonValue(2)
  maintenance,
  @JsonValue(3)
  outOfService,
  @JsonValue(4)
  sold,
}
