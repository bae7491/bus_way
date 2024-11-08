import 'package:bus_way/data/model/mypage_model/user_follow_model.dart';
import 'package:bus_way/data/respository/mypage_repository/mypage_repository.dart';
import 'package:bus_way/data/respository/travel_repository/travel_repository.dart';
import 'package:bus_way/ui/mainpage/travel/travel_detail_view.dart';
import 'package:bus_way/widget/custom_alert_dialog.dart';
import 'package:bus_way/widget/navigator_animation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FollowListViewModel with ChangeNotifier {
  MypageRepository mypageRepository = MypageRepository();
  TravelRepository travelRepository = TravelRepository();

  static const _pageSize = 20;

  final PagingController<int, UserFollowModel> _followPageController =
      PagingController(firstPageKey: 1);
  String? _followTotalCount = '0'; // 관광지 팔로우 API 호출 총 개수
  List<UserFollowModel>? _followList;
  bool _isLoading = false;
  String? _errorMessage;

  PagingController<int, UserFollowModel> get followPageController =>
      _followPageController;
  String? get followTotalCount => _followTotalCount;
  List<UserFollowModel>? get followList => _followList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  FollowListViewModel() {
    // 첫 페이지 로딩을 트리거
    _followPageController.addPageRequestListener((pageKey) {
      getFollowList(pageKey);
    });
    loadFollowList();
  }

  Future<void> loadFollowList() async {
    _isLoading = true;
    notifyListeners();

    // 초기화 후 첫 로딩 트리거
    _followPageController.refresh();
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _followPageController.dispose();
    super.dispose();
  }

  // 에러 메시지 초기화
  void clearErrorMessage() async {
    _errorMessage = null;
    notifyListeners();
  }

  // 관광지 팔로우 목록 조회 API 호출
  Future<void> getFollowList(int pageKey) async {
    try {
      final followResponse = await mypageRepository.getFollowList(
        pageKey,
        _pageSize,
      );

      // 데이터가 없을 경우 빈 리스트 반환
      if (followResponse.isEmpty) {
        _followPageController.appendLastPage([]);
        _followTotalCount = '0';
      } else {
        // API로 호출한 데이터의 총 개수
        _followTotalCount = followResponse.first.followTotalCount;

        // 현재까지 불러온 데이터의 개수
        final int totalFetchedItems = pageKey * _pageSize;

        // totalFetchedItems와 totalCount를 비교하여 마지막 페이지 여부를 결정
        final isLastPage = totalFetchedItems >= int.parse(_followTotalCount!);

        // 마지막 페이지이면, 무한 스크롤 종료 / else, 무한 스크롤로 페이진 늘리기
        if (isLastPage) {
          _followPageController
              .appendLastPage(followResponse); // 중복 추가 없이 새로운 데이터 추가
        } else {
          final nextPageKey = pageKey + 1;
          _followPageController.appendPage(
              followResponse, nextPageKey); // 다음 페이지로 넘어가도록 설정
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
      _followPageController.error = e;
      _followTotalCount = '0';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 관광지 팔로우 삭제 확인 팝업
  Future<void> checkDeleteFollow(
      BuildContext context, UserFollowModel item) async {
    final isDeleteFollow =
        await showCustomAlertDialog(context, '팔로우를 취소하시겠습니까?') ?? false;

    if (isDeleteFollow && context.mounted) {
      await deleteFollow(context, item);
    }
  }

  // 관광지 팔로우 삭제
  Future<void> deleteFollow(BuildContext context, UserFollowModel item) async {
    try {
      _isLoading = true;
      notifyListeners();

      await travelRepository.travelLocalDatasource.requestUnFollow(
        item.contentId!,
        item.contentTypeId!,
        item.title!,
        item.firstImage!,
      );

      loadFollowList();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
