import 'package:flutter/material.dart';

import '../../../main_map_viewmodel.dart';
import 'bus_tab.dart';
import 'travel_tab.dart';

class InfoTabbar extends StatelessWidget {
  const InfoTabbar({
    super.key,
    required this.viewmodel,
    required this.scrollController,
    required this.maxHeight,
    required this.tabBarHeight,
    required this.busStopId,
  });

  final MainMapViewmodel viewmodel;
  final ScrollController scrollController;
  final double maxHeight;
  final double tabBarHeight;
  final String busStopId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          children: [
            // 드래그 핸들러처럼 보이는 디자인 요소
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              width: 50.0,
              height: 3.0,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
            const SizedBox(height: 10),
            // TabBar 추가
            const TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: <Widget>[
                Tab(text: '버스'),
                Tab(text: '관광'),
              ],
            ),
            // TabBarView 추가
            SizedBox(
              height: maxHeight -
                  (tabBarHeight + 20), // TabBar height를 제외한 나머지 공간 설정
              child: TabBarView(
                children: <Widget>[
                  BusTab(
                    viewmodel: viewmodel,
                    busStopId: busStopId,
                    scrollController: scrollController,
                  ),
                  // 두 번째 탭: 관광 정보
                  TravelTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
