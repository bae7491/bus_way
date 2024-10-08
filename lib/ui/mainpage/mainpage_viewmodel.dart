import 'package:bus_way/data/respository/login_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MainPageViewModel with ChangeNotifier {
  LoginAuthRepository loginAuthRepository = LoginAuthRepository();

  KakaoMapController? _mapController;
  final LatLng _center = LatLng(35.14839968409451, 129.05896333397888);

  KakaoMapController? get mapController => _mapController;
  LatLng get center => _center;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void onMapCreated(KakaoMapController controller) {
    _mapController = controller;
    notifyListeners(); // 상태 업데이트
  }

  Future<void> signOut() async {
    await loginAuthRepository.signOut();
  }
}
