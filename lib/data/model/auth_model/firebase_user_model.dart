/*
  firebase에서 사용하는 데이터 클래스.
*/
class FirebaseUserModel {
  String? email;
  String? password;
  bool? emailVerified;

  FirebaseUserModel({
    required this.email,
    required this.password,
    required this.emailVerified,
  });
}
