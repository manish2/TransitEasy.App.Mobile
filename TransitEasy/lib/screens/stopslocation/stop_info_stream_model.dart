import 'package:json_annotation/json_annotation.dart';
part 'stop_info_stream_model.g.dart';

@JsonSerializable(explicitToJson: true)
class StopInfoStreamModel {
  final int stopNo;
  final String stopName;
  final double stopLat;
  final double stopLong;

  StopInfoStreamModel(this.stopNo, this.stopName, this.stopLat, this.stopLong);

  factory StopInfoStreamModel.fromJson(Map<String, dynamic> data) =>
      _$StopInfoStreamModelFromJson(data);

  Map<String, dynamic> toJson() => _$StopInfoStreamModelToJson(this);

  String toJsonString() =>
      "{\"stopNo\":$stopNo, \"stopName\": \"$stopName\", \"stopLat\":$stopLat, \"stopLong\":$stopLong}";
}
