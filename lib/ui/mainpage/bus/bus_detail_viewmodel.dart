import 'package:bus_way/data/model/bus_model/bus_info_model.dart';
import 'package:bus_way/data/model/bus_model/bus_line_model.dart';
import 'package:bus_way/data/model/bus_model/bus_stop_info_model.dart';
import 'package:bus_way/data/respository/bus_repository/bus_repository.dart';
import 'package:bus_way/ui/mainpage/main_map/main_map_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mainpage_view.dart';
import 'package:bus_way/widget/custom_snackbar.dart';
import 'package:bus_way/widget/navigator_animation.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';

class BusDetailViewModel with ChangeNotifier {
  BusRepository busRepository = BusRepository();

  List<BusInfoModel>? _busInfoModel;
  List<BusLineModel>? _busLineModel;
  List<BusStopInfoModel>? _busStopInfoModel;
  bool _isLoading = false;
  bool _isRefreshLoading = false;
  String? _errorMessage;

  List<BusInfoModel>? get busInfoModel => _busInfoModel;
  List<BusLineModel>? get busLineModel => _busLineModel;
  List<BusStopInfoModel>? get busStopInfoModel => _busStopInfoModel;
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

  // 선택한 버스 정류소의 위경도를 알아내고, 성공하면 그 위치로 지도 (메인 화면) 이동
  Future<void> onTapBusStop(
      BuildContext context, String busStopName, String busStopId) async {
    await getBusStopInfo(busStopName, busStopId);

    if (_errorMessage == null && context.mounted) {
      final mainMapViewModel =
          Provider.of<MainMapViewmodel>(context, listen: false);

      if (_busStopInfoModel != null && _busStopInfoModel!.isNotEmpty) {
        final latitude = double.parse(_busStopInfoModel!.first.latitude!);
        final longitude = double.parse(_busStopInfoModel!.first.longitude!);
        final markerLatLng = LatLng(latitude, longitude);

        // TODO: 버스 상세 노선도에서 버스 정류장 클릭 시, 계속해서 지도 -> 정류장 -> 지도 순으로 이동 가능하게 구현해야함.
        // // 마커 히스토리에 추가
        // mainMapViewModel.addMarkerToHistory(busStopId, markerLatLng);

        // Navigator.of(context).push(
        //   const NavigatorAnimation(destination: MainView())
        //       .createRoute(SlideDirection.bottomToTop),
        // );
      }
    } else if (_errorMessage != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbar(content: Text(_errorMessage!)),
      );
    }
  }

  // 선택한 버스 정류소의 위경도 알아내기 (버스 정류소 정보 확인)
  Future<void> getBusStopInfo(String busStopName, String busStopId) async {
    try {
      _busStopInfoModel =
          await busRepository.getBusStopInfo(busStopName, busStopId);
    } catch (e) {
      _errorMessage = e.toString();
    }
  }
}
