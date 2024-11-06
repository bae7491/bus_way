import 'package:bus_way/data/model/travel_model/travel_review_detail_model.dart';
import 'package:bus_way/data/respository/travel_repository/travel_repository.dart';
import 'package:flutter/material.dart';

class TravelReviewDetailViewModel with ChangeNotifier {
  TravelRepository travelRepository = TravelRepository();

  TravelReviewDetailModel? _travelReviewDetailList;
  bool _isLoading = false;
  String? _errorMessage;

  TravelReviewDetailModel? get travelReviewDetailList =>
      _travelReviewDetailList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 에러 메시지 초기화
  void clearErrorMessage() async {
    _errorMessage = null;
    notifyListeners();
  }

  // 선택 관광지의 후기 상세 정보 불러오기
  Future<void> laodTravelReviewdetail(String reviewId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _travelReviewDetailList =
          await travelRepository.getTravelReviewDetail(reviewId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
