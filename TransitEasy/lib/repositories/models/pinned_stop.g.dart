// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pinned_stop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PinnedStop _$PinnedStopFromJson(Map<String, dynamic> json) {
  return PinnedStop(
    json['stopNo'] as String,
    json['stopDesc'] as String,
  );
}

Map<String, dynamic> _$PinnedStopToJson(PinnedStop instance) =>
    <String, dynamic>{
      'stopNo': instance.stopNo,
      'stopDesc': instance.stopDesc,
    };
