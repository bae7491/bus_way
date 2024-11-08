// 관광지 팔로우 조회 API 호출 결과 데이터를 담을 모델
class UserFollowModel {
  String? followTotalCount; // 팔로우 총 개수
  String? followId; // 팔로우 ID
  String? email; // 이메일
  String? title; // 관광지 이름
  String? contentId; // 관광지 ID
  String? contentTypeId; // 관광지 타입 ID
  String? firstImage; // 관광지 썸네일 이미지

  UserFollowModel({
    this.followId,
    this.email,
    this.title,
    this.contentId,
    this.contentTypeId,
    this.firstImage,
  });

  factory UserFollowModel.fromJson(Map<String, dynamic> json) {
    return UserFollowModel(
      followId: json['follow_id'] as String?,
      email: json['email'] as String?,
      title: json['title'] as String?,
      contentId: json['content_id'] as String?,
      contentTypeId: json['content_type_id'] as String?,
      firstImage: json['firstimage'] as String?,
    );
  }

  static List<UserFollowModel> fromJsonList(Map<String, dynamic> json) {
    List<UserFollowModel> followList = [];

    String? totalCount = json['total_count']?.toString();

    if (json['followList'] != null) {
      for (var item in json['followList']) {
        followList.add(UserFollowModel.fromJson(item));
      }
    }

    if (followList.isNotEmpty) {
      followList.first.followTotalCount = totalCount;
    }

    return followList;
  }
}
