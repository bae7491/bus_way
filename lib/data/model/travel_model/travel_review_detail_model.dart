// 관광지 후기 상세 정보 조회 API 호출 결과를 담을 모델
class TravelReviewDetailModel {
  String? reviewId; // 후기 ID
  String? reviewRate; // 후기 평점
  String? reviewContent; // 후기 내용
  String? reviewImage; // 후기 이미지

  TravelReviewDetailModel({
    this.reviewId,
    this.reviewRate,
    this.reviewContent,
    this.reviewImage,
  });

  factory TravelReviewDetailModel.fromJson(Map<String, dynamic> json) {
    return TravelReviewDetailModel(
      reviewId: json['review_id'] as String?,
      reviewRate: json['review_rate'] as String?,
      reviewContent: json['review_content'] as String?,
      reviewImage: json['review_image'] as String?,
    );
  }
}
