/*
  api 호출 클래스.
  localDataSource와 remoteDataSource로 존재.
  login_repository에서 보낸 요청을 DB or API 등으로 데이터를 가져옴.

  - 역할 / (remoteDataSource - 원격 서버를 이용하기 떄문.)
    1. firebase를 이용하여, '이메일 로그인' 요청을 담당. -> auth_repository.dart로 전달.
    2. firebase를 이용하여, '회원가입' 요청을 담당. -> auth_repository.dart로 전달.
    3. firebase를 이용하여, '로그아웃' 요청을 담당. -> auth_repository.dart로 전달.
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRemoteDataSource with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // 1. firebase에 저장된 E-mail 정보로 로그인 요청
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-credential') {
        message = '등록되지 않은 아이디이거나 아이디 또는 비밀번호를 잘못 입력했습니다.';
      } else if (e.code == 'invalid-email') {
        message = '이메일 형식을 다시 확인해 주세요.';
      } else if (e.code == 'wrong-password') {
        message = '비밀번호를 다시 확인해 주세요.';
      } else if (e.code == 'channel-error') {
        message = '아이디 혹은 비밀번호를 입력해주세요.';
      } else if (e.code == 'too-many-requests') {
        message = '일시적인 오류로 로그인을 할 수 없습니다.\n잠시 후 다시 시도해주세요.';
      } else {
        message = '알 수 없는 에러가 발생했습니다.';
      }
      throw Exception(message);
    }
  }

  // 2. firebase에 회원가입 요청
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      debugPrint('email: $email, password: $password');
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('signUp exception: ${e.code}');
      String message = '';
      if (e.code == 'email-already-in-use') {
        message = '이미 존재하는 이메일입니다.';
      } else {
        message = '알 수 없는 에러가 발생했습니다.';
      }
      throw Exception(message);
    }
  }

  // 3. 로그아웃 요청
  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoLogin', false);
    await _firebaseAuth.signOut();
  }

  // 4. 자동 로그인 상태 저장
  Future<void> setAutoLogin(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoLogin', value);
  }

  // 5. 자동 로그인 상태 가져오기
  Future<bool> getAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('autoLogin') ?? false;
  }

  // 6. 비밀번호 재설정 인증 메일 보내기
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = '이메일 형식을 다시 확인해주세요.';
      } else if (e.code == 'missing-android-pkg-name') {
        message = 'Android 앱 설치가 필요할 경우, Android 패키지 이름을 제공해야 합니다.';
      } else if (e.code == 'missing-continue-uri') {
        message = '알맞는 연결 URL을 제공해야 합니다.';
      } else if (e.code == 'missing-ios-bundle-id') {
        message = 'App Store ID가 제공된 경우, iOS 번들 ID를 제공해야 합니다.';
      } else if (e.code == 'invalid-continue-uri') {
        message = '알맞는 URL 문자열이어야 합니다.';
      } else if (e.code == 'unauthorized-continue-uri') {
        message = '연결 URL의 도메인이 허용 목록에 포함되어 있지 않습니다.';
      } else if (e.code == 'user-not-found') {
        message = '해당 이메일 주소와 일치하는 사용자를 찾을 수 없습니다.';
      } else {
        message = '알 수 없는 에러가 발생했습니다.';
      }
      throw Exception(message);
    }
  }

  // 7. 이메일 인증 메일 보내기
  Future<void> verifyEmail() async {
    try {
      await _firebaseAuth.currentUser!.sendEmailVerification();
    } catch (e) {
      String message = '알 수 없는 에러가 발생했습니다.';
      throw Exception(message);
    }
  }

  // 8. 이메일 인증 정보 확인
  Future<bool> checkVerifyEmail() async {
    final user = _firebaseAuth.currentUser;

    if (user != null) {
      // 사용자 정보를 새로고침
      await user.reload();
      final updatedUser = _firebaseAuth.currentUser;

      // 이메일 인증 여부 반환
      return updatedUser!.emailVerified;
    } else {
      return false; // 로그아웃 상태일 때 처리
    }
  }
}
