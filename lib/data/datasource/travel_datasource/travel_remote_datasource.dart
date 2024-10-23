import 'package:bus_way/data/api/api.dart';
import 'package:bus_way/data/api/api_enum.dart';
import 'package:bus_way/data/model/travel_model/near_travel_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:xml2json/xml2json.dart';

class TravelRemoteDatasource with ChangeNotifier {
  ApiResponseStatus? statuscode; // 상태 코드 저장
  String errorMessage = '';

  // 1. 위치 기반 관광 정보 조회
  Future<NearTravelInfoResponse> getNearTravelInfo(LatLng? center, int pageNo,
      int pageSize, String arrange, String contentTypeId) async {
    try {
      if (center != null) {
        Map<String, dynamic> parameters = {
          'serviceKey': dotenv.env['publicDataKey'],
          'MobileOS': 'AND',
          'MobileApp': 'MobileApp',
          'mapY': center.latitude.toString(), // 위도
          'mapX': center.longitude.toString(), // 경도
          'radius': '1000', // 반경 (단위: m)
          'arrange': arrange, // 정렬 기준
          'pageNo': pageNo.toString(),
          'numOfRows': pageSize.toString(),
          'contentTypeId': contentTypeId != '0' ? contentTypeId : '',
        };
        Uri uri = Uri.https(API.publicDataUrl, API.getNearTourInfo, parameters);
        http.Response result = await http.get(uri);

        if (result.statusCode == 200) {
          final body = convert.utf8.decode(result.bodyBytes);
          final xml = Xml2Json()..parse(body);
          final json = xml.toParker();

          Map<String, dynamic> jsonResult = convert.json.decode(json);

          if (jsonResult['response'] != null) {
            if (jsonResult['response']['body'] != null) {
              // totalCount 가져오기 (필터링 전 총 개수)
              int totalCount =
                  int.parse(jsonResult['response']['body']['totalCount']);

              // items가 없는 경우 처리
              var items = jsonResult['response']['body']['items'];
              if (items == null || items == '' || items['item'] == null) {
                // items가 없을 때, 빈 리스트를 반환하고 totalCount만 포함
                return NearTravelInfoResponse(
                  totalCount: totalCount.toString(),
                  travelInfoList: [],
                );
              }

              // items가 존재하는 경우 처리
              if (items['item'] != null) {
                // 관광지 리스트 변환
                List<dynamic> jsonNearTravelInfo = items['item'];

                // 필터링된 데이터 리스트
                List<NearTravelInfoModel> travelInfoList = jsonNearTravelInfo
                    .map<NearTravelInfoModel>(
                        (item) => NearTravelInfoModel.fromJson(item))
                    .toList();

                // NearTravelInfoResponse 반환 (필터링된 항목을 제외한 totalCount 반환)
                return NearTravelInfoResponse(
                  totalCount: totalCount.toString(),
                  travelInfoList: travelInfoList,
                );
              } else {
                return NearTravelInfoResponse(
                  totalCount: totalCount.toString(),
                  travelInfoList: [], // 빈 리스트 반환
                );
              }
            } else {
              errorMessage = getApiMessageForStatusCode('');
              throw errorMessage;
            }
          } else {
            // 에러가 발생한 경우 returnReasonCode 추출
            String returnReasonCode = jsonResult['OpenAPI_ServiceResponse']
                ['cmmMsgHeader']['returnReasonCode'];
            errorMessage = getApiMessageForStatusCode(returnReasonCode);
            throw errorMessage;
          }
        } else {
          errorMessage = getApiMessageForStatusCode('');
          throw errorMessage;
        }
      }
      errorMessage = getApiMessageForStatusCode('');
      throw errorMessage;
    } catch (e) {
      errorMessage = getApiMessageForStatusCode('');
      throw errorMessage;
    }
  }
}
