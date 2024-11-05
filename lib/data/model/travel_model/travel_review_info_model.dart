// 관광지 리뷰 총 개수, 평점 평균 조회 API 호출 데이터를 담을 모델
class TravelReviewInfoModel {
  String? reviewCount;
  String? reviewAverageRate;

  TravelReviewInfoModel({
    this.reviewCount,
    this.reviewAverageRate,
  });

  factory TravelReviewInfoModel.fromJson(Map<String, dynamic> json) {
    return TravelReviewInfoModel(
      reviewCount: json['review_count'],
      reviewAverageRate: json['review_rate'],
    );
  }
}
