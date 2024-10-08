/*
  API 클래스를 주입받아 사용하는 구현체.

  - 역할
    1. login_viewmodel에서 요청한 데이터를 DataSource 폴더 내의 알맞은 곳으로 요청.
    2. 요청한 데이터의 응답을 login_viewmodel로 전달.
*/

import 'package:bus_way/data/datasource/auth_local_datasource.dart';
import 'package:bus_way/data/model/signup_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../datasource/auth_remote_datasource.dart';

class LoginAuthRepository {
  final AuthRemoteDataSource remoteAuthDataSource = AuthRemoteDataSource();
  final AuthLocalDatasource localAuthDataSource = AuthLocalDatasource();

  // 로그인
  Future<User?> login(String email, String password) async {
    final user = await remoteAuthDataSource.loginWithEmail(email, password);
    return user;
  }

  // 회원가입
  Future<User?> signUpWithEmail(String email, String password) async {
    final user = await remoteAuthDataSource.signUpWithEmail(email, password);
    return user;
  }

  // DB(mySQL)에 유저 정보 저장
  Future<void> saveUserInfo(SignUpUserModel signUpUser) async {
    await localAuthDataSource.saveUserInfo(signUpUser);
  }

  // 중복 체크 값 검사
  Future<bool> checkUserUnique(
      String email, String phoneNumber, String nickName) async {
    return await localAuthDataSource.checkUserUnique(
        email, phoneNumber, nickName);
  }

  // 로그아웃
  Future<void> signOut() async {
    await remoteAuthDataSource.signOut();
  }

  // 자동 로그인 상태 저장
  Future<void> setAutoLogin(bool autoLogin) async {
    await remoteAuthDataSource.setAutoLogin(autoLogin);
  }

  // 자동 로그인 상태 가져오기
  Future<bool> getAutoLogin() async {
    return await remoteAuthDataSource.getAutoLogin();
  }

  // 비밀번호 재설정 이메일 인증 보내기
  Future<void> resetPassword(String email) async {
    await remoteAuthDataSource.resetPassword(email);
  }

  // 비밀번호 업데이트
  Future<void> updatePassword(String email, String password) async {
    await localAuthDataSource.updatePassword(email, password);
  }

  // 이메일 인증 메일 보내기
  Future<void> verifyEmail() async {
    return await remoteAuthDataSource.verifyEmail();
  }

  // 이메일 인증 확인
  Future<bool> checkVerifyEmail() async {
    return await remoteAuthDataSource.checkVerifyEmail();
  }
}
