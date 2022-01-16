import 'package:json_annotation/json_annotation.dart';
part 'stop_info_stream_model.g.dart';

@JsonSerializable(explicitToJson: true)
class StopInfoStreamModel {
  final int stopNo;
  final String stopName;
  final double stopLat;
  final double stopLong;
  final bool isWheelchairAccessible;
  final int distance;
  final List<String>? routes;

  StopInfoStreamModel(this.stopNo, this.stopName, this.stopLat, this.stopLong,
      this.isWheelchairAccessible, this.distance, this.routes);

  factory StopInfoStreamModel.fromJson(Map<String, dynamic> data) =>
      _$StopInfoStreamModelFromJson(data);

  Map<String, dynamic> toJson() => _$StopInfoStreamModelToJson(this);

  String toJsonString() =>
      "{\"stopNo\":$stopNo, \"stopName\": \"$stopName\", \"stopLat\":$stopLat, \"stopLong\":$stopLong, \"isWheelchairAccessible\":$isWheelchairAccessible, \"distance\":$distance}";
}
