// 소개 정보 조회 (관광지 타입 별 정보 조회) API 호출 데이터 중 여행코스(contentTypeId = 25)를 담을 모델
class CourseDetailInfoModel {
  String? courseDistance; // 코스 총 거리
  String? courseTime; // 코스 총 소요 시간

  CourseDetailInfoModel({
    this.courseDistance,
    this.courseTime,
  });

  factory CourseDetailInfoModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailInfoModel(
      courseDistance: json['distance'] as String?,
      courseTime: json['taketime'] as String?,
    );
  }
}
