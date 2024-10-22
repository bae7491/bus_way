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
  Future<List<NearTravelInfoModel>?> getNearTravelInfo(LatLng? center,
      int pageNo, int pageSize, String arrange, String contentTypeId) async {
    try {
      if (center != null) {
        print('center: ${center.latitude} / ${center.longitude}');
        Map<String, dynamic> parameters = {
          'serviceKey': dotenv.env['publicDataKey'],
          'MobileOS': 'AND',
          'MobileApp': 'MobileApp',
          'mapY': center.latitude.toString(), // 위도
          'mapX': center.longitude.toString(), // 경도
          'radius': '1000', // 반경 (단위: m)
          'arrange':
              arrange, // (A=제목순,C=수정일순, D=생성일순, E=거리순) / 대표이미지가반드시있는정렬 (O=제목순, Q=수정일순, R=생성일순,S=거리순)
          'pageNo': pageNo.toString(),
          'numOfRows': pageSize.toString(),
          'contentTypeId': contentTypeId,
        };
        Uri uri = Uri.https(API.publicDataUrl, API.getNearTourInfo, parameters);
        http.Response result = await http.get(uri);

        if (result.statusCode == 200) {
          final body = convert.utf8.decode(result.bodyBytes);
          final xml = Xml2Json()..parse(body);
          final json = xml.toParker();

          Map<String, dynamic> jsonResult = convert.json.decode(json);

          if (jsonResult['response'] != null) {
            if (jsonResult['response'] != null &&
                jsonResult['response']['body'] != null &&
                jsonResult['response']['body']['items'] != null) {
              final jsonNearTravelInfo =
                  jsonResult['response']['body']['items'];

              List<dynamic> nearTravelInfoList = jsonNearTravelInfo['item'];

              print('nearTravelInfoList: $nearTravelInfoList');

              return nearTravelInfoList
                  // .where((item) => item['areacode'] == 6)
                  .map<NearTravelInfoModel>(
                      (item) => NearTravelInfoModel.fromJson(item))
                  .toList();
            } else {
              errorMessage = getApiMessageForStatusCode('');
              throw errorMessage;
            }
          } else {
            // 에러가 발생한 경우 returnReasonCode 추출
            String returnReasonCode = jsonResult['OpenAPI_ServiceResponse']
                ['cmmMsgHeader']['returnReasonCode'];
            errorMessage = getApiMessageForStatusCode(returnReasonCode);
          }
        } else {
          errorMessage = getApiMessageForStatusCode('');
        }
      }

      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }
}
