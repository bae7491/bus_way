import 'package:bus_way/data/respository/login_auth_repository.dart';
import 'package:bus_way/ui/auth/login/login_view.dart';
import 'package:bus_way/ui/mainpage/mainpage_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAutoLogin(), // 자동 로그인 상태를 비동기적으로 확인
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 비동기 작업이 진행 중일 때 로딩 표시
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // 에러가 발생한 경우
          return const Center(child: Text('Error occurred'));
        } else if (snapshot.hasData) {
          // 자동 로그인 여부에 따라 화면 결정
          final bool isAutoLoginChecked = snapshot.data ?? false;

          final firebaseUser = FirebaseAuth.instance.currentUser;

          // 자동 로그인 체크가 해제된 경우 로그아웃 처리
          if (firebaseUser == null || !isAutoLoginChecked) {
            return const LoginView();
          } else {
            // 자동 로그인이 설정된 경우 메인 화면으로 이동
            return const MainView();
          }
        } else {
          // 데이터가 없을 때 (혹은 기본값 처리)
          return const LoginView();
        }
      },
    );
  }

  // 자동 로그인 여부를 확인하는 함수 (비동기)
  Future<bool> _checkAutoLogin() async {
    LoginAuthRepository loginAuthRepository = LoginAuthRepository();
    return await loginAuthRepository
        .getAutoLogin(); // SharedPreferences에 저장된 자동 로그인 여부 확인
  }
}
