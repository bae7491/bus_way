import 'package:bus_way/data/api/api.dart';
import 'package:bus_way/data/api/api_enum.dart';
import 'package:bus_way/data/model/bus_model/bus_info_model.dart';
import 'package:bus_way/data/model/bus_model/bus_line_model.dart';
import 'package:bus_way/data/model/bus_model/bus_arrive_info_model.dart';
import 'package:bus_way/data/model/bus_model/near_bus_stop_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:xml2json/xml2json.dart';

class BusRemoteDatasource with ChangeNotifier {
  ApiResponseStatus? statusCode; // 상태 코드 저장
  String errorMessage = '';

  // 1, 좌표 기반 근접(500m 이내) 버스 정류소 목록 조회
  Future<List<NearBusStopModel>?> getNearBusStop(LatLng center) async {
    try {
      Map<String, dynamic> parameters = {
        'serviceKey': dotenv.env['publicDataKey'],
        'pageNo': '1',
        'numOfRows': '100',
        'gpsLati': center.latitude.toString(), // 위도
        'gpsLong': center.longitude.toString(), // 경도
      };
      Uri uri = Uri.https(API.tagoBusStop, API.getNearBusStop, parameters);
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
            final jsonNearBus = jsonResult['response']['body']['items'];
            List<dynamic> nearBusList = jsonNearBus['item'];

            // 필터링하여 citycode가 21 (부산)이고 nodeid가 BSB (일반 버스)로 시작하는 데이터만 반환
            return nearBusList
                .where((item) =>
                        item['citycode'] == '21' &&
                        item['nodeid'].toString().startsWith('BSB')
                    // &&
                    // item['nodeno'] != null
                    )
                .map<NearBusStopModel>(
                    (item) => NearBusStopModel.fromJson(item))
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
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // 2. 정류소 도착 정보 조회 (정류장 ID)
  Future<List<BusArriveInfoModel>?> getBusArriveInfo(String bstopid) async {
    try {
      Map<String, dynamic> parameters = {
        'serviceKey': dotenv.env['publicDataKey'],
        'bstopid': bstopid.replaceFirst(
            'BSB', ''), // 정류장 ID가 'BSB0000' -> '0000'으로 변경해야 데이터를 제대로 불러옴
      };

      Uri uri = Uri.https(API.tagoBusStop, API.getBusArriveInfo, parameters);
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
            final jsonBusStop = jsonResult['response']['body']['items'];

            // item이 단일 객체인지, 리스트인지 확인
            if (jsonBusStop['item'] is Map<String, dynamic>) {
              // 단일 객체일 경우, 리스트로 감싸서 반환
              return [
                BusArriveInfoModel.fromJson(
                  Map<String, dynamic>.from(jsonBusStop['item']),
                ),
              ];
            } else if (jsonBusStop['item'] is List) {
              // 리스트일 경우
              List<dynamic> busStopList = jsonBusStop['item'];

              // 정렬 로직 수정
              busStopList.sort(
                (a, b) {
                  // 'lineno'에서 숫자 및 하위 번호, 부가 정보 (ex. 5-1(심야)) 추출해서 비교
                  List linenoA = _extractBusNumberAndInfo(a['lineno']);
                  List linenoB = _extractBusNumberAndInfo(b['lineno']);

                  // 메인 번호 비교
                  int mainNumberComparison = linenoA[0].compareTo(linenoB[0]);
                  if (mainNumberComparison != 0) {
                    return mainNumberComparison; // 메인 번호가 다르면 그에 따라 정렬
                  }

                  // 메인 번호가 같을 때 하위 번호 비교 (-가 포함된 경우)
                  int subNumberComparison = linenoA[1].compareTo(linenoB[1]);
                  if (subNumberComparison != 0) {
                    return subNumberComparison;
                  }

                  // 마지막으로 부가 정보 비교 (ex. 심야)
                  return linenoA[2].compareTo(linenoB[2]);
                },
              );

              return busStopList
                  .map<BusArriveInfoModel>((item) =>
                      BusArriveInfoModel.fromJson(
                          Map<String, dynamic>.from(item)))
                  .toList();
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
        }
      } else {
        errorMessage = getApiMessageForStatusCode('');
      }
      throw errorMessage;
    } catch (e) {
      print('e.toString: ${e.toString()}');
      errorMessage = getApiMessageForStatusCode('');
      throw errorMessage;
    }
  }

  // 'lineno'에서 메인 번호와 하위 번호, 그리고 부가 정보를 추출하는 함수
  List _extractBusNumberAndInfo(String lineno) {
    // '5-1(심야)' 같은 경우를 처리하기 위해 숫자와 부가 정보를 분리
    RegExp regExp = RegExp(r'(\d+)(?:-(\d+))?\s*(\(.+\))?');
    Match? match = regExp.firstMatch(lineno);

    if (match != null) {
      // 메인 번호와 하위 번호 추출
      int mainNumber = int.tryParse(match.group(1)!) ?? 0;
      int subNumber =
          match.group(2) != null ? int.tryParse(match.group(2)!) ?? 0 : 0;
      String extraInfo = match.group(3) ?? ''; // '(심야)' 같은 부가 정보

      return [mainNumber, subNumber, extraInfo];
    } else {
      // 형식이 맞지 않는 경우 기본 값 반환
      return [0, 0, ''];
    }
  }

  // 3. 노선 정보 조회 (버스 상세 정보)
  Future<List<BusInfoModel>?> getBusDetailInfo(String lineId) async {
    try {
      Map<String, dynamic> parameters = {
        'serviceKey': dotenv.env['publicDataKey'],
        'lineid': lineId,
      };
      Uri uri = Uri.https(API.tagoBusStop, API.getBusDetailInfo, parameters);
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
            final jsonBusDetailInfo = jsonResult['response']['body']['items'];

            return [
              BusInfoModel.fromJson(
                  Map<String, dynamic>.from(jsonBusDetailInfo['item']))
            ];
          } else {
            errorMessage = getApiMessageForStatusCode('');
            throw errorMessage;
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

  // 4. 노선 정류소 조회 (해당 버스 전체 노선 불러오기)
  Future<List<BusLineModel>?> getBusLineInfo(String lineId) async {
    try {
      Map<String, dynamic> parameters = {
        'serviceKey': dotenv.env['publicDataKey'],
        'lineid': lineId,
      };
      Uri uri = Uri.https(API.tagoBusStop, API.getBusLineInfo, parameters);
      http.Response result = await http.get(uri);

      if (result.statusCode == 200) {
        final body = convert.utf8.decode(result.bodyBytes);
        final xml = Xml2Json()..parse(body);
        final json = xml.toParker();

        Map<String, dynamic> jsonResult = convert.json.decode(json);

        if (jsonResult['response'] != null &&
            jsonResult['response']['body'] != null &&
            jsonResult['response']['body']['items'] != null) {
          final jsonLineInfo = jsonResult['response']['body']['items'];

          List<dynamic> busLineList = jsonLineInfo['item'];

          return busLineList
              .map<BusLineModel>((item) => BusLineModel.fromJson(item))
              .toList();
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
