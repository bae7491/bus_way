import 'package:bus_way/ui/auth/login/login_view.dart';
import 'package:bus_way/ui/auth/signup/signup_viewmodel.dart';
import 'package:bus_way/widget/custom_continue_button.dart';
import 'package:bus_way/widget/navigator_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpCompleteView extends StatelessWidget {
  const SignUpCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpViewModel>(
      builder: (context, signUpViewModel, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 185),
                      Text(
                        '회원가입 완료!',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 35),
                      Text(
                        '로그인 화면으로 돌아갑니다.',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: CustomContinueButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            const NavigatorAnimation(destination: LoginView())
                                .createRoute(SlideDirection.bottomToTop));
                      },
                      text: '돌아가기'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
