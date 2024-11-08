// 회원의 관광지 팔로우 & 후기 총 개수 조회 API 호출 데이터를 담을 모델
class UserFollowReviewSummaryModel {
  String? followTotalCount; // 팔로우 총 개수
  String? reviewTotalCount; // 리뷰 총 개수

  UserFollowReviewSummaryModel({
    this.followTotalCount,
    this.reviewTotalCount,
  });
}
