// 관광지 이미지 정보 조회 API 호출 데이터를 담을 모델
class TravelImageInfoModel {
  String? contentId; // 컨텐츠 ID
  String? imageName; // 이미지 이름
  String? imageUrl; // 이미지 url

  TravelImageInfoModel({
    this.contentId,
    this.imageName,
    this.imageUrl,
  });

  factory TravelImageInfoModel.fromJson(Map<String, dynamic> json) {
    return TravelImageInfoModel(
      contentId: json['contentid'] as String?,
      imageName: json['imgname'] as String?,
      imageUrl: json['originimgurl'] as String?,
    );
  }
}

class TravelImageInfoResponse {
  final String totalCount; // 전체 결과수
  final List<TravelImageInfoModel> travelImageInfoList; // 관광지 이미지 리스트

  TravelImageInfoResponse({
    required this.totalCount,
    required this.travelImageInfoList,
  });
}
