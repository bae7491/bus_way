class BusLineModel {
  String? busStopName; // 정류소 이름
  String? busStopNumber; // 정류소 번호
  String? busNumber; // 버스 번호
  String? returnPoint; // 회차지 체크 (0: 회차지 X, 1: 회차지 O)

  BusLineModel({
    this.busStopName,
    this.busStopNumber,
    this.busNumber,
    this.returnPoint,
  });

  factory BusLineModel.fromJson(Map<String, dynamic> json) {
    return BusLineModel(
      busStopName: json['bstopnm'] as String,
      busStopNumber: json['arsno']?.toString() ?? '',
      busNumber: json['carno']?.toString() ?? '',
      returnPoint: json['rpoint'] as String,
    );
  }
}
