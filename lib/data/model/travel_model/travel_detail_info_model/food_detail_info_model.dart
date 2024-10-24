// 소개 정보 조회 (관광지 타입 별 정보 조회) API 호출 데이터 중 음식점(contentTypeId = 39)을 담을 모델
class FoodDetailInfoModel {
  String? foodTel; // 음식점 문의 및 안내 (전화번호 형식)
  String? foodOpenTime; // 영업 시간
  String? foodRestDate; // 휴일
  String? foodParking; // 주차 가능 여부
  String? representativeMenu; // 대표 메뉴

  FoodDetailInfoModel({
    this.foodTel,
    this.foodOpenTime,
    this.foodRestDate,
    this.foodParking,
    this.representativeMenu,
  });

  factory FoodDetailInfoModel.fromJson(Map<String, dynamic> json) {
    return FoodDetailInfoModel(
      foodTel: json['infocenterfood'] as String?,
      foodOpenTime: json['opentimefood'] as String?,
      foodRestDate: json['restdatefood'] as String?,
      foodParking: json['parkingfood'] as String?,
      representativeMenu: json['firstmenu'] as String?,
    );
  }
}
