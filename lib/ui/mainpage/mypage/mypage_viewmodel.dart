import 'package:bus_way/data/model/mypage_model/mypagae_user_model.dart';
import 'package:bus_way/data/model/mypage_model/user_follow_review_summary_model.dart';
import 'package:bus_way/data/respository/auth_repository/login_auth_repository.dart';
import 'package:bus_way/data/respository/mypage_repository/mypage_repository.dart';
import 'package:bus_way/ui/auth/login/login_view.dart';
import 'package:bus_way/ui/auth/login/login_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mypage/follow_list/follow_list_view.dart';
import 'package:bus_way/ui/mainpage/mypage/review_list/review_list_view.dart';
import 'package:bus_way/widget/navigator_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MypageViewModel with ChangeNotifier {
  LoginAuthRepository loginAuthRepository = LoginAuthRepository();
  MypageRepository mypageRepository = MypageRepository();

  UserFollowReviewSummaryModel? _followReviewSummary;
  MypagaeUserModel? _userInfo;
  bool _isLoading = false;
  String? _errorMessage;

  UserFollowReviewSummaryModel? get followReviewSummary => _followReviewSummary;
  MypagaeUserModel? get userInfo => _userInfo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 에러 메시지 초기화
  void clearErrorMessage() async {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadUserInfo() async {
    _isLoading = true;
    notifyListeners();

    Future.wait([
      getUserInfo(),
      getFollowReviewCount(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  // 회원 정보 불러오기
  Future<void> getUserInfo() async {
    try {
      _isLoading = true;
      notifyListeners();

      _userInfo = await mypageRepository.getUserInfo();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 회원의 관광지 팔로우 & 후기 총 개수 조회
  Future<void> getFollowReviewCount() async {
    try {
      _followReviewSummary = await mypageRepository.getFollowReviewCount();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // 유저의 관광지 팔로우 목록 뷰로 이동
  void navigateFollowList(BuildContext context, String followTotalCount) {
    Navigator.of(context).push(
      const NavigatorAnimation(
        destination: FollowListView(),
      ).createRoute(SlideDirection.bottomToTop),
    );
  }

  // 유저의 관광지 후기 목록 뷰로 이동
  void navigateReviewList(BuildContext context) {
    Navigator.of(context).push(
      const NavigatorAnimation(
        destination: ReviewListView(),
      ).createRoute(SlideDirection.bottomToTop),
    );
  }

  // 로그아웃
  Future<void> signOut(BuildContext context) async {
    await loginAuthRepository.signOut();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        const NavigatorAnimation(destination: LoginView())
            .createRoute(SlideDirection.bottomToTop),
        (route) => false,
      );

      final loginViewModel =
          Provider.of<LoginViewModel>(context, listen: false);
      loginViewModel.autoLoginOff();
      loginViewModel.emailController.clear();
      loginViewModel.passwordController.clear();
      loginViewModel.clearPasswordVisibility();
    }
  }
}
