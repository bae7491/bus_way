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

class RemoteAuthDataSource with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // 1. firebase에 저장된 E-mail 정보로 로그인 요청
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint('Login Error: $e');
      rethrow; // 오류 재전달
    }
  }

  // 2. firebase에 회원가입 요청
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint('SignUp Error: $e');
      rethrow;
    }
  }

  // 3. 로그아웃 요청
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}