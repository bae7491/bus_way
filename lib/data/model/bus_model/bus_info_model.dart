// 버스 상세 정보 API 데이터를 담을 모델
class BusInfoModel {
  String? lineId; // 버스 ID
  String? busLineNum; // 버스 번호
  String? busType; // 버스 타입
  String? startPoint; // 출발 차고지
  String? endPoint; // 도착 차고지
  String? firstTime; // 첫차 시간
  String? endTime; // 막차 시간
  String? headWayPeak; // 출퇴근 버스 간격
  String? headWayNormal; // 평일 버스 간격
  String? headWayHoliday; // 주말 버스 간격

  BusInfoModel({
    this.lineId,
    this.busLineNum,
    this.busType,
    this.startPoint,
    this.endPoint,
    this.firstTime,
    this.endTime,
    this.headWayPeak,
    this.headWayNormal,
    this.headWayHoliday,
  });

  factory BusInfoModel.fromJson(Map<String, dynamic> json) {
    return BusInfoModel(
      lineId: json['lineid'] as String,
      busLineNum: json['buslinenum'] as String,
      busType: json['bustype'] as String,
      startPoint: json['startpoint'] as String,
      endPoint: json['endpoint'] as String,
      firstTime: json['firsttime'] as String,
      endTime: json['endtime'] as String,
      headWayPeak: json['headwaypeak'] as String,
      headWayNormal: json['headwaynorm'] as String,
      headWayHoliday: json['headwayholi'] as String,
    );
  }
}
