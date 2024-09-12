import 'package:bus_way/data/model/user_model.dart';
import 'package:bus_way/data/respository/auth_repository.dart';
import 'package:flutter/material.dart';

class MainPageViewModel with ChangeNotifier{
  AuthRepository authRepository = AuthRepository();
  UserModel? _user;
  String? _errorMessage;

  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;

  Future<void> signOut() async {
    try {
      await authRepository.signOut();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
