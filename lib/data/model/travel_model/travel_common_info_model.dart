// 관광지의 공통 정보 조회 API 데이터를 담을 모델
class TravelCommonInfoModel {
  String? contentId; // 컨텐츠 ID
  String? travelHomePage; // 홈페이지
  String? travelTel; // 전화번호
  String? travelTitle; // 관광지 이름
  String? travelImage; // 대표 이미지
  String? travelAddr; // 관광지 주소
  String? travelAddr2; // 관광지 주소2 (동 이름)
  String? travelLatitude; // 관광지 위도 (API의 gps Y에 해당)
  String? travelLongitude; // 관광지 경도 (API의 gps X에 해당)
  String? travelMapLevel; // 관광지 지도 줌 (확대) 레벨
  String? travelOverview; // 관광지 정보 개요

  TravelCommonInfoModel({
    this.contentId,
    this.travelHomePage,
    this.travelTel,
    this.travelTitle,
    this.travelImage,
    this.travelAddr,
    this.travelLatitude,
    this.travelLongitude,
    this.travelMapLevel,
    this.travelOverview,
  });

  factory TravelCommonInfoModel.fromJson(Map<String, dynamic> json) {
    return TravelCommonInfoModel(
      contentId: json['contentid'] as String?,
      travelHomePage: json['homepage'] as String?,
      travelTel: json['tel'] as String?,
      travelTitle: json['title'] as String?,
      travelImage: json['firstimage'] as String?,
      travelAddr: json['addr1'] as String?,
      travelLatitude: json['mapy'] as String?,
      travelLongitude: json['mapx'] as String?,
      travelMapLevel: json['mlevel'] as String?,
      travelOverview: json['overview'] as String?,
    );
  }
}
