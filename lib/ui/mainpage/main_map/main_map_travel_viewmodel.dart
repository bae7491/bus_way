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
  String? _errorMessage;
  int? _selectedIndex;
  final int _pageNo = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  LatLng? _center;

  PagingController<int, NearTravelInfoModel> get pageController =>
      _pageController;
  List<NearTravelInfoModel>? get nearTravelInfoList => _nearTravelInfoList;
  int? get selectedIndex => _selectedIndex;
  String? get errorMessage => _errorMessage;
  int get pageNo => _pageNo;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

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
    _selectedIndex = index;
    _nearTravelInfoList!.clear();
    _hasMore = true;
    notifyListeners();
    print('pageNo: $_pageNo');
  }

  // 좌표 설정 메서드
  void setCenter(LatLng center) {
    _center = center;
    _pageController.refresh(); // 좌표가 변경되면 새로고침
  }

  // 해당 좌표의 관광지 정보 불러오기
  Future<void> getTravelInfo(int pageKey) async {
    try {
      _nearTravelInfoList = await travelRepository.getNearTravelInfo(
          _center,
          pageKey,
          _pageSize, // 한 페이지 당 데이터의 개수 (20으로 설정)
          'S',
          '');

      print("size: ${_nearTravelInfoList!.length} / $_pageSize");

      // TODO: 값이 같을 때, 마지막 페이지인데, 마지막 페이지로 인식 못하는 오류 있음. 해결해야 함.
      final isLastPage = _nearTravelInfoList!.length < _pageSize;

      if (isLastPage) {
        _pageController.appendLastPage(_nearTravelInfoList!);
      } else {
        final nextPageKey = pageKey + 1;
        _pageController.appendPage(_nearTravelInfoList!, nextPageKey);
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
  }
}
