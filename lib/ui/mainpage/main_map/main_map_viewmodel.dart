import 'package:bus_way/data/model/bus_model/bus_stop_info_model.dart';
import 'package:bus_way/data/model/bus_model/near_bus_stop_model.dart';
import 'package:bus_way/data/respository/bus_repository/bus_repository.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bus_way/data/api/api.dart';

class MainMapViewmodel with ChangeNotifier {
  BusRepository busRepository = BusRepository();

  KakaoMapController? _mapController;
  LatLng _center = LatLng(35.1797, 129.0746); // 초기 좌표를 부산 시청으로 설정
  bool _isLoading = false;
  bool _isRefreshLoading = false;
  bool _isBottomSheetVisible = false;
  bool _isLocationReady = false;
  final Set<Marker> _markers = {};
  List<NearBusStopModel>? _busStopModel;
  List<BusStopInfoModel>? _busStopInfoModel;
  String? _errorMessage;

  KakaoMapController? get mapController => _mapController;
  LatLng get center => _center;
  bool get isLoading => _isLoading;
  bool get isRefreshLoading => _isRefreshLoading;
  bool get isBottomSheetVisible => _isBottomSheetVisible;
  bool get isLocationReady => _isLocationReady;
  Set<Marker> get markers => _markers;
  List<NearBusStopModel>? get busStopList => _busStopModel;
  List<BusStopInfoModel>? get busStopInfoModel => _busStopInfoModel;
  String? get errorMessage => _errorMessage;

  MainMapViewmodel(BuildContext context) {
    // 저장된 좌표를 불러오고, 없다면 현재 위치를 가져옴
    loadSavedLocation(context);
  }

  // 메모리 누수 방지를 위한 리소스 해제
  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  // 에러 메시지 초기화
  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  // 버스 API로 주변 500m 정류장 가져와서 마커로 찍기
  Future<void> getNearBusStop(LatLng center) async {
    _isLoading = true;
    notifyListeners();

    try {
      _busStopModel = await busRepository.getNearBusStop(_center);
      _markers.clear();

      // 본인 위치 마커
      _markers.add(Marker(
        markerId: _markers.length.toString(),
        latLng: _center,
        width: 30,
        height: 30,
        offsetX: 15,
        offsetY: 30,
        markerImageSrc: API.myLocationImage,
        zIndex: 1,
      ));

      if (_busStopModel != null) {
        // 각 버스 정류장 데이터를 기반으로 마커 추가
        for (var stop in _busStopModel!) {
          _markers.add(Marker(
            markerId: stop.nodeid!, // 정류소 ID를 마커 ID로 사용
            latLng: LatLng(double.parse(stop.gpslati!),
                double.parse(stop.gpslong!)), // 정류소의 좌표 설정
            width: 45,
            height: 45,
            offsetX: 22,
            offsetY: 45,
            markerImageSrc: API.busStopImage, // 정류소 이미지
            zIndex: 0,
          ));
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // API를 호출하여 버스 정류소 상제 정보 불러오기
  Future<bool> loadBusStopInfo(String busStopId) async {
    _isLoading = true;
    notifyListeners();
    print('bstopid: $busStopId');
    try {
      _busStopInfoModel = await busRepository.getBusStopInfo(busStopId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // API를 호출하여 버스 정류소 상제 정보 새로 고침 하기
  Future<void> refreshBusStopInfo(String busStopId) async {
    _isRefreshLoading = true;
    notifyListeners();
    try {
      _busStopInfoModel = await busRepository.getBusStopInfo(busStopId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isRefreshLoading = false;
      notifyListeners();
    }
  }

  // SharedPreferences에 현재 좌표 저장
  Future<void> saveLocation(double latitude, double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
  }

  // SharedPreferences에서 저장된 좌표를 불러오는 함수
  Future<void> loadSavedLocation(BuildContext context) async {
    _isLoading = true;
    _markers.clear();
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? savedLat = prefs.getDouble('latitude');
    double? savedLng = prefs.getDouble('longitude');

    if (savedLat != null && savedLng != null) {
      // 로컬에 저장된 좌표가 있다면 그 좌표로 설정
      _center = LatLng(savedLat, savedLng);
      _isLocationReady = true;
    } else if (context.mounted) {
      // 저장된 좌표가 없으면 현재 위치 불러오기
      await getLocation(context);
    }

    if (context.mounted) {
      // 본인 주변 500m 이내 정류소 불러오기
      await getNearBusStop(_center).then((_) {
        _isLoading = false;
        notifyListeners();
      });
    }
  }

  // 현재 본인 좌표 불러오기
  Future<void> getLocation(BuildContext context) async {
    _isLoading = true;
    _markers.clear();
    notifyListeners();

    // 시스템 위치 서비스 활성화 여부 확인
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      // 위치 서비스가 비활성화된 경우 스낵바를 통해 알림
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('GPS가 꺼져 있습니다. 설정에서 GPS를 켜주세요.'),
            action: SnackBarAction(
              label: '설정으로 이동',
              onPressed: () {
                Geolocator.openLocationSettings(); // 위치 서비스 설정 화면으로 이동
              },
            ),
          ),
        );
      }
      return; // 여기서 함수를 종료하여 GPS 좌표를 가져오지 않음
    }

    // 좌표 권한 설정 확인
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // 권한 요청
      permission = await Geolocator.requestPermission();

      // 권한이 거부된 경우
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('GPS 권한이 거부되었습니다. 설정에서 권한을 허용해주세요.'),
              action: SnackBarAction(
                label: '설정으로 이동',
                onPressed: () {
                  Geolocator.openAppSettings(); // 앱 설정 열기
                },
              ),
            ),
          );
        }
        return; // 여기서 함수를 종료하여 GPS 좌표를 가져오지 않음
      }
    }

