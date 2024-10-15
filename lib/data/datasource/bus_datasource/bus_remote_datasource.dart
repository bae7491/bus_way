import 'package:bus_way/data/api/api.dart';
import 'package:bus_way/data/api/api_enum.dart';
import 'package:bus_way/data/model/bus_model/bus_stop_info_model.dart';
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
        'numOfRows': '50',
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
                    item['nodeid'].toString().startsWith('BSB') &&
                    item['nodeno'] != null)
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
  Future<List<BusStopInfoModel>?> getBusStopInfo(String bstopid) async {
    try {
      Map<String, dynamic> parameters = {
        'serviceKey': dotenv.env['publicDataKey'],
        'bstopid': bstopid.replaceFirst(
            'BSB', ''), // 정류장 ID가 'BSB0000' -> '0000'으로 변경해야 데이터를 제대로 불러옴
      };

      Uri uri = Uri.https(API.tagoBusStop, API.getBusStopInfo, parameters);
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
                BusStopInfoModel.fromJson(
                    Map<String, dynamic>.from(jsonBusStop['item']))
              ];
            } else if (jsonBusStop['item'] is List) {
              // 리스트일 경우
              List<dynamic> busStopList = jsonBusStop['item'];

              busStopList.sort(
                (a, b) {
                  // 버스 타입에 따른 우선순위 비교
                  int typeComparison =
                      _compareBusType(a['bustype'], b['bustype']);
                  if (typeComparison != 0) {
                    return typeComparison; // 타입이 다르면 타입에 따라 정렬
                  }

                  // 'lineno'에서 숫자 및 하위 번호 (ex.5-1에서 5와 1) 추출해서 비교
                  List<int> linenoA =
                      _extractBusNumberAndSubNumber(a['lineno']);
                  List<int> linenoB =
                      _extractBusNumberAndSubNumber(b['lineno']);

                  // 번호 비교
                  int mainNumberComparison = linenoA[0].compareTo(linenoB[0]);
                  if (mainNumberComparison != 0) {
                    return mainNumberComparison; // 메인 번호가 다르면 그에 따라 정렬
                  }

                  // 메인 번호가 같을 때 하위 번호 비교 (-가 포함된 경우)
                  return linenoA[1].compareTo(linenoB[1]);
                },
              );

              return busStopList
                  .map<BusStopInfoModel>((item) => BusStopInfoModel.fromJson(
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

  // 버스 타입을 비교하여 정렬하는 함수
  int _compareBusType(String typeA, String typeB) {
    // 버스 타입을 우선순위에 따라 정렬: 일반 > 급행 > 기타
    const List<String> busTypePriority = ['일반버스', '급행버스', '심야버스(급행)', '기타'];
    int indexA = busTypePriority.indexOf(typeA);
    int indexB = busTypePriority.indexOf(typeB);

    // 기타 항목으로 처리
    if (indexA == -1) indexA = busTypePriority.length;
    if (indexB == -1) indexB = busTypePriority.length;

    return indexA.compareTo(indexB);
  }

  // 'lineno'에서 메인 번호와 하위 번호를 추출하는 함수
  List<int> _extractBusNumberAndSubNumber(String lineno) {
    // '5-1'과 같은 경우를 처리하기 위해 '-'로 분리
    List<String> parts = lineno.replaceAll(RegExp(r'[^0-9\-]'), '').split('-');

    // 메인 번호 (앞부분)와 하위 번호 (뒷부분) 추출
    int mainNumber = int.tryParse(parts[0]) ?? 0;
    int subNumber = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

    return [mainNumber, subNumber];
  }
}
