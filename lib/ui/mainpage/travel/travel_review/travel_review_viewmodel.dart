import 'package:bus_way/data/respository/travel_repository/travel_repository.dart';
import 'package:bus_way/widget/custom_alert_dialog.dart';
import 'package:bus_way/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TravelReviewViewModel with ChangeNotifier {
  TravelRepository travelRepository = TravelRepository();

  final reviewController = TextEditingController();
  final reviewFocusNode = FocusNode();
  final ImagePicker picker = ImagePicker();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isReviewActiveBtn = false;
  double _rating = 3.0; // 기본 레이팅 값
  bool _isAlertClosed = false;
  XFile? _reviewImage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isReviewActiveBtn => _isReviewActiveBtn;
  double get rating => _rating;
  bool get isAlertClosed => _isAlertClosed;
  XFile? get reviewImage => _reviewImage;

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

  // AlertDialog 뒤로가기 상태 체크
  void checkCloseAlertDialog(bool isAlertClosed) {
    _isAlertClosed = isAlertClosed;
    notifyListeners();
  }

  // RatingBar에서 호출할 메서드
  void updateRating(double newRating) {
    _rating = newRating;
    notifyListeners();
  }

  // 리뷰 작성 후, 버튼 활성화 여부 변경 로직
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

  // 후기 작성 필수 값(별점, 리뷰 글)이 작성되었는지 확인 후 리뷰 업로드
  void checkTravelReview(BuildContext context, String contentId) {
    if (reviewController.text.isNotEmpty) {
      checkRegisterReivew(context, contentId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const CustomSnackbar(
          content: Text('리뷰 필수 값을 다시 확인해주세요.'),
        ),
      );
    }
  }

  // 후기 작성 등록 확인 팝업
  Future<void> checkRegisterReivew(
      BuildContext context, String contentId) async {
    final isRegisterReview = await showCustomAlertDialog(
          context,
          '작성한 후기를 등록하시겠습니까?',
        ) ??
        false;

    if (isRegisterReview && context.mounted) {
      await uploadTravelReview(context, contentId);
    }

    // 리뷰 작성 textFormField의 Focus 제거
    reviewFocusNode.unfocus();
  }

  // 작성 리뷰 업로드
  Future<void> uploadTravelReview(
      BuildContext context, String contentId) async {
    try {
      _isLoading = true;
      notifyListeners();

      print('contentId: $contentId');

      if (reviewImage != null) {
        await travelRepository.uploadTravelReview(
            _rating, reviewController.text, contentId, reviewImage!);
      } else {
        await travelRepository.uploadTravelReview(
          _rating,
          reviewController.text,
          contentId,
        );
      }
      if (context.mounted) {
        navigatePreviousPage(context);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 리뷰 작성 완료 후, 관광지 상세 페이지로 이동.
  void navigatePreviousPage(BuildContext context) {
    Navigator.of(context).pop();
  }
}
