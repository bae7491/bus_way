// contentTypeId에 따라 위젯을 다르게 렌더링하는 함수
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/culture_detail_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/event_detail_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/food_detail_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/travel_detail_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TravelDetailTabView extends StatelessWidget {
  const TravelDetailTabView({
    super.key,
    required this.contentTypeId,
    required this.detailData,
  });

  final String contentTypeId;
  final dynamic detailData;

  @override
  Widget build(BuildContext context) {
    switch (contentTypeId) {
      case '12':
        final travelData = detailData as TravelDetailInfoModel;
        return Column(
          children: [
            if (travelData.travelInfoTel != null)
              Text(
                  '문의 및 안내: ${travelData.travelInfoTel!.replaceAll('<br>', '\n').replaceAll('\\n', '\n') ?? '정보 없음'}'),
            if (travelData.travelUseTime != null)
              Text(
                  '이용 시간: ${travelData.travelUseTime!.replaceAll('<br>', '\n').replaceAll('\\\\n', '\n') ?? '정보 없음'}'),
            Text('휴일: ${travelData.travelRestDate ?? '정보 없음'}'),
            Text('주차 시설: ${travelData.travelParking ?? '정보 없음'}'),
          ],
        );
      case '14':
        final cultureData = detailData as CultureDetailInfoModel;
        return Column(
          children: [
            Text('문화시설 문의: ${cultureData.travelCultureInfoTel ?? '정보 없음'}'),
            if (cultureData.travelCultureUseTime != null)
              Text(
                  '이용 시간: ${cultureData.travelCultureUseTime!.replaceAll('<br>', '\n').replaceAll('\\n', '').replaceAll('\\', '')}'),
            Html(
                data: cultureData.travelCultureUseTime!
                    .replaceAll('\\\\n', '\n')),
            Text('휴일: ${cultureData.cultureRestDate ?? '정보 없음'}'),
            Text('규모: ${cultureData.cultureScale ?? '정보 없음'}'),
            Text(
                '주자 시설: ${cultureData.cultureParking!.replaceAll('<br>', '\n')}'),
          ],
        );
      case '15':
        final eventData = detailData as EventDetailInfoModel;
        return Column(
          children: [
            Text('행사 장소: ${eventData.eventPlace ?? '정보 없음'}'),
            Text('시작일: ${eventData.eventStartDate ?? '정보 없음'}'),
            Text('종료일: ${eventData.eventEndDate ?? '정보 없음'}'),
            Text('문의: ${eventData.eventTel ?? '정보 없음'}'),
          ],
        );
      case '39':
        final foodData = detailData as FoodDetailInfoModel;
        return Column(
          children: [
            Html(data: foodData.representativeMenu),
          ],
        );
      // 추가적인 contentTypeId에 따른 위젯 처리
      default:
        return const Center(child: Text('유효한 데이터가 없습니다.'));
    }
  }
}
