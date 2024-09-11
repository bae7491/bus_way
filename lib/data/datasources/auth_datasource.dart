/*
  localDataSource와 remoteDataSource로 존재.
  login_repository에서 보낸 요청을 DB or API 등으로 데이터를 가져옴.

  - 역할 / (remoteDataSource - 원격 서버를 이용하기 떄문.)
    1. firebase를 이용하여, '이메일 로그인' 요청을 담당. -> auth_repository.dart로 전달.
    2. firebase를 이용하여, '회원가입' 요청을 담당. -> auth_repository.dart로 전달.
    3. firebase를 이용하여, '로그아웃' 요청을 담당. -> auth_repository.dart로 전달.
*/

import 'package:firebase_auth/firebase_auth.dart';
import '../models/auth_model.dart';

abstract class AuthDatasource {
  Future<User?> loginWithEmail(AuthInfo authInfo);
  Future<User?> signUpWithEmail(AuthInfo authInfo);
  Future<void> logout();
}

class RemoteLoginDataSource implements AuthDatasource {
  final FirebaseAuth _firebaseAuth;

  RemoteLoginDataSource(this._firebaseAuth);

  @override
  Future<User?> loginWithEmail(AuthInfo authInfo) async {
    try {
      authInfo.loading = true;

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: authInfo.emailAddress!, 
        password: authInfo.password!
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } finally {
      authInfo.loading = false;
    }
  }

  @override
  Future<User?> signUpWithEmail(AuthInfo authInfo) async {}

  @override
  Future<User?> logout() async {}
}