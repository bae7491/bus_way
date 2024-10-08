import 'package:bus_way/ui/mainpage/main_map/main_map_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';

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
                center: mainMapViewModel.center, // 준비된 좌표로 지도를 중심으로 설정
              ),
            ],
          ),
        );
      },
    );
  }
}
