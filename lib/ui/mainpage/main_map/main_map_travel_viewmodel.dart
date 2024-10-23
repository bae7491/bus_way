import 'package:bus_way/constant/travel_category_constant.dart';
import 'package:bus_way/constant/travel_filter_constant.dart';
import 'package:bus_way/data/model/travel_model/near_travel_info_model.dart';
import 'package:bus_way/data/respository/travel_repository/travel_repository.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MainMapTravelViewModel with ChangeNotifier {
  TravelRepository travelRepository = TravelRepository();

  final PagingController<int, NearTravelInfoModel> _pageController =
      PagingController(firstPageKey: 1);
  static const _pageSize = 20;
  List<NearTravelInfoModel>? _nearTravelInfoList = [];
  String? _travelTotalCount;
  String? _errorMessage;
  String? _setCategoryName;
  int? _setCategoryType;
  LatLng? _center;
  String? _setTravelFilter;

  PagingController<int, NearTravelInfoModel> get pageController =>
      _pageController;
  List<NearTravelInfoModel>? get nearTravelInfoList => _nearTravelInfoList;
  String? get travelTotalCount => _travelTotalCount;
  String? get errorMessage => _errorMessage;
  String? get setCategoryName => _setCategoryName;
  int? get setCategoryType => _setCategoryType;
  LatLng? get center => _center;
  String? get setTravelFilter => _setTravelFilter;

  // 생성자에서 페이지 리스너 추가
  MainMapTravelViewModel() {
    _pageController.addPageRequestListener((pageKey) {
      getTravelInfo(pageKey); // 파라미터는 인스턴스 변수를 사용
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 상위 카테고리 선택
  void setCategoryIndex(int index) {
    _setCategoryType = travelCategory.keys.elementAt(index);
    // _setTravelFilter = travelFilter.keys.first;
    _nearTravelInfoList!.clear();
    _pageController.refresh();
    notifyListeners();
  }

  // 관광지 정렬 드롭다운 필터 선택
  void setTravelFilterValue(String? value) {
    _setTravelFilter =
        travelFilter.entries.firstWhere((entry) => entry.value == value).key;

    _nearTravelInfoList!.clear();
    _pageController.refresh();
    notifyListeners();
  }

  // 좌표 설정 및 마커 클릭 시 변수 초기화 메서드
  void setCenter(LatLng center) {
    _center = center;
    _travelTotalCount = null;
    _setCategoryType = travelCategory.keys.first;
    _setTravelFilter = travelFilter.keys.first;
    _pageController.refresh(); // 좌표가 변경되면 새로고침
    notifyListeners();
  }

  // 해당 좌표의 관광지 정보 불러오기
  Future<void> getTravelInfo(int pageKey) async {
    try {
      final nearTravelInfoResponse = await travelRepository.getNearTravelInfo(
        _center,
        pageKey,
        _pageSize, // 한 페이지 당 데이터의 개수 (20으로 설정)
        _setTravelFilter!,
        _setCategoryType.toString(),
      );

      // API로 호출한 데이터의 총 개수
      _travelTotalCount = nearTravelInfoResponse.totalCount;
      notifyListeners();

      // 새로 받아온 페이지 데이터
      _nearTravelInfoList = nearTravelInfoResponse.travelInfoList;

      // 빈 리스트인 경우 마지막 페이지로 처리
      if (_nearTravelInfoList!.isEmpty) {
        _pageController.appendLastPage([]); // 마지막 페이지로 처리
        return;
      }

      // 현재까지 불러온 데이터의 개수
      final int totalFetchedItems = pageKey * _pageSize;

      // totalFetchedItems와 totalCount를 비교하여 마지막 페이지 여부를 결정
      final isLastPage = totalFetchedItems >= int.parse(_travelTotalCount!);

      // 마지막 페이지이면, 무한 스크롤 종료 / else, 무한 스크롤로 페이지 늘리기
      if (isLastPage) {
        _pageController
            .appendLastPage(_nearTravelInfoList!); // 중복 추가 없이 새로운 데이터 추가
      } else {
        final nextPageKey = pageKey + 1;
        _pageController.appendPage(
            _nearTravelInfoList!, nextPageKey); // 다음 페이지로 넘어가도록 설정
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
