import 'package:bus_way/data/model/firebase_user_model.dart';
import 'package:bus_way/data/respository/auth_repository.dart';
import 'package:flutter/material.dart';

class MainPageViewModel with ChangeNotifier {
  AuthRepository authRepository = AuthRepository();
  FirebaseUserModel? _user;
  String? _errorMessage;

  FirebaseUserModel? get user => _user;
  String? get errorMessage => _errorMessage;

  Future<void> signOut() async {
    await authRepository.signOut();
  }
}
