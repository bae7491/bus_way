import 'package:bus_way/data/model/travel_model/travel_common_info_model.dart';
import 'package:bus_way/ui/mainpage/travel/travel_detail_viewmodel.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_detail_tab/travel_detail_info_tab.dart';
import 'package:flutter/material.dart';

class TravelDetailTab extends StatelessWidget {
  const TravelDetailTab({
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
    return Expanded(
      child: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.black,
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
                  ), // contentTypeId에 따른 위젯 렌더링),
                  // 두 번째 탭 - 사진
                  const Center(
                    child: Text('사진 탭의 내용이 여기 표시됩니다'),
                  ),

                  // 세 번째 탭 - 후기
                  const Center(
                    child: Text('후기 탭의 내용이 여기 표시됩니다'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
