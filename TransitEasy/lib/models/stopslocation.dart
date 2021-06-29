class StopsLocation {
  int stopNo;
  double stopLat;
  double stopLong;
  String stopName;
  String bayNo;
  bool wheelChairAccess;
  int distance;
  List<String> routes;

  StopsLocation(this.stopNo, this.stopLat, this.stopLong, this.stopName,
      this.bayNo, this.wheelChairAccess, this.distance, this.routes);

  factory StopsLocation.fromJson(Map<String, dynamic> parsedJson) {
    return StopsLocation(
      parsedJson['stopNo'] as int,
      parsedJson['latitude'] as double,
      parsedJson['longitude'] as double,
      parsedJson['stopName'] as String,
      parsedJson['bayNo'] as String,
      parsedJson['isWheelchairAccessible'] as bool,
      parsedJson['distance'] as int,
      parsedJson['routes'] as List<String>,
    );
  }
}
