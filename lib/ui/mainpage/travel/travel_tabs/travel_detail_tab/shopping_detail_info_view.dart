import 'package:bus_way/data/model/travel_model/travel_detail_info_model/shopping_detail_info_model.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/widgets/travel_info_row.dart';
import 'package:flutter/material.dart';

class ShoppingDetailInfoView extends StatelessWidget {
  const ShoppingDetailInfoView({
    super.key,
    required this.shoppingData,
  });

  final ShoppingDetailInfoModel shoppingData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 쇼핑(contentTypeId = 38) 추가 상세 정보
        // 쇼핑 소개 정보
        if (shoppingData.shoppingTel != null)
          travelInfoRow('문의 및 안내', shoppingData.shoppingTel!),
        if (shoppingData.shoppingOpenTime != null)
          travelInfoRow('영업 시간', shoppingData.shoppingOpenTime!),
        if (shoppingData.shoppingRestDate != null)
          travelInfoRow('휴일', shoppingData.shoppingRestDate!),
        if (shoppingData.shoppingItem != null)
          travelInfoRow('판매 목록', shoppingData.shoppingItem!),
        if (shoppingData.shoppingInfo != null)
          travelInfoRow('매장 정보', shoppingData.shoppingInfo!),
        if (shoppingData.shoppingParking != null)
          travelInfoRow('주차 시설', shoppingData.shoppingParking!),

        // 쇼핑 반복 정보
      ],
    );
  }
}
