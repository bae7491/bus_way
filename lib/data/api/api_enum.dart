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

// 오픈 API 에러 처리
String getApiMessageForStatusCode(String errorCode) {
  switch (errorCode) {
    case '1' || '01':
      return '어플리케이션 에러입니다.';
    case '4' || '04':
      return 'http 에러입니다.';
    case '12':
      return '해당 API가 없거나 폐기된 API 입니다.';
    case '20':
      return '서비스 접근이 거부되었습니다.';
    case '22':
      return '서비스 요청 제한 회수를 초과했습니다.';
    case '30':
      return '서비스 키가 등록되지 않았습니다.';
    case '31':
      return '활용 기간이 만료 되었습니다.';
    case '32':
      return '등록되지 않은 IP입니다.';
    case '99':
      return '알 수 없는 오류가 발생했습니다.';
    default:
      return '알 수 없는 오류가 발생했습니다.';
  }
}
