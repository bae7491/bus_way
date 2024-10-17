import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/main_map/main_map_viewmodel.dart';
import 'package:bus_way/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';

import 'widgets/bottomsheet/bottom_sheet.dart';

class MainMapView extends StatelessWidget {
  const MainMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainMapViewmodel>(
      builder: (context, mainMapViewModel, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mainMapViewModel.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackbar(content: Text(mainMapViewModel.errorMessage!)),
            );
            mainMapViewModel.clearErrorMessage();
          }
        });
        // 좌표가 준비되면 지도를 표시
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              KakaoMap(
                onMapCreated: (controller) {
                  mainMapViewModel.onMapCreated(context, controller);
                  // 지도 생성 후 사용자의 현재 위치로 이동
                  if (mainMapViewModel.isLocationReady) {
                    mainMapViewModel.moveCameraToCurrentLocation();
                  }
                },
                onMarkerTap: ((markerId, latLng, zoomLevel) {
                  if (markerId != '0') {
                    // 마커의 위치를 중심으로 카카오맵 이동
                    mainMapViewModel.moveToMarkerLocation(latLng);

                    // 마커 탭 후, 해당 정류소의 버스 불러오기.
                    mainMapViewModel
                        .loadBusStopInfo(markerId)
                        .then((isSuccess) {
                      if (isSuccess && context.mounted) {
                        // 마커를 탭했을 때, 모달 창 나오는 함수 불러오기
                        showCustomModalBottomSheet(context, markerId);
                      }
                    });

                    // TODO: 선택된 마커 크기 키우기 or 마커 강조 (다른 색상) 아이콘 추가해서 변경
                    mainMapViewModel.increaseSelectedMarker(markerId, latLng);
                  }
                }),
                markers: mainMapViewModel.markers.toList(),
                center: mainMapViewModel.center,
              ),

              // 기능 동작 중일 때, 로딩 애니메이션 보이기
              if (mainMapViewModel.isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.grey.withOpacity(0.3),
                    child: const Center(
                      child: SpinKitRing(
                        color: orchid,
                        size: 120,
                        lineWidth: 12.0,
                      ), // 로딩 인디케이터
                    ), // 회색 배경
                  ),
                ),

              // 현 지도에서 재검색
              if (!mainMapViewModel.isBottomSheetVisible)
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        if (mainMapViewModel.isLoading == false) {
                          // 현재 지도의 중심으로 이동
                          mainMapViewModel
                              .moveCameraToMapCenterLocation(context);
                        }
                      },
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('현 지도에서 재검색'),
                    ),
                  ),
                ),

              // 현재 위치 재설정 FloatingActionButton
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  child:
                      // 현재 위치를 재설정 (GPS 아이콘 클릭)
                      FloatingActionButton(
                    onPressed: () {
                      if (mainMapViewModel.isLoading == false) {
                        mainMapViewModel.moveToNewLocation(context);
                      }
                    },
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 5,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.gps_fixed), // 기본 상태 - gps 아이콘
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
