/* 
  ViewModel -> Model과 View를 연결하는 역할.
  상태 관리 로직 담당.

  login_viewmodel : auth_repository.dart 및 login_view.dart와 상호작용.

  - 역할
    1. 상태 관리 / Model의 메서드 호출 -> 데이터 가져옴.
      (auth_repository.dart로 연결.)
    2. notifyListeners 추가 후, 이를 통해 데이터에 업데이트가 있다는 것을 ViewModel이 참조하고 있는 View에 알림.
*/

import 'package:bus_way/ui/auth/reset_password/reset_password_view.dart';
import 'package:bus_way/ui/auth/reset_password/reset_password_viewmodel.dart';
import 'package:bus_way/ui/auth/signup/signup_email_view.dart';
import 'package:bus_way/ui/auth/signup/signup_viewmodel.dart';
import 'package:bus_way/ui/auth/verify_email/verify_email_view.dart';
import 'package:bus_way/ui/mainpage/mainpage_view.dart';
import 'package:bus_way/widget/navigator_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/model/firebase_user_model.dart';
import '../../../data/respository/login_auth_repository.dart';

class LoginViewModel with ChangeNotifier {
  LoginAuthRepository loginAuthRepository = LoginAuthRepository();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FirebaseUserModel? _firebaseUser; // firebase에서 로그인에 사용하는 유저 정보 모델
  String? _errorMessage;
  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _autoLogin = false;

  FirebaseUserModel? get firebaseUser => _firebaseUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get passwordVisible => _passwordVisible;
  bool get autoLogin => _autoLogin;

  LoginViewModel() {
    loadAutoLogin();
  }

  // 메모리 누수 방지를 위한 리소스 해제
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // 로그인 로직
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await loginAuthRepository.login(email, password);
      if (user != null) {
        _firebaseUser = FirebaseUserModel(
            email: email,
            password: password,
            emailVerified: user.emailVerified);
        _autoLogin = autoLogin;
        await setAutoLogin(autoLogin);
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 이메일 인증 메일 전송 로직
  Future<void> verifyEmail() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await loginAuthRepository.verifyEmail();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 자동 로그인 끄기 로직
  void autoLoginOff() {
    _autoLogin = false;
    notifyListeners();
  }

  // 비밀번호 textField 보이기/숨기기 토글 로직
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  // 자동 로그인 체크 상태 관리 로직
  Future<void> setAutoLogin(bool autoLogin) async {
    _autoLogin = autoLogin;
    await loginAuthRepository.setAutoLogin(autoLogin);
    notifyListeners();
  }

  // 자동 로그인 상태 로드
  Future<void> loadAutoLogin() async {
    _autoLogin = await loginAuthRepository.getAutoLogin();
    notifyListeners();
  }

  // 비밀번호 재설정
  void resetPasswordNavigate(BuildContext context) {
    Navigator.of(context)
        .push(const NavigatorAnimation(destination: ResetPasswordView())
            .createRoute(SlideDirection.bottomToTop))
        .then((_) {
      emailController.clear();
      passwordController.clear();
    });
    final resetPasswordViewModel =
        Provider.of<ResetPasswordViewModel>(context, listen: false);
    resetPasswordViewModel.emailController.clear();
  }

  // 로그인 성공 후 이동 로직
  void loginNavigate(BuildContext context) async {
    try {
      if (_firebaseUser != null && _firebaseUser!.emailVerified!) {
        _isLoading = true;
        _errorMessage = '';
        notifyListeners();

        // 변경한 비밀번호를 DB에 업데이트
        await loginAuthRepository.updatePassword(
          _firebaseUser!.email!,
          _firebaseUser!.password!,
        );

        if (context.mounted) {
          // 비밀번호 업데이트 성공 시, 메인 화면으로 이동
          Navigator.of(context).pushAndRemoveUntil(
            const NavigatorAnimation(
              destination: MainView(),
            ).createRoute(SlideDirection.bottomToTop),
            (Route<dynamic> route) => false,
          );
        }

        // 로그인 성공 후 이메일과 비밀번호 초기화
        emailController.clear();
        passwordController.clear();
      } else {
        // 이메일 인증이 완료되지 않은 경우
        verifyEmail().then((value) {
          if (context.mounted) {
            Navigator.of(context).push(
              const NavigatorAnimation(
                destination: VerifyEmailView(),
              ).createRoute(SlideDirection.bottomToTop),
            );
          }
        });
      }
    } catch (e) {
      if (_errorMessage != null && context.mounted) {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 회원가입
  void signUpNavigate(BuildContext context) {
    Navigator.of(context)
        .push(
      const NavigatorAnimation(
        destination: SignUpEmailView(),
      ).createRoute(SlideDirection.bottomToTop),
    )
        .then((_) {
      emailController.clear();
      passwordController.clear();
    });
    final signUpViewModel =
        Provider.of<SignUpViewModel>(context, listen: false);
    signUpViewModel.emailController.clear();
    signUpViewModel.updateEmailBtn();
  }
}
