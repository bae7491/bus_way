import 'package:bus_way/data/datasource/bus_datasource/bus_remote_datasource.dart';
import 'package:bus_way/data/model/bus_model/bus_info_model.dart';
import 'package:bus_way/data/model/bus_model/bus_line_model.dart';
import 'package:bus_way/data/model/bus_model/bus_stop_info_model.dart';
import 'package:bus_way/data/model/bus_model/near_bus_stop_model.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class BusRepository {
  final BusRemoteDatasource busRemoteDatasource = BusRemoteDatasource();

  // 좌표 기반 근접(500m 이내) 정류소 목록 조회 API 호출
  Future<List<NearBusStopModel>?> getNearBusStop(LatLng center) async {
    final nearBusStopList = await busRemoteDatasource.getNearBusStop(center);
    return nearBusStopList;
  }

  // 정류소 도착 정보 조회 (정류장 ID) API 호출
  Future<List<BusStopInfoModel>?> getBusStopInfo(String busStopId) async {
    final busStopInfoList = await busRemoteDatasource.getBusStopInfo(busStopId);
    return busStopInfoList;
  }

  // 노선 정보 조회 (버스 상세 정보)
  Future<List<BusInfoModel>?> getBusDetailInfo(String lineId) async {
    final busDetailInfoList =
        await busRemoteDatasource.getBusDetailInfo(lineId);
    return busDetailInfoList;
  }

  Future<List<BusLineModel>?> getBusLineInfo(String lineId) async {
    final busLineList = await busRemoteDatasource.getBusLineInfo(lineId);
    return busLineList;
  }
}
