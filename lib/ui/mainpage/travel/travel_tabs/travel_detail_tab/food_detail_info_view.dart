import 'package:bus_way/data/model/travel_model/travel_detail_info_model/food_detail_info_model.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/widgets/travel_info_row.dart';
import 'package:flutter/material.dart';

class FoodDetailInfoView extends StatelessWidget {
  const FoodDetailInfoView({
    super.key,
    required this.foodData,
  });

  final FoodDetailInfoModel foodData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 음식점(contentTypeId = 39) 추가 상세 정보
        // 음식점 소개 정보
        if (foodData.foodTel != null)
          travelInfoRow(context, '문의 및 안내', foodData.foodTel!),
        if (foodData.foodOpenTime != null)
          travelInfoRow(context, '영업 시간', foodData.foodOpenTime!),
        if (foodData.foodRestDate != null)
          travelInfoRow(context, '휴일', foodData.foodRestDate!),
        if (foodData.foodParking != null)
          travelInfoRow(context, '주차 시설', foodData.foodParking!),
        if (foodData.representativeMenu != null)
          travelInfoRow(context, '대표 메뉴', foodData.representativeMenu!),

        // 음식점 반복 정보
      ],
    );
  }
}
