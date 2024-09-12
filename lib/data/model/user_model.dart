/*
  login에서 사용하는 데이터 클래스.
*/
class UserModel {
  String? email;
  String? password;

  UserModel({
    required this.email,
    required this.password,
  });
}