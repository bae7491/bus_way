import 'package:bus_way/data/model/travel_model/travel_review_detail_model.dart';
import 'package:bus_way/data/respository/mypage_repository/mypage_repository.dart';
import 'package:bus_way/data/respository/travel_repository/travel_repository.dart';
import 'package:bus_way/widget/custom_alert_dialog.dart';
import 'package:bus_way/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReviewModifyViewModel with ChangeNotifier {
  TravelRepository travelRepository = TravelRepository();
  MypageRepository mypageRepository = MypageRepository();

  final reviewController = TextEditingController();
  final reviewFocusNode = FocusNode();
  final ImagePicker picker = ImagePicker();

  TravelReviewDetailModel? _reviewDetailList;
  bool _isLoading = false;
  String? _errorMessage;
  double _rating = 3.0;
  bool _isReviewActiveBtn = false;
  XFile? _reviewImage;
  String? _originalImage;
  String? _originalImagePath;

  TravelReviewDetailModel? get reviewDetailList => _reviewDetailList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get rating => _rating;
  bool get isReviewActiveBtn => _isReviewActiveBtn;
  XFile? get reviewImage => _reviewImage;
  String? get originalImage => _originalImage;
  String? get originalImagePath => _originalImagePath;

  ReviewModifyViewModel(String reviewId) {
    loadTravelReviewdetail(reviewId);
  }

  @override
  void dispose() {
    reviewController.dispose();
    reviewFocusNode.dispose();
    super.dispose();
  }

  // 에러 메시지 초기화
  void clearErrorMessage() async {
    _errorMessage = null;
    notifyListeners();
  }

  // RatingBar에서 호출할 메서드
  void updateRating(double newRating) {
    _rating = newRating;
    notifyListeners();
  }

  // 리뷰 수정 후, 버튼 활성화 여부 변경 로직 (필수 값이 비어있으면 비활성화)
  void updateReviewBtn() {
    _isReviewActiveBtn = reviewController.text.isNotEmpty;
    notifyListeners();
  }

  // 리뷰 이미지 갤러리에서 선택
  Future<void> getReviewImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      _reviewImage = XFile(pickedFile.path);
      notifyListeners();
    }
  }

  // 리뷰 이미지 지우기
  Future<void> removeReviewImage() async {
    _reviewImage = null;
    notifyListeners();
  }

  // 선택한 관광지 후기 상세 조회 API 호출
  Future<void> loadTravelReviewdetail(String reviewId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _reviewDetailList =
          await travelRepository.getTravelReviewDetail(reviewId);

      // 서버에서 호출한 후기 별점, 후기 내용, 후기 이미지 초기화
      _rating = double.parse(_reviewDetailList!.reviewRate!);
      reviewController.text = _reviewDetailList!.reviewContent!;

      // 후기 내용이 있으면, 후기 버튼 색 변경 (활성화)
      updateReviewBtn();

      if (_reviewDetailList!.reviewImage != null &&
          _reviewDetailList!.reviewImage!.isNotEmpty) {
        _originalImage = _reviewDetailList!.reviewImage;
      }

      if (_reviewDetailList!.reviewImagePath != null &&
          _reviewDetailList!.reviewImagePath!.isNotEmpty) {
        _reviewImage = XFile(_reviewDetailList!.reviewImagePath!);
        _originalImagePath = _reviewDetailList!.reviewImage!;
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 수정 후기 등록 확인 팝업
  Future<void> checkModifyReivew(BuildContext context, String reviewId,
      String contentId, String title) async {
    if (!_isReviewActiveBtn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const CustomSnackbar(content: Text('필수 값을 다시 확인해 주세요.')),
      );
      return;
    }

    final isRegisterReview = await showCustomAlertDialog(
          context,
          '수정한 후기를 등록하시겠습니까?',
        ) ??
        false;

    reviewFocusNode.unfocus();

    if (isRegisterReview && context.mounted) {
      await uploadModifyReview(context, reviewId, contentId, title);
    }
  }

  // 수정한 관광지 후기를 서버에 업로드
  Future<void> uploadModifyReview(BuildContext context, String reviewId,
      String contentId, String title) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (reviewImage != null) {
        await mypageRepository.modifyReview(
          reviewId,
          _rating,
          reviewController.text,
          contentId,
          title,
          _originalImagePath,
          reviewImage,
        );
      } else {
        await mypageRepository.modifyReview(
          reviewId,
          _rating,
          reviewController.text,
          contentId,
          title,
          _originalImagePath,
        );
      }
      if (context.mounted) {
        navigatePreviousPage(context, contentId);
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 리뷰 수정 완료 후, 관광지 후기 목록 페이지로 이동.
  void navigatePreviousPage(BuildContext context, String contentId) {
    Navigator.of(context).pop();
  }
}
