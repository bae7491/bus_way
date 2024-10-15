import 'package:bus_way/data/datasource/bus_datasource/bus_remote_datasource.dart';
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
  Future<List<BusStopInfoModel>?> getBusStopInfo(String bstopid) async {
    final busStopInfoList = await busRemoteDatasource.getBusStopInfo(bstopid);
    return busStopInfoList;
  }
}
