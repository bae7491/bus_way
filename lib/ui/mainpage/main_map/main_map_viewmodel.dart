import 'package:bus_way/data/respository/login_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMapViewmodel with ChangeNotifier {
  LoginAuthRepository loginAuthRepository = LoginAuthRepository();

  KakaoMapController? _mapController;
  LatLng _center = LatLng(35.1797, 129.0746); // 초기 좌표를 부산 시청으로 설정
  bool _isLocationReady = false;

  KakaoMapController? get mapController => _mapController;
  LatLng get center => _center;
  bool get isLocationReady => _isLocationReady;

  MainMapViewmodel() {
    // 저장된 좌표를 불러오고, 없다면 현재 위치를 가져옴
    _loadSavedLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  // SharedPreferences에 현재 좌표 저장
  Future<void> _saveLocation(double latitude, double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
  }

  // SharedPreferences에서 저장된 좌표를 불러오는 함수
  Future<void> _loadSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? savedLat = prefs.getDouble('latitude');
    double? savedLng = prefs.getDouble('longitude');

    if (savedLat != null && savedLng != null) {
      // 로컬에 저장된 좌표가 있다면 그 좌표로 설정
      _center = LatLng(savedLat, savedLng);
      _isLocationReady = true;
    } else {
      // 저장된 좌표가 없으면 현재 위치 불러오기
      getLocation();
    }
    notifyListeners();
  }

  // 현재 본인 좌표 불러오기
  Future<void> getLocation() async {
    // 좌표 권한 설정 확인
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('permissions are denied');
      }
    }

    // 현재 좌표 불러오기
    await Geolocator.getCurrentPosition().then((value) {
      _center = LatLng(value.latitude, value.longitude);
      _isLocationReady = true;
      _saveLocation(
          value.latitude, value.longitude); // SharedPreferences에 현재 좌표 저장
      notifyListeners();
      moveCameraToCurrentLocation(); // 위치가 업데이트된 후 카메라를 이동
    });
  }

  // 지도 불러오기 (만들기)
  void onMapCreated(KakaoMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  // 좌표가 설정된 후 카메라 이동
  void moveCameraToCurrentLocation() {
    _mapController!.panTo(_center);
  }
}
