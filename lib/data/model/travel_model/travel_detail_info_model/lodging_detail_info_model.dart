// 소개 정보 조회 (관광지 타입 별 정보 조회) API 호출 데이터 중 숙박(contentTypeId = 32)을 담을 모델
class LodgingDetailInfoModel {
  String? lodgingTel; // 문의 및 안내
  String? lodgingMaxCount; // 수용 가능 인원
  String? lodgingInTime; // 입실 시간
  String? lodgingOutTime; // 퇴실 시간
  String? foodPlace; // 식음료장
  String? subFacility; // 부대 시설 (기타)
  String? lodginigScale; // 숙박 시설 규모

  LodgingDetailInfoModel({
    this.lodgingTel,
    this.lodgingMaxCount,
    this.lodgingInTime,
    this.lodgingOutTime,
    this.foodPlace,
    this.subFacility,
    this.lodginigScale,
  });

  factory LodgingDetailInfoModel.fromJson(Map<String, dynamic> json) {
    return LodgingDetailInfoModel(
      lodgingTel: json['infocenterlodging'] as String?,
      lodgingMaxCount: json['accomcountlodging'] as String?,
      lodgingInTime: json['checkintime'] as String?,
      lodgingOutTime: json['checkouttime'] as String?,
      foodPlace: json['foodplace'] as String?,
      subFacility: json['subfacility'] as String?,
      lodginigScale: json['scalelodging'] as String?,
    );
  }
}
