import 'package:bus_way/data/datasource/travel_datasource/travel_remote_datasource.dart';
import 'package:bus_way/data/model/travel_model/near_travel_info_model.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class TravelRepository {
  final TravelRemoteDatasource travelRemoteDatasource =
      TravelRemoteDatasource();

  // 위치 기반 관광 정보 조회 API 호출
  Future<NearTravelInfoResponse> getNearTravelInfo(LatLng? center, int pageNo,
      int pageSize, String arrange, String contentTypeId) async {
    final nearTravelInfoList = await travelRemoteDatasource.getNearTravelInfo(
        center, pageNo, pageSize, arrange, contentTypeId);
    return nearTravelInfoList;
  }
}
