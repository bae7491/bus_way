// 소개 정보 조회 (관광지 타입 별 정보 조회) API 호출 데이터 중 관광지(contentTypeId = 12)를 담을 모델
class TravelDetailInfoModel {
  String? travelInfoTel; // 문의 및 안내 (전화번호 형식)
  String? travelUseTime; // 이용시간
  String? travelRestDate; // 휴일
  String? travelParking; // 주차시설 여부

  TravelDetailInfoModel({
    this.travelInfoTel,
    this.travelUseTime,
    this.travelRestDate,
    this.travelParking,
  });

  factory TravelDetailInfoModel.fromJson(Map<String, dynamic> json) {
    return TravelDetailInfoModel(
      travelInfoTel: json['infocenter'] as String?,
      travelUseTime: json['usetime'] as String?,
      travelRestDate: json['restdate'] as String?,
      travelParking: json['parking'] as String?,
    );
  }
}
