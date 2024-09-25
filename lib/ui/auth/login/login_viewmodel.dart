/* 
  ViewModel -> Model과 View를 연결하는 역할.
  상태 관리 로직 담당.

  login_viewmodel : auth_repository.dart 및 login_view.dart와 상호작용.

  - 역할
    1. 상태 관리 / Model의 메서드 호출 -> 데이터 가져옴.
      (auth_repository.dart로 연결.)
    2. notifyListeners 추가 후, 이를 통해 데이터에 업데이트가 있다는 것을 ViewModel이 참조하고 있는 View에 알림.
*/

import 'package:bus_way/data/datasource/auth_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../data/model/user_model.dart';
import '../../../data/respository/auth_repository.dart';

class LoginViewModel with ChangeNotifier {
  AuthRepository authRepository = AuthRepository();
  RemoteAuthDataSource remoteAuthDataSource = RemoteAuthDataSource();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _passwordVisible = false;
  bool _autoLogin = false;


  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get passwordVisible => _passwordVisible;
  bool get autoLogin => _autoLogin;

  LoginViewModel () {
    loadAutoLogin();
  }

  // 로그인 상태 관리 로직
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await authRepository.login(email, password);
      _autoLogin = autoLogin;
      await setAutoLogin(autoLogin);
    } on FirebaseAuthException catch (e) {
      debugPrint('e.code: ${e.code}');
      if (e.code == 'invalid-credential') {
        _errorMessage = '등록되지 않은 아이디이거나 아이디 또는 비밀번호를 잘못 입력했습니다.';
      } else if (e.code == 'invalid-email') {
        _errorMessage = '이메일 형식을 다시 확인해 주세요.';
      } else if (e.code == 'wrong-password') {
        _errorMessage = '비밀번호를 다시 확인해 주세요.';
      } else if (e.code == 'channel-error') {
        _errorMessage = '아이디 혹은 비밀번호를 입력해 주세요.';
      } else if (e.code == 'too-many-requests') {
        _errorMessage = '일시적인 오류로 로그인을 할 수 없습니다.\n잠시 후 다시 시도해주세요.';
      } else {
        _errorMessage = '알 수 없는 에러가 발생했습니다.';
      }
    } finally {
      _isLoading = false;
      emailController.clear();
      passwordController.clear();
      notifyListeners();
    }
  }

  // 비밀번호 보이기/숨기기 토글 로직
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  // 자동 로그인 체크 상태 관리 로직
  Future<void> setAutoLogin(bool autoLogin) async {
    _autoLogin = autoLogin;
    await authRepository.setAutoLogin(autoLogin);
    notifyListeners();
  }

  // 자동 로그인 상태 로드
  Future<void> loadAutoLogin() async {
    _autoLogin = await authRepository.getAutoLogin();
    notifyListeners();
  }
}
