/*
  login에서 사용하는 데이터.
*/
class AuthInfo {
  String? emailAddress;
  String? password;

  // 요청을 기다리는 동안 로딩을 구현하기 위해 사용
  bool? loading;

  AuthInfo({
    this.emailAddress,
    this.password,
    this.loading,
  });
}