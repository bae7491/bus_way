import 'package:bus_way/data/api/api.dart';
import 'package:bus_way/data/model/travel_model/travel_common_info_model.dart';
import 'package:bus_way/data/respository/travel_repository/travel_repository.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class TravelDetailViewModel with ChangeNotifier {
  TravelRepository travelRepository = TravelRepository();

  TravelCommonInfoModel? _travelCommonInfoList; // 관광지 공통 정보 리스트
  dynamic _travelDetailInfoList; // 관광지 소개 정보 리스트
  KakaoMapController? _mapController;
  final Set<Marker> _marker = {};
  bool _isLoading = false;
  String? _errorMessage;

  TravelCommonInfoModel? get travelCommonInfoList => _travelCommonInfoList;
  dynamic get travelDetailInfoList => _travelDetailInfoList;
  KakaoMapController? get mapController => _mapController;
  Set<Marker> get marker => _marker;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  // 에러 메시지 초기화
  void clearErrorMessage() async {
    _errorMessage = null;
    notifyListeners();
  }

  // 관광지 홈페이지 url 연결
  Future<void> launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  // 관광지 상세 페이지 이동 시, 최초 1회에 한해서 호출
  void loadTravelInfo(String contentId, String contentTypeId) async {
    _isLoading = true;
    notifyListeners();

    await Future.wait(
      [
        getTravelCommonInfo(contentId),
        getTravelDetailInfo(contentId, contentTypeId),
      ],
    );

    _isLoading = false;
    notifyListeners();
  }

  // 관광지 공통 정보 조회 API 호출
  Future<void> getTravelCommonInfo(String contentId) async {
    try {
      _travelCommonInfoList =
          await travelRepository.getTravelCommonInfo(contentId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // 관광지 소개 정보 조회 API 호출
  Future<void> getTravelDetailInfo(
      String contentId, String contentTypeId) async {
    try {
      _travelDetailInfoList =
          await travelRepository.getTravelDetailInfo(contentId, contentTypeId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // 관광지 상세 정보
  Future<void> onMapCreated(
    BuildContext context,
    KakaoMapController controller,
    LatLng latLng,
  ) async {
    _isLoading = true;
    notifyListeners();

    _mapController = controller;
    _mapController?.setDraggable(false);
    _mapController?.setLevel(4);
    _marker.clear();

    _marker.add(
      Marker(
        markerId: 'travelLocation',
        latLng: latLng,
        width: 45,
        height: 45,
        offsetX: 22,
        offsetY: 45,
        markerImageSrc: API.travelLocationImage,
      ),
    );

    _isLoading = false;
    notifyListeners();
  }
}
