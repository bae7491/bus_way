// 소개 정보 조회 (관광지 타입 별 정보 조회) API 호출 데이터 중 행사/공연/축제(contentTypeId = 15)를 담을 모델
class EventDetailInfoModel {
  String? eventTel; // 행사/공연/축제 문의 및 안내 (전화번호 형식)
  String? eventPlace; // 행사/공연/축제 위치
  String? eventStartDate; // 행사/공연/축제 시작일
  String? eventEndDate; // 행사/공연/축제 종료일
  String? eventTime; // 행사/공연/축제 시간
  String? eventSponsor1; // 행사/공연/축제 주최자 정보
  String? eventSponsor2; // 행사/공연/축제 주관자 정보
  String? eventFee; // 이용 요금

  EventDetailInfoModel({
    this.eventTel,
    this.eventPlace,
    this.eventStartDate,
    this.eventEndDate,
    this.eventTime,
    this.eventSponsor1,
    this.eventSponsor2,
    this.eventFee,
  });

  factory EventDetailInfoModel.fromJson(Map<String, dynamic> json) {
    return EventDetailInfoModel(
      eventTel: json['sopnsor1tel'] as String?,
      eventPlace: json['eventplace'] as String?,
      eventStartDate: json['eventstartdate'] as String?,
      eventEndDate: json['eventenddate'] as String?,
      eventTime: json['playtime'] as String?,
      eventSponsor1: json['sponsor1'] as String?,
      eventSponsor2: json['sponsor2'] as String?,
      eventFee: json['usetimefestival'] as String?,
    );
  }
}
