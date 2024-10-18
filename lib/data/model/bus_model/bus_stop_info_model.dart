class BusStopInfoModel {
  String? busStopId; // 버스 정류장 ID
  String? latitude; // 위도
  String? longitude; // 경도

  BusStopInfoModel({
    this.busStopId,
    this.latitude,
    this.longitude,
  });

  factory BusStopInfoModel.fromJson(Map<String, dynamic> json) {
    return BusStopInfoModel(
      busStopId: json['bstopid'] as String,
      latitude: json['gpsy'] as String,
      longitude: json['gpsx'] as String,
    );
  }
}
