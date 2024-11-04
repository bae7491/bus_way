import 'package:bus_way/data/api/api.dart';
import 'package:bus_way/data/model/travel_model/travel_blog_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_common_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_image_info_model.dart';
import 'package:bus_way/data/respository/travel_repository/travel_repository.dart';
import 'package:bus_way/ui/mainpage/travel/travel_review/travel_review_view.dart';
import 'package:bus_way/widget/navigator_animation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class TravelDetailViewModel with ChangeNotifier {
  TravelRepository travelRepository = TravelRepository();

  final PagingController<int, TravelImageInfoModel> _imagePageController =
      PagingController(firstPageKey: 1); // 관광지 이미지 pageController
  final PagingController<int, TravelBlogInfoModel> _blogPageController =
      PagingController(firstPageKey: 1); // 관광지 블로그 pageController
  static const _pageSize = 20;
  String? _travelImageTotalCount; // 관광지 이미지 API 호출 총 개수
  String? _travelBlogTotalCount; // 관광지 블로그 API 호출 총 개수
  List<TravelImageInfoModel>? _travelImageInfoList; // 관광지 이미지 정보 리스트
  List<TravelBlogInfoModel>? _travelBlogInfoList; // 관광지 블로그 리뷰 리스트
  TravelCommonInfoModel? _travelCommonInfoList; // 관광지 공통 정보 리스트
  dynamic _travelDetailInfoList; // 관광지 소개 정보 리스트
  KakaoMapController? _mapController;
  final Set<Marker> _marker = {};
  bool _isLoading = false;
  String? _errorMessage;
  int _reviewCurrentIndex = 0;
  int _travelBlogSortIndex = 0;
  bool _isTravelFollow = false; // 관광지 팔로우 상태
  bool _isFollowProcessing = false;

  PagingController<int, TravelImageInfoModel> get imagePageController =>
      _imagePageController;
  PagingController<int, TravelBlogInfoModel> get blogPageController =>
      _blogPageController;
  String? get travelImageTotalCount => _travelImageTotalCount;
  String? get travelBlogTotalCount => _travelBlogTotalCount;
  List<TravelImageInfoModel>? get travelImageInfoList => _travelImageInfoList;
  List<TravelBlogInfoModel>? get travelBlogInfoList => _travelBlogInfoList;
  TravelCommonInfoModel? get travelCommonInfoList => _travelCommonInfoList;
  dynamic get travelDetailInfoList => _travelDetailInfoList;
  KakaoMapController? get mapController => _mapController;
  Set<Marker> get marker => _marker;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get reviewCurrentIndex => _reviewCurrentIndex;
  int get travelBlogSortIndex => _travelBlogSortIndex;
  bool get isTravelFollow => _isTravelFollow;
  bool get isFollowProcessing => _isFollowProcessing;

  @override
  void dispose() {
    _imagePageController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // 에러 메시지 초기화
  void clearErrorMessage() async {
    _errorMessage = null;
    notifyListeners();
  }

  // 팔로우 상태 변경
  void toggleTravelFollow(String contentId, String contentTypeId, String title,
      String travelImage) {
    if (_isFollowProcessing) return; // 요청 중일 때는 메서드를 실행하지 않음

    _isFollowProcessing = true;
    notifyListeners();

    try {
      // 팔로우 상태가 아니라면 팔로우 요청 보내기
      if (!_isTravelFollow) {
        requestFollow(contentId, contentTypeId, title, travelImage);
      } else {
        requestUnFollow(contentId, contentTypeId, title, travelImage);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isFollowProcessing = false;
      notifyListeners();
    }
  }

  // 팔로우 요청
  Future<void> requestFollow(String contentId, String contentTypeId,
      String title, String travelImage) async {
    try {
      await travelRepository.requestFollow(
          contentId, contentTypeId, title, travelImage);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isTravelFollow = !_isTravelFollow;
      notifyListeners();
    }
  }

  // 언팔로우 요청
  Future<void> requestUnFollow(String contentId, String contentTypeId,
      String title, String travelImage) async {
    try {
      await travelRepository.requestUnFollow(
          contentId, contentTypeId, title, travelImage);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isTravelFollow = !_isTravelFollow;
      notifyListeners();
    }
  }

  // 선택한 관광지의 팔로우 상태 확인 (bool로 확인해서 _isTravelFollow 변경)
  Future<void> checkTravelFollow(String contentId) async {
    _isTravelFollow = await travelRepository.checkTravelFollow(contentId);
    notifyListeners();
  }

  // 관광지 홈페이지 url 연결
  Future<void> launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _errorMessage = '링크를 연결할 수 없습니다.';
    }
  }

  // 관광지 상세 페이지 이동 시, 최초 1회에 한해서 호출
  void loadTravelInfo(
      String contentId, String contentTypeId, String title) async {
    _isLoading = true;
    notifyListeners();

    await Future.wait(
      [
        // 관광지 공통 정보 API 호출
        getTravelCommonInfo(contentId),
        // 관광지 소개 정보 API 호출
        getTravelDetailInfo(contentId, contentTypeId),
        // 관광지 이미지 정보 API 호출
        loadTravelImageInfo(contentId),
        // TODO: 관광지 후기 API 호출
        // 관광지 블로그 정보 API 호출
        loadTravelBlogInfo(title),
        // 팔로우 정보 확인
        checkTravelFollow(contentId),
      ],
    );

    _isLoading = false;
    notifyListeners();
  }

  // 관광지 이미지 정보 조회 API 불러오기
  Future<void> loadTravelImageInfo(String contentId) async {
    _imagePageController.addPageRequestListener(
      (pageKey) {
        getTravelImageInfo(pageKey, contentId); // 파라미터는 인스턴스 변수를 사용
      },
    );
  }

  // 관광지 블로그 정보 조회 API 불러오기
  Future<void> loadTravelBlogInfo(String title) async {
    _blogPageController.addPageRequestListener(
      (pageKey) {
        getTravelBlogInfo(pageKey, title);
      },
    );
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
        _imagePageController.appendLastPage([]); // 마지막 페이지로 처리
        return;
      }

      // 현재까지 불러온 데이터의 개수
      final int totalFetchedItems = pageKey * _pageSize;

      // totalFetchedItems와 totalCount를 비교하여 마지막 페이지 여부를 결정
      final isLastPage =
          totalFetchedItems >= int.parse(_travelImageTotalCount!);

      // 마지막 페이지이면, 무한 스크롤 종료 / else, 무한 스크롤로 페이지 늘리기
      if (isLastPage) {
        _imagePageController
            .appendLastPage(_travelImageInfoList!); // 중복 추가 없이 새로운 데이터 추가
      } else {
        final nextPageKey = pageKey + 1;
        _imagePageController.appendPage(
            _travelImageInfoList!, nextPageKey); // 다음 페이지로 넘어가도록 설정
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // 리뷰 세그먼트 인덱스 번호 변경
  void checkReviewSegmentIndex(int index) {
    _reviewCurrentIndex = index;
    notifyListeners();
  }

  // 후기 작성 이동
  void writeReviewNavigate(BuildContext context, String contentId) {
    Navigator.of(context).push(
      NavigatorAnimation(
        destination: TravelReviewView(contentId: contentId),
      ).createRoute(SlideDirection.bottomToTop),
    );
  }

  // 네이버 블로그 리뷰 API 호출
  Future<void> getTravelBlogInfo(int pageKey, String title) async {
    try {
      final travelBlogResponse = await travelRepository.getTravelBlogInfo(
        pageKey,
        _pageSize,
        title,
        selectedSortText,
      );

      // 블로그 글이 없는 (0개) 갱우
      if (travelBlogResponse.isEmpty) {
        _blogPageController.appendLastPage([]); // 마지막 페이지로 처리
        return;
      }

      // API로 호출한 데이터의 총 개수
      _travelBlogTotalCount = travelBlogResponse.first.blogTotalCount;

      // 새로 받아온 페이지 데이터
      _travelBlogInfoList = travelBlogResponse;

      // 빈 리스트인 경우 마지막 페이지로 처리
      if (_travelBlogInfoList!.isEmpty && _travelBlogTotalCount!.isEmpty) {
        _blogPageController.appendLastPage([]); // 마지막 페이지로 처리
        return;
      }

      // 현재까지 불러온 데이터의 개수
      final int totalFetchedItems = pageKey * _pageSize;

      // totalFetchedItems와 totalCount를 비교하여 마지막 페이지 여부를 결정
      final isLastPage = totalFetchedItems >= int.parse(_travelBlogTotalCount!);

      // 마지막 페이지이면, 무한 스크롤 종료 / else, 무한 스크롤로 페이지 늘리기
      if (isLastPage) {
        _blogPageController
            .appendLastPage(_travelBlogInfoList!); // 중복 추가 없이 새로운 데이터 추가
      } else {
        final nextPageKey = pageKey + 1;
        _blogPageController.appendPage(
            _travelBlogInfoList!, nextPageKey); // 다음 페이지로 넘어가도록 설정
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // 네이버 블로그 뷰 클릭 시, 외부로 이동
  Future<void> launchBlogUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _errorMessage = '링크를 연결할 수 없습니다.';
    }
  }

  String get selectedSortText {
    return _travelBlogSortIndex == 0 ? 'sim' : 'date';
  }

  // 네이버 블로그 정렬 방식 변경
  void toggleTravelBlogSort(int value) {
    _travelBlogSortIndex = value;
    _travelBlogInfoList!.clear();
    _blogPageController.refresh();
    notifyListeners();
  }
}
