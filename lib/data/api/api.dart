class API {
  static const hostConnect = "http://192.168.200.80/BusWay";
  // static const hostConnect = "http://localhost/BusWay";

  // ================== 이미지 관련 API
  static const hostConnectImage = '$hostConnect/images';

  // 버스 정류장 icon 이미지
  static const busStopImage = '$hostConnectImage/bus_stop_icon.png';

  // 선택한 버스 정류장 icon 이미지 (모달 창 나올 때 강조)
  static const selectedBusStopImage =
      '$hostConnectImage/selected_bus_stop_icon.png';

  // 내 위치 icon 이미지
  static const myLocationImage = '$hostConnectImage/my_location_icon.png';

  // 관광지 icon 이미지
  static const travelLocationImage =
      '$hostConnectImage/travel_location_icon.png';
  // ==================

  // ================== 회원 관련 DB 요청 API
  static const hostConnectUser = '$hostConnect/user';

  // 회원가입 DB 요청
  static const signup = '$hostConnectUser/signup.php';

  // 고유값 정보 중복 확인 DB 요청
  static const validateUserUnique = '$hostConnectUser/validate_user_unique.php';

  // 비밀번호 변경 DB 요청
  static const updatePassword = '$hostConnectUser/update_password.php';

  // 회원 계정 삭제
  static const deleteUser = '$hostConnectUser/delete_user.php';
  // ==================

  // ================== 관광지 DB 요청 API
  static const hostConnectTravel = '$hostConnect/travel';

  // 관광지 팔로우 DB 요청
  static const travelFollow = '$hostConnectTravel/travel_follow.php';

  // 관광지 언팔로우 DB 요청
  static const travelUnFollow = '$hostConnectTravel/travel_unfollow.php';

  // 선택 관광지 팔로우 정보 DB 체크
  static const checkTravelFollow = '$hostConnectTravel/check_travel_follow.php';
  // ==================

  // ================== 관광지 리뷰 DB 요청 API
  static const hostConnectReview = '$hostConnect/review';

  // 관광지 리뷰 업로드 DB 요청
  static const uploadTravelReview =
      '$hostConnectReview/upload_travel_review.php';

  // 관광지 리뷰 총 개수, 평점 평균 조회
  static const getTravelReviewSummary =
      '$hostConnectReview/get_travel_review_summary.php';

  // 관광지 리뷰 조회
  static const getTravelReviewInfo = '$hostConnectReview/get_travel_review.php';

  // 선택 관광지 상세 후기 조회
  static const getTravelReviewDetail =
      '$hostConnectReview/get_travel_review_detail.php';
  // ==================

  // ================== 마이페이지 DB 요청 API
  static const hostConnectMyPage = '$hostConnect/mypage';

  // 로그인 회원 정보 조회
  static const getUserInfo = '$hostConnectMyPage/get_user_info.php';

  // 회원의 관광지 팔로우 & 후기 총 개수 조회
  static const getFollowReviewCount =
      '$hostConnectMyPage/get_follow_review_summary.php';

  // 회원의 관광지 팔로우 목록 조회
  static const getFollowList = '$hostConnectMyPage/get_follow_list.php';

  // 회원의 관광지 후기 목록 조회
  static const getReviewList = '$hostConnectMyPage/get_review_list.php';

  // 회원의 관광지 후기 삭제
  static const deleteReview = '$hostConnectMyPage/delete_review.php';

  // 회원의 관광지 후기 수정
  static const modifyReview = '$hostConnectMyPage/modify_review.php';

  // 회원의 내정보 수정
  static const modifyUserInfo = '$hostConnectMyPage/modify_user_info.php';
  // ==================

  // ================= 공공 데이터 =================
  // 공공 데이터 전역 URL
  static const publicDataUrl = 'apis.data.go.kr';
  // ================== 버스 공공 데이터 API (TAGO 버스정류소정보 API)
  // 좌표 기반 근접(500m 이내) 정류소 목록 조회
  static const getNearBusStop =
      '1613000/BusSttnInfoInqireService/getCrdntPrxmtSttnList';
  // ==================

  // ================== 버스 공공 데이터 API (부산 버스 공공 데이터 API)
  // 정류소 도착 정보 조회 (정류장 ID)
  static const getBusArriveInfo = '6260000/BusanBIMS/stopArrByBstopid';

  // 노선 정보 조회 (버스 상세 정보)
  static const getBusDetailInfo = '6260000/BusanBIMS/busInfo';

  // 노선 정류소 조회 (해당 버스 전체 노선 불러오기)
  static const getBusLineInfo = '6260000/BusanBIMS/busInfoByRouteId';

  // 정류소 정보 조회 (버스 정류소 ID로 위,경도 찾기)
  static const getBusStopInfo = '6260000/BusanBIMS/busStopList';
  // ==================

  // ================== 관광 공공 데이터 API (한국관광공사 Tour API)
  // 위치 기반 관광 정보 조회
  static const getNearTourInfo = 'B551011/KorService1/locationBasedList1';

  // 공통 정보 조회
  static const getTravelCommonInfo = 'B551011/KorService1/detailCommon1';

  // 소개 정보 조회 (관광지 타입 별 정보 조회)
  static const getTravelDetailInfo = 'B551011/KorService1/detailIntro1';

  // 이미지 정보 조회
  static const getTravelImageInfo = 'B551011/KorService1/detailImage1';

  // ================== 네이버 API
  //네이버 API 전역 URL
  static const naverUrl = 'openapi.naver.com';

  // 네이버 블로그 검색
  static const getTravelBlogInfo = 'v1/search/blog.json';
}
