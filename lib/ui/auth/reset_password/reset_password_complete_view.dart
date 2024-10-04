import 'package:bus_way/ui/auth/login/login_view.dart';
import 'package:bus_way/ui/auth/reset_password/reset_password_viewmodel.dart';
import 'package:bus_way/widget/custom_continue_button.dart';
import 'package:bus_way/widget/navigator_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordCompleteView extends StatelessWidget {
  const ResetPasswordCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResetPasswordViewModel>(
      builder: (context, resetPasswordViewModel, child) {
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
                        '입력하신 주소로',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 35),
                      Text(
                        '인증 메일을 보냈어요',
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
