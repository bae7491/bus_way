// 관광지 리뷰 총 개수, 평점 평균 조회 API 호출 데이터를 담을 모델
class TravelReviewSummaryModel {
  String? reviewCount;
  String? reviewAverageRate;

  TravelReviewSummaryModel({
    this.reviewCount,
    this.reviewAverageRate,
  });

  factory TravelReviewSummaryModel.fromJson(Map<String, dynamic> json) {
    return TravelReviewSummaryModel(
      reviewCount: json['review_count'],
      reviewAverageRate: json['review_rate'],
    );
  }
}
