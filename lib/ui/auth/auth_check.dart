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
        // TODO: FirbaseAuth 인증 상태 재확인 필요.

        // 현재 Firebase로 로그인된 User의 상태 확인 가능
        // print('firebaseAuth.instance.currentuser: ${FirebaseAuth.instance.currentUser}');

        // Firebase로 로그인한 User의 토큰 확인 가능 (getIdTokenResult(true): 로그인 토큰 재갱신)
        // FirebaseAuth.instance.currentUser!.getIdTokenResult().then((value) {
        //   print('firebaseAuth.instance.getIdTokenResult: $value');
        // });

        // 현재 인증 상태 확인
        // FirebaseAuth.instance.authStateChanges().listen((User? user) {
        //   print('firebaseAuth.instance.authStateChanges ${user}');
        // });

        // 자동 로그인 체크박스 여부 (true: 켜짐 / false: 꺼짐)
        // print('firebaseAuth.instance/autoLogin ${loginViewModel.autoLogin}');

        // 로그인된 사용자 확인 후, 자동 로그인 여부에 따라 화면 전환
        if (FirebaseAuth.instance.currentUser != null &&
            loginViewModel.autoLogin) {
          return const MainView();
        } else {
          return const LoginView();
        }
      },
    );
  }
}
