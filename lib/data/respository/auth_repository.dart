/*
  API 클래스를 주입받아 사용하는 구현체.

  - 역할
    1. login_viewmodel에서 요청한 데이터를 DataSource 폴더 내의 알맞은 곳으로 요청.
    2. 요청한 데이터의 응답을 login_viewmodel로 전달.
*/

import '../datasource/auth_datasource.dart';
import '../model/user_model.dart';

class AuthRepository {
  RemoteAuthDataSource remoteAuthDataSource = RemoteAuthDataSource();

  // 로그인
  Future<UserModel?> login(String email, String password) async {
    await remoteAuthDataSource.loginWithEmail(email, password);
    return UserModel(email: email, password: password);
  }

  // 회원가입
  Future<UserModel?> signUp(String email, String password) async {
    await remoteAuthDataSource.signUpWithEmail(email, password);
    return UserModel(email: email, password: password);
  }

  // 로그아웃
  Future<void> signOut() async {
    await remoteAuthDataSource.signOut();
  }
}