class API {
  static const hostConnect = "http://192.168.200.80/BusWay";
  // static const hostConnect = "http://localhost/BusWay";

  // ================== 이미지 관련 API
  static const hostConnectImage = '$hostConnect/images';

  // 버스 정류장 이미지
  static const busStopImage = '$hostConnectImage/bus_stop_icon.png';
  //==================

  // ================== 회원 관련 DB 요청 API
  static const hostConnectUser = '$hostConnect/user';

  // 회원가입 DB 요청
  static const signup = '$hostConnectUser/signup.php';

  // 고유값 정보 중복 확인 DB 요청
  static const validateUserUnique = '$hostConnectUser/validate_user_unique.php';

  // 비밀번호 변경 DB 요청
  static const updatePassword = '$hostConnectUser/update_password.php';
  //==================

  // ================== DB 요청 API
}
