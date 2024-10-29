import 'package:bus_way/data/model/travel_model/travel_detail_info_model/culture_detail_info_model.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/widgets/travel_info_row.dart';
import 'package:flutter/material.dart';

class CultureDetailInfoView extends StatelessWidget {
  const CultureDetailInfoView({
    super.key,
    required this.cultureData,
  });

  final CultureDetailInfoModel cultureData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 문화시설(contentTypeId = 14) 추가 상세 정보
        // 문화시설 소개 정보
        if (cultureData.cultureInfoTel != null)
          travelInfoRow('문의 및 안내', cultureData.cultureInfoTel!),
        if (cultureData.cultureUseTime != null)
          travelInfoRow('이용시간', cultureData.cultureUseTime!),
        if (cultureData.cultureRestDate != null)
          travelInfoRow('휴일', cultureData.cultureRestDate!),
        if (cultureData.cultureParking != null)
          travelInfoRow('주차 시설', cultureData.cultureParking!),
        if (cultureData.cultureUseFee != null)
          travelInfoRow('이용 요금', cultureData.cultureUseFee!),
        if (cultureData.cultureScale != null)
          travelInfoRow('규모', cultureData.cultureScale!),

        // 문화시설 반복 정보
      ],
    );
  }
}
