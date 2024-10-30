import 'package:bus_way/data/datasource/travel_datasource/travel_remote_datasource.dart';
import 'package:bus_way/data/model/travel_model/near_travel_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_blog_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_common_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_image_info_model.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class TravelRepository {
  final TravelRemoteDatasource travelRemoteDatasource =
      TravelRemoteDatasource();

  // 위치 기반 관광 정보 조회 API 호출
  Future<NearTravelInfoResponse> getNearTravelInfo(LatLng? center, int pageNo,
      int pageSize, String arrange, String contentTypeId) async {
    final nearTravelInfoList = await travelRemoteDatasource.getNearTravelInfo(
      center,
      pageNo,
      pageSize,
      arrange,
      contentTypeId,
    );
    return nearTravelInfoList;
  }

  // 공통 정보 조회
  Future<TravelCommonInfoModel?>? getTravelCommonInfo(String contentId) async {
    final travelCommonInfoList =
        await travelRemoteDatasource.getTravelCommonInfo(contentId);
    return travelCommonInfoList;
  }

  // 소개 정보 조회 (관광지 타입 별 정보 조회)
  Future<dynamic> getTravelDetailInfo(
      String contentId, String contentTypeId) async {
    final travelDetailInfoList =
        await travelRemoteDatasource.getTravelDetailInfo(
      contentId,
      contentTypeId,
    );
    return travelDetailInfoList;
  }

  // 이미지 정보 조회
  Future<TravelImageInfoResponse> getTravelImageInfo(
      int pageNo, int pageSize, String contentId) async {
    final travelImageInfoList = await travelRemoteDatasource.getTravelImageInfo(
      pageNo,
      pageSize,
      contentId,
    );
    return travelImageInfoList;
  }

  // 네이버 블로그 검색 조회
  Future<List<TravelBlogInfoModel>> getTravelBlogInfo(
      int pageNo, int pageSize, String title, String sortIndex) async {
    final travelBlogInfoList = await travelRemoteDatasource.getTravelBlogInfo(
      pageNo,
      pageSize,
      title,
      sortIndex,
    );
    return travelBlogInfoList;
  }
}
