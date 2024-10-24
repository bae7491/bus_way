// 소개 정보 조회 (관광지 타입 별 정보 조회) API 호출 데이터 중 쇼핑(contentTypeId = 38)을 담을 모델
class ShoppingDetailInfoModel {
  String? shoppingTel; // 쇼핑 문의 및 안내 (전화번호 형식)
  String? shoppingOpenTime; // 영업 시간
  String? shoppingRestDate; // 휴일
  String? shoppingItem; // 판매 품목
  String? shoppingInfo; // 매장 정보
  String? shoppingParking; // 주차 시설 여부

  ShoppingDetailInfoModel({
    this.shoppingTel,
    this.shoppingOpenTime,
    this.shoppingRestDate,
    this.shoppingItem,
    this.shoppingInfo,
    this.shoppingParking,
  });

  factory ShoppingDetailInfoModel.fromJson(Map<String, dynamic> json) {
    return ShoppingDetailInfoModel(
      shoppingTel: json['infocentershopping'] as String?,
      shoppingOpenTime: json['opentime'] as String?,
      shoppingRestDate: json['restdateshopping'] as String?,
      shoppingItem: json['saleitem'] as String?,
      shoppingInfo: json['shopguide'] as String?,
      shoppingParking: json['parkingshopping'] as String?,
    );
  }
}
