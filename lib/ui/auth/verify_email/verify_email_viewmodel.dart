import 'package:bus_way/data/respository/auth_repository.dart';
import 'package:bus_way/ui/mainpage/mainpage_view.dart';
import 'package:bus_way/widget/custom_snackbar.dart';
import 'package:bus_way/widget/navigator_animation.dart';
import 'package:flutter/material.dart';

class VerifyEmailViewmodel with ChangeNotifier {
  AuthRepository authRepository = AuthRepository();

  bool _isLoading = false;
  bool _emailVerified = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get emailVerified => _emailVerified;
  String? get errorMessage => _errorMessage;

  // 인증 확인 체크 로직
  handleVerifyEmail(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _emailVerified = await authRepository.checkVerifyEmail();
    print('이메일 인증 확인: $_emailVerified');

    // 메일 인증 완료 후,
    if (_emailVerified) {
      // 인증 완료 시,
      if (context.mounted) {
        Navigator.of(context).push(
            const NavigatorAnimation(destination: MainView())
                .createRoute(SlideDirection.bottomToTop));
      }
    } else {
      // 인증 미완료 시,
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const CustomSnackbar(content: Text('이메일 인증 완료 후, 계속하기를 눌러주세요.')),
        );
      }
    }
    _isLoading = false;
    notifyListeners();
  }
}
