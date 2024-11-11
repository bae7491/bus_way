import 'package:bus_way/data/datasource/mypage_datasource/mypage_local_datasource.dart';
import 'package:bus_way/data/model/mypage_model/mypagae_user_model.dart';
import 'package:bus_way/data/model/mypage_model/user_follow_model.dart';
import 'package:bus_way/data/model/mypage_model/user_follow_review_summary_model.dart';
import 'package:bus_way/data/model/mypage_model/user_review_model.dart';

class MypageRepository {
  final MypageLocalDatasource mypageLocalDatasource = MypageLocalDatasource();

  // 로그인 회원 정보 조회
  Future<MypagaeUserModel> getUserInfo() async {
    final userInfo = await mypageLocalDatasource.getUserInfo();
    return userInfo;
  }

  // 회원의 관광지 팔로우 & 후기 총 개수 조회
  Future<UserFollowReviewSummaryModel> getFollowReviewCount() async {
    final followReviewSummary =
        await mypageLocalDatasource.getFollowReviewCount();
    return followReviewSummary;
  }

  // 회원의 관광지 팔로우 목록 조회
  Future<List<UserFollowModel>> getFollowList(int pageNo, int pageSize) async {
    final followList =
        await mypageLocalDatasource.getFollowList(pageNo, pageSize);
    return followList;
  }

  // 회원의 관광지 후기 목록 조회
  Future<List<UserReviewModel>> getReviewList(
      int pageNo, int pageSize, String sortIndex) async {
    final reviewList =
        await mypageLocalDatasource.getReviewList(pageNo, pageSize, sortIndex);
    return reviewList;
  }

  // 회원의 관광지 후기 삭제
  Future<void> deleteReivew(String reviewId, String reviewImage) async {
    await mypageLocalDatasource.deleteReview(reviewId, reviewImage);
  }
}
