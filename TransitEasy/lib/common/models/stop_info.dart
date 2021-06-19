import 'package:json_annotation/json_annotation.dart';
part 'stop_info.g.dart';

@JsonSerializable(explicitToJson: true)
class StopInfo {
  int stopNo;
  double latitude;
  double longitude;
  String stopName;
  String bayNo;
  bool isWheelchairAccessible;
  int distance;
  List<String> routes;

  StopInfo(this.stopNo, this.latitude, this.longitude, this.stopName,
      this.bayNo, this.isWheelchairAccessible, this.distance, this.routes);

  factory StopInfo.fromJson(Map<String, dynamic> data) =>
      _$StopInfoFromJson(data);

  Map<String, dynamic> toJson() => _$StopInfoToJson(this);
}
