// 관공지 후기 조회 API 호출 결과 데이터를 담을 모델
class UserReviewModel {
  String? reviewTotalCount; // 리뷰 총 개수
  String? reviewId; // 리뷰 ID
  String? email; // 이메일
  String? nickName; // 닉네임
  String? contentId; // 관광지 ID
  String? title; // 관광지 이름
  String? reviewRate; // 후기 평점
  String? reviewContent; // 후기 내용
  String? reviewImage; // 후기 이미지
  String? reviewModifiedDate; // 글 최신 날짜 (수정 날짜 기준)

  UserReviewModel({
    this.reviewTotalCount,
    this.reviewId,
    this.email,
    this.nickName,
    this.contentId,
    this.title,
    this.reviewRate,
    this.reviewContent,
    this.reviewImage,
    this.reviewModifiedDate,
  });

  factory UserReviewModel.fromJson(Map<String, dynamic> json) {
    return UserReviewModel(
      reviewId: json['review_id'] as String?,
      email: json['email'] as String?,
      nickName: json['nickName'] as String?,
      contentId: json['content_id'] as String?,
      title: json['title'] as String?,
      reviewRate: json['review_rate'] as String?,
      reviewContent: json['review_content'] as String?,
      reviewImage: json['review_image'] as String?,
      reviewModifiedDate: json['modified_date'] as String?,
    );
  }

  static List<UserReviewModel> fromJsonList(Map<String, dynamic> json) {
    List<UserReviewModel> reviewList = [];

    String? totalCount = json['total_count']?.toString();

    if (json['reviewList'] != null) {
      for (var item in json['reviewList']) {
        reviewList.add(UserReviewModel.fromJson(item));
      }
    }

    if (reviewList.isNotEmpty) {
      reviewList.first.reviewTotalCount = totalCount;
    }
    return reviewList;
  }
}
