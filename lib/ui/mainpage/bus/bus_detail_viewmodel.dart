import 'package:bus_way/data/model/bus_model/bus_info_model.dart';
import 'package:bus_way/data/model/bus_model/bus_line_model.dart';
import 'package:bus_way/data/respository/bus_repository/bus_repository.dart';
import 'package:flutter/material.dart';

class BusDetailViewModel with ChangeNotifier {
  BusRepository busRepository = BusRepository();

  List<BusInfoModel>? _busInfoModel;
  List<BusLineModel>? _busLineModel;
  bool _isLoading = false;
  bool _isRefreshLoading = false;
  String? _errorMessage;

  List<BusInfoModel>? get busInfoModel => _busInfoModel;
  List<BusLineModel>? get busLineModel => _busLineModel;
  bool get isLoading => _isLoading;
  bool get isRefreshLoading => _isRefreshLoading;
  String? get errorMessage => _errorMessage;

  // 에러 메시지 초기화
  void clearErrorMessage() async {
    _errorMessage = null;
    notifyListeners();
  }

  // 버스 전체 노선 새로 고침 하기
  void refreshBusInfo(String lineId) async {
    _isRefreshLoading = true;
    notifyListeners();
    try {
      await getLineInfo(lineId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isRefreshLoading = false;
      notifyListeners();
    }
  }

  // 버스 상세 정보 & 버스 전체 노선 불러오기
  void loadBusInfo(String lineId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.wait([
        getBusDetailInfo(lineId),
        getLineInfo(lineId),
      ]);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // API를 호출하여 버스 상세 정보 불러오기
  Future<void> getBusDetailInfo(String lineId) async {
    try {
      _busInfoModel = await busRepository.getBusDetailInfo(lineId);
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  // API를 호출하여 버스 전체 노선 불러오기
  Future<void> getLineInfo(String lineId) async {
    try {
      _busLineModel = await busRepository.getBusLineInfo(lineId);
    } catch (e) {
      _errorMessage = e.toString();
    }
  }
}
