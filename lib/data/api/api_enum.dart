enum ApiResponseStatus {
  success, // 200 성공
  duplicateUser, // 200 중복값 존재

  badRequest, // 400 잘못된 요청
  unauthorized, // 401 인증 실패
  requestTimeout, // 408 요청 시간 만료
  serverError, // 500 서버 내부 오류
  unknownError, // 기타 알 수 없는 오류
}

// 상태 코드에 따른 메시지 반환
String getMessageForStatusCode(ApiResponseStatus status) {
  switch (status) {
    case ApiResponseStatus.success:
      return "user 테이블에 데이터 추가 성공!!";
    case ApiResponseStatus.duplicateUser:
      return "이미 가입된 정보가 있습니다.";
    case ApiResponseStatus.badRequest:
      return "잘못된 요청입니다. 입력값을 확인해주세요.";
    case ApiResponseStatus.requestTimeout:
      return "요청 시간 만료";
    case ApiResponseStatus.unauthorized:
      return "인증 오류가 발생했습니다. 다시 시도해주세요.";
    case ApiResponseStatus.serverError:
      return "서버 오류가 발생했습니다.";
    case ApiResponseStatus.unknownError:
    default:
      return "알 수 없는 오류가 발생했습니다.";
  }
}
