// 정류소 도착 정보 조회 (정류장 ID) API 데이터를 담을 모델
class BusStopInfoModel {
  String? nodenm; // 정류장 명
  String? lineno; // 버스 번호
  String? min1; // 1번째 뒤 버스의 남은 시간
  String? station1; // 1번째 뒤 버스의 남은 정류장 수
  String? min2; // 2번째 뒤 버스의 남은 시간
  String? station2; // 2번쨰 뒤 버스의 남은 정류장 수
  String? bustype; // 버스 타입
  String? lineid; // 노선 아이디

  BusStopInfoModel({
    this.nodenm,
    this.lineno,
    this.min1,
    this.station1,
    this.min2,
    this.station2,
    this.bustype,
    this.lineid,
  });

  factory BusStopInfoModel.fromJson(Map<String, dynamic> json) {
    return BusStopInfoModel(
      nodenm: json['nodenm'] as String,
      lineno: json['lineno'] as String,
      min1: json['min1'] as String? ?? '',
      station1: json['station1'] as String? ?? '',
      min2: json['min2'] as String? ?? '',
      station2: json['station2'] as String? ?? '',
      bustype: json['bustype'] as String,
      lineid: json['lineid'] as String,
    );
  }
}
