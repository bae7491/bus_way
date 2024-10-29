import 'package:bus_way/data/model/travel_model/travel_detail_info_model/travel_detail_info_model.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/widgets/travel_info_row.dart';
import 'package:flutter/material.dart';

class TourSpotDetailInfoView extends StatelessWidget {
  const TourSpotDetailInfoView({
    super.key,
    required this.travelData,
  });

  final TravelDetailInfoModel travelData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 관광지(contentTypeId = 12) 추가 상세 정보
        // 관광지 소개 정보
        if (travelData.travelInfoTel != null)
          travelInfoRow('문의 및 안내', travelData.travelInfoTel!),
        if (travelData.travelUseTime != null)
          travelInfoRow('이용시간', travelData.travelUseTime!),
        if (travelData.travelRestDate != null)
          travelInfoRow('휴일', travelData.travelRestDate!),
        if (travelData.travelParking != null)
          travelInfoRow('주차 시설', travelData.travelParking!),

        // 관광지 반복 정보
      ],
    );
  }
}
