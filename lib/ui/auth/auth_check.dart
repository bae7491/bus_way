// 앱 재기동 시, main.dart에서 auth_check.dart로 이동해서, firebase 유저 여부와 자동 로그인 여부를 확인하여, 로그인 화면 or 메인 화면 결정.

import 'package:bus_way/ui/auth/login/login_view.dart';
import 'package:bus_way/ui/auth/login/login_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mainpage_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        // 자동 로그인 여부 확인
        final firebaseUser = FirebaseAuth.instance.currentUser;
        final isAutoLoginChecked = loginViewModel.autoLogin;

        // 자동 로그인 체크가 해제된 경우 로그아웃
        if (firebaseUser == null) {
          // 자동 로그인 체크 해제된 경우 로그아웃
          FirebaseAuth.instance.signOut();
        }

        // 자동 로그인 체크가 되어 있을 때
        if (firebaseUser != null && isAutoLoginChecked) {
          return const MainView();
        } else {
          // 자동 로그인이 해제되었거나 사용자가 없을 때
          return const LoginView();
        }
      },
    );
  }
}
