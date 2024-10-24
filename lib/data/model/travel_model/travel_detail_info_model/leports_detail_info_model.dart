// 소개 정보 조회 (관광지 타입 별 정보 조회) API 호출 데이터 중 레포츠(contentTypeId = 28)를 담을 모델
class LeportsDetailInfoModel {
  String? leportsTel; // 레포츠 문의 및 안내
  String? leportsUseTime; // 이용 시간
  String? leportsRestDate; // 휴일
  String? leportsParking; // 주차 가능 여부
  String? leportsOpenPeriod; // 개장 기간

  LeportsDetailInfoModel({
    this.leportsTel,
    this.leportsUseTime,
    this.leportsRestDate,
    this.leportsParking,
    this.leportsOpenPeriod,
  });

  factory LeportsDetailInfoModel.fromJson(Map<String, dynamic> json) {
    return LeportsDetailInfoModel(
      leportsTel: json['infocenterleports'] as String?,
      leportsUseTime: json['usetimeleports'] as String?,
      leportsRestDate: json['restdateleports'] as String?,
      leportsParking: json['parkingleports'] as String?,
      leportsOpenPeriod: json['openperiod'] as String?,
    );
  }
}
