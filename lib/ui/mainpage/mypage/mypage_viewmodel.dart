import 'package:bus_way/data/model/mypage_model/mypage_user_model.dart';
import 'package:bus_way/data/model/mypage_model/user_follow_review_summary_model.dart';
import 'package:bus_way/data/respository/auth_repository/login_auth_repository.dart';
import 'package:bus_way/data/respository/mypage_repository/mypage_repository.dart';
import 'package:bus_way/ui/auth/login/login_view.dart';
import 'package:bus_way/ui/auth/login/login_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mypage/follow_list/follow_list_view.dart';
import 'package:bus_way/ui/mainpage/mypage/review_list/review_list_view.dart';
import 'package:bus_way/ui/mainpage/mypage/user_modify/user_modify_view.dart';
import 'package:bus_way/widget/custom_alert_dialog.dart';
import 'package:bus_way/widget/custom_text_alert_diaglog.dart';
import 'package:bus_way/widget/navigator_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MypageViewModel with ChangeNotifier {
  LoginAuthRepository loginAuthRepository = LoginAuthRepository();
  MypageRepository mypageRepository = MypageRepository();

  final TextEditingController passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();

  UserFollowReviewSummaryModel? _followReviewSummary;
  MypageUserModel? _userInfo;
  bool _isLoading = false;
  String? _errorMessage;
  String? _passwordErrorMessage;
  bool _passwordVisible = false;

  UserFollowReviewSummaryModel? get followReviewSummary => _followReviewSummary;
  MypageUserModel? get userInfo => _userInfo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get passwordErrorMessage => _passwordErrorMessage;
  bool get passwordVisible => _passwordVisible;

  @override
  void dispose() {
    passwordController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

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

  // 유저 정보 수정 뷰로 이동
  void navigateUserModify(BuildContext context) {
    Navigator.of(context).push(
      const NavigatorAnimation(
        destination: UserModifyView(),
      ).createRoute(SlideDirection.bottomToTop),
    );
  }

  // 계정 탈퇴 확인 팝업
  Future<void> checkWithDraw(
      BuildContext context, MypageViewModel viewmodel) async {
    _passwordVisible = false;
    passwordController.clear();
    passwordFocusNode.unfocus();
    _passwordErrorMessage = '';
    notifyListeners();

    final isWithDraw = await await showCustomTextAlertDialog(
            context, viewmodel, '계정 탈퇴를 위해 비밀번호를 입력해주세요.') ??
        false;

    if (isWithDraw && context.mounted) {
      await withDraw(context);
    }
  }

  // 계정 탈퇴
  Future<void> withDraw(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      await loginAuthRepository
          .reAuthenticate(passwordController.text)
          .then((_) {
        Future.wait([
          // 파이어베이스 계정 탈퇴
          loginAuthRepository.withDraw(),

          // DB의 계정 탈퇴
          loginAuthRepository.deleteUser(),
        ]);
      });

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
        loginViewModel.clearErrorMessage();
        loginViewModel.clearPasswordVisibility();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 로그아웃 확인 팝업
  Future<void> checkSignOut(BuildContext context) async {
    final isSignOut =
        await showCustomAlertDialog(context, '로그아웃 하시겠습니까?') ?? false;

    if (isSignOut && context.mounted) {
      await signOut(context);
    }
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
      loginViewModel.clearErrorMessage();
      loginViewModel.clearPasswordVisibility();
    }
  }

// 비밀번호 textField 보이기/숨기기 토글 로직
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  // 비밀번호 textField 유효성 검사
  bool checkPassword() {
    if (passwordController.text.isNotEmpty) {
      return true;
    } else {
      _passwordErrorMessage = '계정 탈퇴를 위해 비밀번호를 입력해주세요.';
      notifyListeners();
      return false;
    }
  }
}
