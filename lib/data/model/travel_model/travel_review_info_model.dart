// 관광지 후기 조회 API 호출 결과 데이터를 담을 모델
class TravelReviewInfoModel {
  String? reviewTotalCount; // 리뷰 총 개수
  String? reviewId; // 리뷰 ID
  String? email; // 로그인 한 유저의 email
  String? nickName; // 로그인 한 유저의 닉네임
  String? contentId; // 관광지 ID
  String? reviewRate; // 후기 평점
  String? reviewContent; // 후기 내용
  String? reviewImage; // 후기 이미지
  String? reviewModifiedDate; // 후기 수정 날짜 (최신 날짜)

  TravelReviewInfoModel({
    this.reviewId,
    this.email,
    this.nickName,
    this.contentId,
    this.reviewRate,
    this.reviewContent,
    this.reviewImage,
    this.reviewModifiedDate,
  });

  factory TravelReviewInfoModel.fromJson(Map<String, dynamic> json) {
    return TravelReviewInfoModel(
      reviewId: json['review_id'] as String?,
      email: json['email'] as String?,
      nickName: json['nickName'] as String?,
      contentId: json['content_id'] as String?,
      reviewRate: json['review_rate'] as String?,
      reviewContent: json['review_content'] as String?,
      reviewImage: json['review_image'] as String?,
      reviewModifiedDate: json['modified_date'] as String?,
    );
  }

  static List<TravelReviewInfoModel> fromJsonList(Map<String, dynamic> json) {
    List<TravelReviewInfoModel> reviewList = [];

    String? totalCount = json['total_count']?.toString();

    if (json['reviewList'] != null) {
      for (var item in json['reviewList']) {
        reviewList.add(TravelReviewInfoModel.fromJson(item));
      }
    }

    if (reviewList.isNotEmpty) {
      reviewList.first.reviewTotalCount = totalCount;
    }

    return reviewList;
  }
}
