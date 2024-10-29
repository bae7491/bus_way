import 'package:bus_way/data/api/api.dart';
import 'package:bus_way/data/model/travel_model/travel_common_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_image_info_model.dart';
import 'package:bus_way/data/respository/travel_repository/travel_repository.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class TravelDetailViewModel with ChangeNotifier {
  TravelRepository travelRepository = TravelRepository();

  final PagingController<int, TravelImageInfoModel> _pageController =
      PagingController(firstPageKey: 1);
  static const _pageSize = 20;
  String? _travelImageTotalCount;
  List<TravelImageInfoModel>? _travelImageInfoList; // 관광지 이미지 정보 리스트
  TravelCommonInfoModel? _travelCommonInfoList; // 관광지 공통 정보 리스트
  dynamic _travelDetailInfoList; // 관광지 소개 정보 리스트
  KakaoMapController? _mapController;
  final Set<Marker> _marker = {};
  bool _isLoading = false;
  String? _errorMessage;

  PagingController<int, TravelImageInfoModel> get pageController =>
      _pageController;
  String? get travelImageTotalCount => _travelImageTotalCount;
  List<TravelImageInfoModel>? get travelImageInfoList => _travelImageInfoList;
  TravelCommonInfoModel? get travelCommonInfoList => _travelCommonInfoList;
  dynamic get travelDetailInfoList => _travelDetailInfoList;
  KakaoMapController? get mapController => _mapController;
  Set<Marker> get marker => _marker;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    _pageController.dispose();
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
        loadTravelImageInfo(contentId),
      ],
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadTravelImageInfo(String contentId) async {
    _pageController.addPageRequestListener((pageKey) {
      getTravelImageInfo(pageKey, contentId); // 파라미터는 인스턴스 변수를 사용
    });
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

  // 관광지 지도 정보
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

  // 관광지 이미지 정보 불러오기
  Future<void> getTravelImageInfo(int pageKey, String contentId) async {
    try {
      final travelImageInfoResponse = await travelRepository.getTravelImageInfo(
        pageKey,
        _pageSize,
        contentId,
      );

      // API로 호출한 데이터의 총 개수
      _travelImageTotalCount = travelImageInfoResponse.totalCount;

      // 새로 받아온 페이지 데이터
      _travelImageInfoList = travelImageInfoResponse.travelImageInfoList;

      // 빈 리스트인 경우 마지막 페이지로 철
      if (_travelImageInfoList!.isEmpty) {
        _pageController.appendLastPage([]); // 마지막 페이지로 처리
        return;
      }

      // 현재까지 불러온 데이터의 개수
      final int totalFetchedItems = pageKey * _pageSize;

      // totalFetchedItems와 totalCount를 비교하여 마지막 페이지 여부를 결정
      final isLastPage =
          totalFetchedItems >= int.parse(_travelImageTotalCount!);

      // 마지막 페이지이면, 무한 스크롤 종료 / else, 무한 스크롤로 페이지 늘리기
      if (isLastPage) {
        _pageController
            .appendLastPage(_travelImageInfoList!); // 중복 추가 없이 새로운 데이터 추가
      } else {
        final nextPageKey = pageKey + 1;
        _pageController.appendPage(
            _travelImageInfoList!, nextPageKey); // 다음 페이지로 넘어가도록 설정
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
