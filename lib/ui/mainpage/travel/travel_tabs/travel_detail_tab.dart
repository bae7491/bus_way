import 'package:bus_way/data/model/travel_model/travel_common_info_model.dart';
import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/travel/travel_detail_viewmodel.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_detail_tab/travel_detail_info_tab.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_image_tab/travel_image_tab.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_review_tab/travel_review_tab.dart';
import 'package:flutter/material.dart';

class TravelDetailTab extends StatelessWidget {
  const TravelDetailTab({
    super.key,
    required this.viewmodel,
    required this.contentId,
    required this.contentTypeId,
    required this.detailData,
    required this.travelCommonInfo,
  });

  final TravelDetailViewModel viewmodel;
  final String contentId;
  final String contentTypeId;
  final dynamic detailData;
  final TravelCommonInfoModel travelCommonInfo;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.black,
            indicatorColor: orchid,
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Tab(text: '상세 정보'),
              Tab(text: '사진'),
              Tab(text: '후기'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // 첫 번째 탭 - 상세 정보
                TravelDetailInfoTab(
                  viewmodel: viewmodel,
                  contentTypeId: contentTypeId,
                  detailData: detailData,
                  travelCommonInfo: travelCommonInfo,
                ),

                // 두 번째 탭 - 사진
                TravelImageTab(
                  viewmodel: viewmodel,
                  contentId: contentId,
                ),

                // 세 번째 탭 - 후기
                TravelReviewTab(
                  viewmodel: viewmodel,
                  title: travelCommonInfo.travelTitle!,
                  contentId: contentId,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
