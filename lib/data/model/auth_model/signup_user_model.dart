/*
  회원가입에서 사용하는 데이터 클래스.
*/
class SignUpUserModel {
  String? email;
  String? password;
  String? name;
  String? phoneNumber;
  String? nickName;

  SignUpUserModel({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
    required this.nickName,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email.toString(),
      'password': password.toString(),
      'name': name.toString(),
      'phoneNumber': phoneNumber.toString(),
      'nickName': nickName.toString(),
    };
  }

  @override
  String toString() {
    return 'SignUpUserModel(email: $email, password: $password, name: $name, phoneNumber: $phoneNumber, nickName: $nickName)';
  }
}
