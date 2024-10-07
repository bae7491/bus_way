class API {
  static const hostConnect = "http://192.168.200.80/BusWay";
  // static const hostConnect = "http://localhost/BusWay";

  // ================== 회원 관련 API
  static const hostConnectUser = '$hostConnect/user';

  // 회원가입
  static const signup = '$hostConnectUser/signup.php';

  // 고유값 정보 중복 확인
  static const validateUserUnique = '$hostConnectUser/validate_user_unique.php';

  // 비밀번호 변경
  static const updatePassword = '$hostConnectUser/update_password.php';
  //==================

  // ================== 회원 관련 API
}
