// 좌표 기반 근접(500m 이내) 정류소 정보 조회 API 데이터를 담을 모델
class NearBusStopModel {
  String? gpslati; // 정류소 Y좌표 (위도)
  String? gpslong; // 정류소 X좌표 (경도)
  String? nodeid; // 정류소 ID

  NearBusStopModel({
    this.gpslati,
    this.gpslong,
    this.nodeid,
  });

  factory NearBusStopModel.fromJson(Map<String, dynamic> json) {
    return NearBusStopModel(
      gpslati: json['gpslati'] as String,
      gpslong: json['gpslong'] as String,
      nodeid: json['nodeid'] as String,
    );
  }
}
