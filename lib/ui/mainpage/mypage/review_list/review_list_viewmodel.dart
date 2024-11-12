import 'package:bus_way/data/model/mypage_model/user_review_model.dart';
import 'package:bus_way/data/respository/mypage_repository/mypage_repository.dart';
import 'package:bus_way/ui/mainpage/mypage/review_modify/review_modify_view.dart';
import 'package:bus_way/ui/mainpage/travel/travel_review_detail/travel_review_detail_view.dart';
import 'package:bus_way/widget/custom_alert_dialog.dart';
import 'package:bus_way/widget/navigator_animation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ReviewListViewModel with ChangeNotifier {
  MypageRepository mypageRepository = MypageRepository();

  static const _pageSize = 20;

  final PagingController<int, UserReviewModel> _reviewPageController =
      PagingController(firstPageKey: 1);
  String? _reviewTotalCount = '0'; // 관광지 후기 API 호출 총 개수
  bool _isLoading = false;
  String? _errorMessage;
  int _reviewSortIndex = 0; // 후기 정렬 인덱스

  PagingController<int, UserReviewModel> get reviewPageController =>
      _reviewPageController;
  String? get reviewTotalCount => _reviewTotalCount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get reviewSortIndex => _reviewSortIndex;

  ReviewListViewModel() {
    _reviewPageController.addPageRequestListener((pageKey) {
      getReviewList(pageKey);
    });
    loadReviewList();
  }

  @override
  void dispose() {
    _reviewPageController.dispose();
    super.dispose();
  }

  // 에러 메시지 초기화
  void clearErrorMessage() async {
    _errorMessage = null;
    notifyListeners();
  }

  // 후기 정렬 문자열 변경
  String get selectedReviewSortText {
    return _reviewSortIndex == 0 ? 'rate' : 'date';
  }

  // 후기 정렬 방식 변경
  void toggleTravelReviewSort(int value) {
    _reviewSortIndex = value;

    // 프레임 빌드 후 리스트 갱신
    Future.sync(
      () => _reviewPageController.refresh(),
    );

    notifyListeners();
  }

  // 후기 리스트 로딩
  Future<void> loadReviewList() async {
    _isLoading = true;
    notifyListeners();

    _reviewPageController.refresh();
    _isLoading = false;
    notifyListeners();
  }

  // 관광지 후기 목록 조회 API 호출
  Future<void> getReviewList(int pageKey) async {
    try {
      final reviewResponse = await mypageRepository.getReviewList(
        pageKey,
        _pageSize,
        selectedReviewSortText,
      );

      // 데이터가 없을 경우 빈 리스트 반환
      if (reviewResponse.isEmpty) {
        _reviewPageController.appendLastPage([]);
        _reviewTotalCount = '0';
      } else {
        // API로 호출한 데이터의 총 개수
        _reviewTotalCount = reviewResponse.first.reviewTotalCount;

        // 현재까지 불러온 데이터의 개수
        final int totalFetchedItems = pageKey * _pageSize;

        // totalFetchedItems와 totalCount를 비교하여 마지막 페이지 여부를 결정
        final isLastPage = totalFetchedItems >= int.parse(_reviewTotalCount!);

        // 마지막 페이지이면, 무한 스크롤 종료 / else, 무한 스크롤로 페이진 늘리기
        if (isLastPage) {
          _reviewPageController
              .appendLastPage(reviewResponse); // 중복 추가 없이 새로운 데이터 추가
        } else {
          final nextPageKey = pageKey + 1;
          _reviewPageController.appendPage(
              reviewResponse, nextPageKey); // 다음 페이지로 넘어가도록 설정
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
      _reviewPageController.error = e;
      _reviewTotalCount = '0';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 관광지 후기 상세 페이지로 이동
  Future<void> navigateReviewDetaliView(
      BuildContext context, String reviewId) async {
    await Navigator.of(context).push(
      NavigatorAnimation(
        destination: TravelReviewDetailView(reviewId: reviewId),
      ).createRoute(SlideDirection.bottomToTop),
    );
  }

  // 관광지 후기 수정 페이지 이동
  Future<void> navigateModifyReview(BuildContext context, String reviewId,
      String contentId, String title) async {
    await Navigator.of(context)
        .push(
      NavigatorAnimation(
        destination: ReviewModifyView(
          reviewId: reviewId,
          contentId: contentId,
          title: title,
        ),
      ).createRoute(SlideDirection.bottomToTop),
    )
        .then((_) {
      // 수정 후, 후기 목록 페이지 다시 불러오기
      loadReviewList();
    });
  }

  // 관광지 후기 삭제 확인 팝업
  Future<void> checkDeleteReview(
      BuildContext context, UserReviewModel item) async {
    final isDeleteReview = await showCustomAlertDialog(
          context,
          '선택하신 후기를 삭제하시겠습니까?',
        ) ??
        false;

    if (isDeleteReview && context.mounted) {
      await deleteReview(context, item);
    }
  }

  // 관광지 후기 삭제
  Future<void> deleteReview(BuildContext context, UserReviewModel item) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (item.reviewImage != null && item.reviewImage!.isNotEmpty) {
        await mypageRepository.deleteReview(
          item.reviewId!,
          item.reviewImage!,
        );
      } else {
        await mypageRepository.deleteReview(item.reviewId!);
      }
      loadReviewList();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
