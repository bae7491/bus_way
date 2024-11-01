import 'dart:io';

import 'package:bus_way/data/respository/travel_repository/travel_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TravelReviewViewModel with ChangeNotifier {
  TravelRepository travelRepository = TravelRepository();

  final reviewController = TextEditingController();
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

  // TODO: 리뷰가 제대로 작성되었는지 확인하는 코드 추가해야함. (travel_review_view.dart 후기 등록 버튼에 추가 예정).

  // 작성 리뷰 업로드
  Future<void> uploadTravelReview() async {
    try {
      _isLoading = true;
      notifyListeners();

      // print(
      //     "rating: $_rating / text: ${reviewController.text} / image: $reviewImage");
      await travelRepository.uploadTravelReview(
          _rating, reviewController.text, reviewImage!);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
