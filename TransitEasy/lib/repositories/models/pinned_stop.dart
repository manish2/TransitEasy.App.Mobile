import 'package:json_annotation/json_annotation.dart';
part 'pinned_stop.g.dart';

@JsonSerializable(explicitToJson: true)
class PinnedStop {
  final String stopNo;
  final String stopDesc;
  PinnedStop(this.stopNo, this.stopDesc);

  factory PinnedStop.fromJson(Map<String, dynamic> data) =>
      _$PinnedStopFromJson(data);
}
