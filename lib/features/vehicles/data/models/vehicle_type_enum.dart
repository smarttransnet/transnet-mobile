import 'package:json_annotation/json_annotation.dart';

enum VehicleType {
  @JsonValue(1)
  truck,
  @JsonValue(2)
  trailer,
}
