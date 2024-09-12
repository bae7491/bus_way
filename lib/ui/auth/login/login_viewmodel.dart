/* 
  ViewModel -> Model과 View를 연결하는 역할.
  상태 관리 로직 담당.

  login_viewmodel : auth_repository.dart 및 login_view.dart와 상호작용.

  - 역할
    1. 상태 관리 / Model의 메서드 호출 -> 데이터 가져옴.
      (auth_repository.dart(이름 미정)로 연결.)
    2. notifyListeners 추가 후, 이를 통해 데이터에 업데이트가 있다는 것을 ViewModel이 참조하고 있는 View에 알림.
*/

import 'package:flutter/material.dart';
import '../../../data/model/user_model.dart';
import '../../../data/respository/auth_repository.dart';

class LoginViewModel with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;


  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 로그인 상태 관리 로직
  Future<void> login(String email, String password) async {
    AuthRepository authRepository = AuthRepository();
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await authRepository.login(email, password);
      if (_user == null) {
        _errorMessage = '로그인 실패';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  } 
}