    // 권한이 허용되었을 때만 좌표 불러오기
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // 현재 좌표 불러오기
      await Geolocator.getCurrentPosition().then((value) {
        _center = LatLng(value.latitude, value.longitude);
        _isLocationReady = true;
        saveLocation(value.latitude, value.longitude); // SharedPreferences에 저장
        notifyListeners();
      });
      if (context.mounted) {
        // 본인 주변 500m 이내 정류소 불러오기
        await getNearBusStop(_center).then((_) {
          moveCameraToCurrentLocation(); // 카메라를 이동
        });
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  // 지도 불러오기 (만들기)
  void onMapCreated(BuildContext context, KakaoMapController controller) {
    _mapController = controller;
    loadSavedLocation(context);
  }

  // 새로운 좌표(현재 좌표 변경 할 경우)로 설정 후 이동
  Future<void> moveToNewLocation(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    await getLocation(context).then((value) {
      _isLoading = false;
      notifyListeners();
    });
  }

  // 마커 위치로 카메라 이동
  Future<void> moveToMarkerLocation(LatLng latLng) async {
    _mapController!.setLevel(1);
    // 정류소와 모달의 범위를 생각해서 마커를 지도 중심보다 조금더 위쪽에 보일 수 있게 좌표 수정
    _mapController!.panTo(LatLng(latLng.latitude - 0.0004, latLng.longitude));
  }

  // 좌표가 설정된 후 카메라 이동
  void moveCameraToCurrentLocation() {
    _mapController!.panTo(_center);
  }

  // 현재 지도의 중심으로 이동
  void moveCameraToMapCenterLocation(BuildContext context) {
    _mapController!.getCenter().then((value) {
      _center = LatLng(value.latitude, value.longitude);

      if (context.mounted) {
        // 본인 주변 500m 이내 정류소 불러오기
        getNearBusStop(_center).then((_) {
          moveCameraToCurrentLocation(); // 카메라를 이동
        });
      }
    });
  }

  // 바텀 시트 열렸을 때 작동하는 함수
  void showBottomSheet() {
    _isBottomSheetVisible = true;
    notifyListeners();
  }

  // 바텀 시트 닫혔을 때 작동하는 함수
  void hideBottomSheet() {
    _isBottomSheetVisible = false;
    notifyListeners();
  }
}
