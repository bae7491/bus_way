import 'package:bus_way/constant/travel_detail_info_model_parser.dart';
import 'package:bus_way/data/api/api.dart';
import 'package:bus_way/data/api/api_enum.dart';
import 'package:bus_way/data/model/travel_model/near_travel_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_blog_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_common_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_image_info_model.dart';
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
                // item이 단일 객체인지, 리스트인지 확인
                if (items['item'] is Map<String, dynamic>) {
                  // 단일 객체일 경우, 리스트로 감싸서 반환
                  List<NearTravelInfoModel> travelInfoList = [
                    NearTravelInfoModel.fromJson(
                      Map<String, dynamic>.from(items['item']),
                    ),
                  ];
                  // NearTravelInfoResponse 반환
                  return NearTravelInfoResponse(
                    totalCount: totalCount.toString(),
                    travelInfoList: travelInfoList,
                  );
                } else if (items['item'] is List) {
                  // 관광지 리스트 변환
                  List<dynamic> jsonNearTravelInfo = items['item'];

                  // 필터링된 데이터 리스트
                  List<NearTravelInfoModel> travelInfoList = jsonNearTravelInfo
                      .map<NearTravelInfoModel>(
                          (item) => NearTravelInfoModel.fromJson(item))
                      .toList();

                  // NearTravelInfoResponse 반환
                  return NearTravelInfoResponse(
                    totalCount: totalCount.toString(),
                    travelInfoList: travelInfoList,
                  );
                }
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
      } else {
        errorMessage = getApiMessageForStatusCode('');
      }

      throw errorMessage;
    } catch (e) {
      errorMessage = getApiMessageForStatusCode('');
      throw errorMessage;
    }
  }

  // 2. 공통 정보 조회
  Future<TravelCommonInfoModel?>? getTravelCommonInfo(String contentId) async {
    try {
      Map<String, dynamic> parameters = {
        'serviceKey': dotenv.env['publicDataKey'],
        'MobileOS': 'AND',
        'MobileApp': 'MobileApp',
        'defaultYN': 'Y',
        'addrinfoYN': 'Y',
        'mapinfoYN': 'Y',
        'overviewYN': 'Y',
        'firstImageYN': 'Y',
        'contentId': contentId,
      };
      Uri uri =
          Uri.https(API.publicDataUrl, API.getTravelCommonInfo, parameters);
      http.Response result = await http.get(uri);

      if (result.statusCode == 200) {
        final body = convert.utf8.decode(result.bodyBytes);
        final xml = Xml2Json()..parse(body);
        final json = xml.toParker();

        Map<String, dynamic> jsonResult = convert.json.decode(json);

        if (jsonResult['response'] != null &&
            jsonResult['response']['body'] != null &&
            jsonResult['response']['body']['items'] != null) {
          final jsonTravelCommonInfo = jsonResult['response']['body']['items'];

          if (jsonTravelCommonInfo['item'] is Map<String, dynamic>) {
            TravelCommonInfoModel? travelCommonInfoList =
                TravelCommonInfoModel.fromJson(jsonTravelCommonInfo['item']);

            return travelCommonInfoList;
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

      throw errorMessage;
    } catch (e) {
      errorMessage = getApiMessageForStatusCode('');
      throw errorMessage;
    }
  }

  // 3. 소개 정보 조회
  Future<dynamic> getTravelDetailInfo(
      String contentId, String contentTypeId) async {
    try {
      Map<String, dynamic> parameters = {
        'serviceKey': dotenv.env['publicDataKey'],
        'MobileOS': 'AND',
        'MobileApp': 'MobileApp',
        'contentId': contentId,
        'contentTypeId': contentTypeId,
      };
      Uri uri =
          Uri.https(API.publicDataUrl, API.getTravelDetailInfo, parameters);
      http.Response result = await http.get(uri);

      if (result.statusCode == 200) {
        final body = convert.utf8.decode(result.bodyBytes);
        final xml = Xml2Json()..parse(body);
        final json = xml.toParker();

        Map<String, dynamic> jsonResult = convert.json.decode(json);

        if (jsonResult['response'] != null &&
            jsonResult['response']['body'] != null &&
            jsonResult['response']['body']['items'] != null) {
          var items = jsonResult['response']['body']['items'];

          if (items['item'] != null && items['item'] is Map<String, dynamic>) {
            dynamic travelDetailInfoList =
                travelDetailInfoModelParser(items['item'], contentTypeId);

            return travelDetailInfoList;
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

      throw errorMessage;
    } catch (e) {
      errorMessage = getApiMessageForStatusCode('');
      throw errorMessage;
    }
  }

  // 4. 이미지 정보 조회
  Future<TravelImageInfoResponse> getTravelImageInfo(
      int pageNo, int pageSize, String contentId) async {
    try {
      Map<String, dynamic> parameters = {
        'serviceKey': dotenv.env['publicDataKey'],
        'MobileOS': 'AND',
        'MobileApp': 'MobileApp',
        'pageNo': pageNo.toString(),
        'numOfRows': pageSize.toString(),
        'contentId': contentId,
        'imageYN': 'Y',
        'subImageYN': 'Y',
      };
      Uri uri =
          Uri.https(API.publicDataUrl, API.getTravelImageInfo, parameters);
      http.Response result = await http.get(uri);

      if (result.statusCode == 200) {
        final body = convert.utf8.decode(result.bodyBytes);
        final xml = Xml2Json()..parse(body);
        final json = xml.toParker();

        Map<String, dynamic> jsonResult = convert.json.decode(json);

        if (jsonResult['response'] != null) {
          if (jsonResult['response']['body'] != null) {
            // totalCount 가져오기
            int totalCount =
                int.parse(jsonResult['response']['body']['totalCount']);

            // items가 없는 경우 처리
            var items = jsonResult['response']['body']['items'];
            if (items == null || items == '' || items['item'] == null) {
              // items가 없을 때, 빈 리스트를 반환하고, totalCount만 포함
              return TravelImageInfoResponse(
                totalCount: totalCount.toString(),
                travelImageInfoList: [],
              );
            }

            // items가 존재하는 경우 처리
            if (items['item'] != null) {
              // item이 단일 객체인지, 리스트인지 확인
              if (items['item'] is Map<String, dynamic>) {
                // 단일 객체일 경우, 리스트로 감싸서 반환
                List<TravelImageInfoModel> travelImageInfoList = [
                  TravelImageInfoModel.fromJson(
                    Map<String, dynamic>.from(items['item']),
                  ),
                ];

                // TravelImageInfoResponse 반환
                return TravelImageInfoResponse(
                  totalCount: totalCount.toString(),
                  travelImageInfoList: travelImageInfoList,
                );
              } else if (items['item'] is List) {
                // 관광지 이미지 리스트 반환
                List<dynamic> jsonTravelImageInfo = items['item'];

                List<TravelImageInfoModel> travelImageInfoList =
                    jsonTravelImageInfo
                        .map<TravelImageInfoModel>(
                            (item) => TravelImageInfoModel.fromJson(item))
                        .toList();

                // TravelImageInfoResponse 반환
                return TravelImageInfoResponse(
                  totalCount: totalCount.toString(),
                  travelImageInfoList: travelImageInfoList,
                );
              }
            } else {
              return TravelImageInfoResponse(
                totalCount: totalCount.toString(),
                travelImageInfoList: [], // 빈 리스트 반환
              );
            }
          } else {
            errorMessage = getApiMessageForStatusCode('');
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
      throw errorMessage;
    } catch (e) {
      errorMessage = getApiMessageForStatusCode('');
      throw errorMessage;
    }
  }

  // 5. 네이버 블로그 검색 조회
  Future<List<TravelBlogInfoModel>> getTravelBlogInfo(
      int pageNo, int pageSize, String title, String sortIndex) async {
    try {
      Map<String, dynamic> parameters = {
        'query': title,
        'start': pageNo.toString(), // 검색 시작 위치 (현재 페이지)
        'display': pageSize.toString(), // 한번에 표시할 최대 개수
        'sort': sortIndex,
      };

      Uri uri = Uri.https(API.naverUrl, API.getTravelBlogInfo, parameters);
      http.Response result = await http.get(
        uri,
        headers: {
          "X-Naver-Client-Id": dotenv.env["X_Naver_Client_Id"]!,
          "X-Naver-Client-Secret": dotenv.env["X_Naver_Client_Secret"]!,
        },
      );

      if (result.statusCode == 200) {
        Map<String, dynamic> jsonResult = convert.json.decode(result.body);

        return TravelBlogInfoModel.fromJsonList(jsonResult);
      } else {
        Map<String, dynamic> jsonResult = convert.json.decode(result.body);
        errorMessage = getNaverApiMessageForStatusCode(jsonResult['errorCode']);
        throw errorMessage;
      }
    } catch (e) {
      if (errorMessage.isEmpty) {
        errorMessage = getApiMessageForStatusCode('');
      }
      throw errorMessage;
    }
  }
}
