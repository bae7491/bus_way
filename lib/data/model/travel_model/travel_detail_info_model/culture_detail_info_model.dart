// 소개 정보 조회 (관광지 타입 별 정보 조회) API 호출 데이터 중 문화시설(contentTypeId = 14)을 담을 모델
class CultureDetailInfoModel {
  String? travelCultureInfoTel; // 문화시설 문의 및 안내 (전화번호 형식)
  String? travelCultureUseTime; // // 이용시간
  String? cultureRestDate; // 휴일
  String? cultureUseFee; // 이용 요금
  String? cultureScale; // 문화시설 규모
  String? cultureParking; // 주차시설

  CultureDetailInfoModel({
    this.travelCultureInfoTel,
    this.travelCultureUseTime,
    this.cultureRestDate,
    this.cultureUseFee,
    this.cultureScale,
    this.cultureParking,
  });

  factory CultureDetailInfoModel.fromJson(Map<String, dynamic> json) {
    return CultureDetailInfoModel(
      travelCultureInfoTel: json['infocenterculture'] as String?,
      travelCultureUseTime: json['usetimeculture'] as String?,
      cultureRestDate: json['restdateculture'] as String?,
      cultureUseFee: json['usefee'] as String?,
      cultureScale: json['scale'] as String?,
      cultureParking: json['parkingculture'] as String?,
    );
  }
}
