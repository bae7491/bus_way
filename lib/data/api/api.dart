class API {
  static const hostConnect = "http://192.168.200.80/BusWay";
  // static const hostConnect = "http://localhost/BusWay";

  // ================== 이미지 관련 API
  static const hostConnectImage = '$hostConnect/images';

  // 버스 정류장 icon 이미지
  static const busStopImage = '$hostConnectImage/bus_stop_icon.png';

  // 내 위치 icon 이미지
  static const myLocationImage = '$hostConnectImage/my_location_icon.png';
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

  // ================= 공공 데이터
  // 공공 데이터 전역 url
  static const tagoBusStop = 'apis.data.go.kr';
  // ================== 버스 공공 데이터 API (TAGO 버스정류소정보 API)
  // 좌표 기반 근접(500m 이내) 정류소 목록 조회
  static const getNearBusStop =
      '1613000/BusSttnInfoInqireService/getCrdntPrxmtSttnList';
  //==================

  // ================== 버스 공공 데이터 API (부산 버스 공공 데이터 API)
  // 정류소 도착 정보 조회 (정류장 ID)
  static const getBusStopInfo = '6260000/BusanBIMS/stopArrByBstopid';
  //==================
}
