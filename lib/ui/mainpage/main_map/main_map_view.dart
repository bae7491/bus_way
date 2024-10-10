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
                markers: mainMapViewModel.markers.toList(),
                onMarkerTap: ((markerId, latLng, zoomLevel) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('marker click:\n\n$latLng, $markerId')));
                }),
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
}
