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
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
