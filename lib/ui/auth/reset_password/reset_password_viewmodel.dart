import 'package:bus_way/data/respository/login_auth_repository.dart';
import 'package:bus_way/ui/auth/reset_password/reset_password_complete_view.dart';
import 'package:bus_way/widget/custom_snackbar.dart';
import 'package:bus_way/widget/navigator_animation.dart';
import 'package:flutter/material.dart';

class ResetPasswordViewModel with ChangeNotifier {
  LoginAuthRepository loginAuthRepository = LoginAuthRepository();

  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  bool _isEmailActiveBtn = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isEmailActiveBtn => _isEmailActiveBtn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 메모리 누수 방지를 위한 리소스 해제
  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();

    super.dispose();
  }

  // 비밀번호 재설정을 위한 이메일 인증 로직.
  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await loginAuthRepository.resetPassword(emailController.text);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 이메일 정규식 체크 로직
  String? isValidEmailFormat(String email) {
    if (email.isEmpty) {
      return '이메일을 입력해주세요.';
    } else {
      String pattern =
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(email)) {
        return '이메일 형식을 다시 확인해 주세요.';
      }
    }
    return null; // 유효한 이메일 형식일 경우
  }

  // 이메일 정규식 체크 후, 판정 로직
  void handleValidateEmail(BuildContext context, String email) async {
    final emailError = isValidEmailFormat(email);

    // 이메일 형식이 잘못되었을 때 에러 메시지 출력
    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbar(content: Text(emailError)),
      );
    } else {
      await resetPassword(email);
      emailFocusNode.unfocus();

      if (context.mounted) {
        Navigator.of(context).push(
          const NavigatorAnimation(destination: ResetPasswordCompleteView())
              .createRoute(SlideDirection.rightToLeft),
        );
      }
    }
  }

  // 이메일 입력 시, 계속하기 버튼 활성화 여부 변경 로직
  void updateEmailBtn() {
    _isEmailActiveBtn = emailController.text.isNotEmpty;
    notifyListeners();
  }
}
