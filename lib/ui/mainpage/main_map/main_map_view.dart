import 'package:bus_way/ui/mainpage/main_map/main_map_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainMapView extends StatelessWidget {
  const MainMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainMapViewmodel>(
      builder: (context, mainMapViewModel, child) {
        // 좌표가 준비되면 지도를 표시
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              KakaoMap(
                onMapCreated: (controller) {
                  mainMapViewModel.onMapCreated(controller);
                  // 지도 생성 후 사용자의 현재 위치로 이동
                  if (mainMapViewModel.isLocationReady) {
                    mainMapViewModel.moveCameraToCurrentLocation();
                  }
                },
                onMarkerTap: ((markerId, latLng, zoomLevel) {
                  // 마커를 탭했을 때, 모달 창 나오는 함수 불러오기
                  showCustomModalBottomSheet(context);
                }),
                markers: mainMapViewModel.markers.toList(),
                center: mainMapViewModel.center,
              ),
            ],
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: () {
                  mainMapViewModel.moveCameraToCurrentLocation();
                },
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 5,
                shape: const CircleBorder(),
                child: const Icon(Icons.refresh),
              ),
              const SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                onPressed: () {
                  mainMapViewModel.moveToNewLocation();
                },
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 5,
                shape: const CircleBorder(),
                child: !mainMapViewModel.isLoading
                    ? const Icon(Icons.gps_fixed) // 기본 상태 - gps 아이콘
                    : const SpinKitFadingCircle(
                        color: Colors.black,
                        size: 30,
                      ), // 클릭 상태 - 로딩 아이콘
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  // 마커를 클릭하면 모달 창이 보이는 함수
  void showCustomModalBottomSheet(BuildContext context) {
    // tabBar의 높이와 전체 화면의 높이를 계산하는 변수들
    const double tabBarHeight = 90.0; // TabBar의 높이 설정
    final double maxHeight =
        MediaQuery.of(context).size.height * 0.8; // 화면의 80%

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.1,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
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
                      const PreferredSize(
                        preferredSize:
                            Size.fromHeight(tabBarHeight), // TabBar의 높이 설정
                        child: TabBar(
                          labelColor: Colors.black,
                          indicatorColor: Colors.black,
                          tabs: <Widget>[
                            Tab(text: '버스'),
                            Tab(text: '관광'),
                          ],
                        ),
                      ),
                      // TabBarView 추가
                      SizedBox(
                        height: maxHeight -
                            tabBarHeight, // TabBar height를 제외한 나머지 공간 설정
                        child: TabBarView(
                          children: <Widget>[
                            // 첫 번째 탭: 버스 정류장 정보
                            ListView.builder(
                              itemCount: 10, // 예시 데이터
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(Icons.directions_bus),
                                  title: Text('버스 정류장 $index'),
                                  subtitle: Text('다음 버스 도착: ${index * 2}분'),
                                );
                              },
                            ),
                            // 두 번째 탭: 관광 정보
                            ListView.builder(
                              itemCount: 10, // 예시 데이터
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(Icons.place),
                                  title: Text('관광지 $index'),
                                  subtitle: Text('관광지 설명 $index'),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
