// 위치 기반 관광지 조회 API 데이터를 담을 모델
class NearTravelInfoModel {
  String? contentId; // 컨텐츠 ID
  String? contentTypeId; // 컨텐츠 타입 ID
  String? distance; // 거리
  String? travelImage; // 대표 이미지
  String? travelTitle; // 제목 (관광지 이름)

  NearTravelInfoModel({
    this.contentId,
    this.contentTypeId,
    this.distance,
    this.travelImage,
    this.travelTitle,
  });

  factory NearTravelInfoModel.fromJson(Map<String, dynamic> json) {
    return NearTravelInfoModel(
      contentId: json['contentid'] as String,
      contentTypeId: json['contenttypeid'] as String,
      distance: json['dist'] as String,
      travelImage: json['firstimage2'] as String? ?? '',
      travelTitle: json['title'] as String,
    );
  }
}

class NearTravelInfoResponse {
  final String totalCount; // 전체 결과 수
  final List<NearTravelInfoModel> travelInfoList; // 관광지 리스트

  NearTravelInfoResponse({
    required this.totalCount,
    required this.travelInfoList,
  });
}
