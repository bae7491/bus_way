import 'package:bus_way/data/respository/login_auth_repository.dart';
import 'package:bus_way/ui/auth/login/login_view.dart';
import 'package:bus_way/ui/auth/login/login_viewmodel.dart';
import 'package:bus_way/widget/navigator_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MypageViewmodel with ChangeNotifier {
  LoginAuthRepository loginAuthRepository = LoginAuthRepository();

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
