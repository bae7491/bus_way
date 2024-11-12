/*
  API 클래스를 주입받아 사용하는 구현체.

  - 역할
    1. login_viewmodel에서 요청한 데이터를 DataSource 폴더 내의 알맞은 곳으로 요청.
    2. 요청한 데이터의 응답을 login_viewmodel로 전달.
*/

import 'package:bus_way/data/datasource/auth_datasource/auth_local_datasource.dart';
import 'package:bus_way/data/model/auth_model/signup_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../datasource/auth_datasource/auth_remote_datasource.dart';

class LoginAuthRepository {
  final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource();
  final AuthLocalDatasource authLocalDatasource = AuthLocalDatasource();

  // 로그인
  Future<User?> login(String email, String password) async {
    final user = await authRemoteDataSource.loginWithEmail(email, password);
    return user;
  }

  // 회원가입
  Future<User?> signUpWithEmail(String email, String password) async {
    final user = await authRemoteDataSource.signUpWithEmail(email, password);
    return user;
  }

  // DB(mySQL)에 유저 정보 저장
  Future<void> saveUserInfo(SignUpUserModel signUpUser) async {
    await authLocalDatasource.saveUserInfo(signUpUser);
  }

  // 중복 체크 값 검사
  Future<bool> checkUserUnique(
      String email, String phoneNumber, String nickName) async {
    return await authLocalDatasource.checkUserUnique(
        email, phoneNumber, nickName);
  }

  // Firebase 계정 탈퇴
  Future<void> withDraw() async {
    await authRemoteDataSource.withDraw();
  }

  // DB의 계정 탈퇴
  Future<void> deleteUser() async {
    await authLocalDatasource.deleteUser();
  }

  // 로그아웃
  Future<void> signOut() async {
    await authRemoteDataSource.signOut();
  }

  // 자동 로그인 상태 저장
  Future<void> setAutoLogin(bool autoLogin) async {
    await authRemoteDataSource.setAutoLogin(autoLogin);
  }

  // 자동 로그인 상태 가져오기
  Future<bool> getAutoLogin() async {
    return await authRemoteDataSource.getAutoLogin();
  }

  // 비밀번호 재설정 이메일 인증 보내기
  Future<void> resetPassword(String email) async {
    await authRemoteDataSource.resetPassword(email);
  }

  // 비밀번호 업데이트
  Future<void> updatePassword(String email, String password) async {
    await authLocalDatasource.updatePassword(email, password);
  }

  // 이메일 인증 메일 보내기
  Future<void> verifyEmail() async {
    return await authRemoteDataSource.verifyEmail();
  }

  // 이메일 인증 확인
  Future<bool> checkVerifyEmail() async {
    return await authRemoteDataSource.checkVerifyEmail();
  }

  // 로그인한 이메일 정보 저장
  Future<void> setEmailInfo(String email) async {
    await authRemoteDataSource.setEmailInfo(email);
  }
}
