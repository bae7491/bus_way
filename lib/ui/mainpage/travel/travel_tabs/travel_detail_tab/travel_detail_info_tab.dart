// contentTypeId에 따라 위젯을 다르게 렌더링하는 함수
import 'package:bus_way/data/model/travel_model/travel_common_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/culture_detail_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/event_detail_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/food_detail_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/leports_detail_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/lodging_detail_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/shopping_detail_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/travel_detail_info_model.dart';
import 'package:bus_way/ui/mainpage/travel/travel_detail_viewmodel.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_detail_tab/culture_detail_info_view.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_detail_tab/event_detail_info_view.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_detail_tab/food_detail_info_view.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_detail_tab/leports_detail_info_view.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_detail_tab/lodging_detail_info_view.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_detail_tab/shopping_detail_info_view.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_detail_tab/tour_spot_detail_info_view.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/widgets/travel_info_row.dart';
import 'package:bus_way/widget/custom_html_converter.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class TravelDetailInfoTab extends StatelessWidget {
  const TravelDetailInfoTab({
    super.key,
    required this.viewmodel,
    required this.contentTypeId,
    required this.detailData,
    required this.travelCommonInfo,
  });

  final TravelDetailViewModel viewmodel;
  final String contentTypeId;
  final dynamic detailData;
  final TravelCommonInfoModel travelCommonInfo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 관광지 상세 소개 영역
            const Text(
              '상세정보',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            if (travelCommonInfo.travelOverview != null &&
                travelCommonInfo.travelOverview != '-')
              Container(
                padding: const EdgeInsets.all(8.0), // 내부 여백 설정
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // 테두리 색상 및 굵기 설정
                  borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게 설정
                  color: Colors.white, // 배경색 설정
                ),
                child: customHtmlWidget(
                    travelCommonInfo.travelOverview!, viewmodel),
              ),
            const SizedBox(height: 30.0),

            // 관광지 지도 영역
            SizedBox(
              height: 300,
              child: IgnorePointer(
                // 지도 클릭 방지
                ignoring: true,
                child: KakaoMap(
                  onMapCreated: (controller) async {
                    viewmodel.onMapCreated(
                      context,
                      controller,
                      LatLng(
                        double.parse(travelCommonInfo.travelLatitude!),
                        double.parse(travelCommonInfo.travelLongitude!),
                      ),
                    );
                  },
                  markers: viewmodel.marker.toList(),
                  center: LatLng(
                    double.parse(travelCommonInfo.travelLatitude!),
                    double.parse(travelCommonInfo.travelLongitude!),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),

            // 공통 정보
            const Divider(
              height: 1,
            ),
            if (travelCommonInfo.travelAddr != null)
              travelInfoRow('주소', travelCommonInfo.travelAddr!),
            if (travelCommonInfo.travelHomePage != null)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            '홈페이지',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: customHtmlWidget(
                              travelCommonInfo.travelHomePage!, viewmodel),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                ],
              ),

            // 관광지 타입 별 상세 정보(소개 정보 & 반복 정보)
            renderContentBasedOnType(),
          ],
        ),
      ),
    );
  }

  // 관광지 컨텐츠 타입 별 상세 정보 불러오는 위젯
  Widget renderContentBasedOnType() {
    switch (contentTypeId) {
      case '12': // 관광지
        final travelData = detailData as TravelDetailInfoModel;
        return TourSpotDetailInfoView(
          travelData: travelData,
        );
      case '14': // 문화시설
        final cultureData = detailData as CultureDetailInfoModel;
        return CultureDetailInfoView(
          cultureData: cultureData,
        );
      case '15': // 행사/공연/축제
        final eventData = detailData as EventDetailInfoModel;
        return EventDetailInfoView(
          eventData: eventData,
        );
      // case '25': // 여행코스
      case '28': // 레포츠
        final leportsData = detailData as LeportsDetailInfoModel;
        return LeportsDetailInfoView(
          leportsData: leportsData,
        );
      case '32': // 숙박
        final lodgingData = detailData as LodgingDetailInfoModel;
        return LodgingDetailInfoView(
          lodgingData: lodgingData,
        );
      case '38': // 쇼핑
        final shoppingData = detailData as ShoppingDetailInfoModel;
        return ShoppingDetailInfoView(
          shoppingData: shoppingData,
        );
      case '39': // 음식점
        final foodData = detailData as FoodDetailInfoModel;
        return FoodDetailInfoView(
          foodData: foodData,
        );
      // 추가적인 contentTypeId에 따른 위젯 처리
      default:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded, // 경고 아이콘
                size: 50.0, // 아이콘 크기
                color: Colors.orange, // 아이콘 색상
              ),
              SizedBox(height: 16), // 텍스트와 아이콘 사이 간격
              Text(
                '유효한 데이터가 없습니다!',
                style: TextStyle(
                  fontSize: 18, // 텍스트 크기
                  fontWeight: FontWeight.bold, // 텍스트 굵기
                  color: Colors.black, // 텍스트 색상
                ),
              ),
            ],
          ),
        );
    }
  }
}
