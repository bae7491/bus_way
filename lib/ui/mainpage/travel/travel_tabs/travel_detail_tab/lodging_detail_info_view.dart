import 'package:bus_way/data/model/travel_model/travel_detail_info_model/lodging_detail_info_model.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/widgets/travel_info_row.dart';
import 'package:flutter/material.dart';

class LodgingDetailInfoView extends StatelessWidget {
  const LodgingDetailInfoView({
    super.key,
    required this.lodgingData,
  });

  final LodgingDetailInfoModel lodgingData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 숙박(contentTypeId = 32) 추가 상세 정보
        // 숙박 소개 정보
        if (lodgingData.lodgingTel != null)
          travelInfoRow('문의 및 안내', lodgingData.lodgingTel!),
        if (lodgingData.lodgingMaxCount != null)
          travelInfoRow('수용 가능 인원', lodgingData.lodgingMaxCount!),
        if (lodgingData.lodgingInTime != null)
          travelInfoRow('입실 시간', lodgingData.lodgingInTime!),
        if (lodgingData.lodgingOutTime != null)
          travelInfoRow('퇴실 시간', lodgingData.lodgingOutTime!),
        if (lodgingData.foodPlace != null)
          travelInfoRow('식음료장', lodgingData.foodPlace!),
        if (lodgingData.subFacility != null)
          travelInfoRow('부대 시설(기타)', lodgingData.subFacility!),
        if (lodgingData.lodginigScale != null)
          travelInfoRow('규모', lodgingData.lodginigScale!),

        // 숙박 반복 정보
      ],
    );
  }
}
