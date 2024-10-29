import 'package:bus_way/data/model/travel_model/travel_detail_info_model/event_detail_info_model.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/widgets/travel_info_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailInfoView extends StatelessWidget {
  const EventDetailInfoView({
    super.key,
    required this.eventData,
  });

  final EventDetailInfoModel eventData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 행사/공연/축제(contentTypeId = 15) 추가 상세 정보
        // 행사/공연/축제 소개 정보
        if (eventData.eventTel != null)
          travelInfoRow('문의 및 안내', eventData.eventTel!),
        if (eventData.eventPlace != null)
          travelInfoRow('장소', eventData.eventPlace!),
        if (eventData.eventStartDate != null)
          travelInfoRow(
            '시작일',
            DateFormat('yyyy.MM.dd.').format(
              DateTime.parse(eventData.eventStartDate!),
            ),
          ),
        if (eventData.eventEndDate != null)
          travelInfoRow(
            '종료일',
            DateFormat('yyyy.MM.dd.').format(
              DateTime.parse(eventData.eventEndDate!),
            ),
          ),
        if (eventData.eventTime != null)
          travelInfoRow('시간', eventData.eventTime!),
        if (eventData.eventSponsor1 != null)
          travelInfoRow('주최', eventData.eventSponsor1!),
        if (eventData.eventSponsor2 != null)
          travelInfoRow('주관', eventData.eventSponsor2!),
        if (eventData.eventFee != null)
          travelInfoRow('이용 요금', eventData.eventFee!),

        // 행사/공연/축제 반복 정보
      ],
    );
  }
}
