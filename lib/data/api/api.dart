class API {
  static const hostConnect = "http://192.168.200.80/BusWay";
  // static const hostConnect = "http://localhost/BusWay";

  // 회원 관련 API
  static const hostConnectUser = '$hostConnect/user';
  static const signup = '$hostConnectUser/signup.php';
  static const validateUserUnique = '$hostConnectUser/validate_user_unique.php';
}
