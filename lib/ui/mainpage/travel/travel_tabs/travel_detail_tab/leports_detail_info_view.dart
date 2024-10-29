import 'package:bus_way/data/model/travel_model/travel_detail_info_model/leports_detail_info_model.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/widgets/travel_info_row.dart';
import 'package:flutter/material.dart';

class LeportsDetailInfoView extends StatelessWidget {
  const LeportsDetailInfoView({
    super.key,
    required this.leportsData,
  });

  final LeportsDetailInfoModel leportsData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 레포츠(contentTypeId = 28) 추가 상세 정보
        // 레포츠 소개 정보
        if (leportsData.leportsTel != null)
          travelInfoRow('문의 및 안내', leportsData.leportsTel!),
        if (leportsData.leportsUseTime != null)
          travelInfoRow('이용 시간', leportsData.leportsUseTime!),
        if (leportsData.leportsRestDate != null)
          travelInfoRow('휴일', leportsData.leportsRestDate!),
        if (leportsData.leportsParking != null)
          travelInfoRow('주차', leportsData.leportsParking!),
        if (leportsData.leportsOpenPeriod != null)
          travelInfoRow('개장 기간', leportsData.leportsOpenPeriod!),

        // 레포츠 반복 정보
      ],
    );
  }
}
