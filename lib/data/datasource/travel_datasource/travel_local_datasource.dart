import 'dart:convert';

import 'package:bus_way/data/api/api.dart';
import 'package:bus_way/data/api/api_enum.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TravelLocalDatasource with ChangeNotifier {
  ApiResponseStatus? statusCode;

  // 1. DB에 관광지 팔로우 정보 저장
  Future<void> requestFollow(String contentId, String contentTypeId,
      String title, String travelImage) async {
    bool isSuccess = false;
    try {
      // 기기에 저장한 email 정보 불러오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('loginEmail');

      var result = await http.post(
        Uri.parse(API.travelFollow),
        headers: {
          'Content-Type':
              'application/x-www-form-urlencoded', // 적절한 Content-Type 설정
        },
        body: {
          'email': email,
          'content_id': contentId,
          'title': title,
          'content_type_id': contentTypeId,
          'firstimage': travelImage,
        },
      ).timeout(
        const Duration(minutes: 1), // 타임아웃을 1분으로 설정
        onTimeout: () {
          return http.Response(
              'Error: Request Timeout', 408); // 408은 타임아웃 상태 코드
        },
      );

      if (result.statusCode == 200) {
        var signUpResult = jsonDecode(result.body);
        if (signUpResult['success'] == true) {
          isSuccess = true;
        } else {
          statusCode = ApiResponseStatus.unknownError;
        }
      } else if (result.statusCode == 400) {
        statusCode = ApiResponseStatus.badRequest;
      } else if (result.statusCode == 401) {
        statusCode = ApiResponseStatus.unauthorized;
      } else if (result.statusCode == 408) {
        statusCode = ApiResponseStatus.requestTimeout;
      } else if (result.statusCode == 500) {
        statusCode = ApiResponseStatus.serverError;
      } else {
        statusCode = ApiResponseStatus.unknownError;
      }
    } catch (e) {
      statusCode = ApiResponseStatus.unknownError;
    } finally {
      // 상태 코드에 따른 메시지를 던짐
      if (!isSuccess) {
        throw getMessageForStatusCode(
            statusCode ?? ApiResponseStatus.unknownError);
      }
    }
  }

  // 2. DB에 관광지 팔로우 정보 삭제 (언팔로우)
  Future<void> requestUnFollow(String contentId, String contentTypeId,
      String title, String travelImage) async {
    bool isSuccess = false;
    try {
      // 기기에 저장한 email 정보 불러오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('loginEmail');

      var result = await http.post(
        Uri.parse(API.travelUnFollow),
        headers: {
          'Content-Type':
              'application/x-www-form-urlencoded', // 적절한 Content-Type 설정
        },
        body: {
          'email': email,
          'content_id': contentId,
          'title': title,
          'content_type_id': contentTypeId,
          'firstimage': travelImage,
        },
      ).timeout(
        const Duration(minutes: 1), // 타임아웃을 1분으로 설정
        onTimeout: () {
          return http.Response(
              'Error: Request Timeout', 408); // 408은 타임아웃 상태 코드
        },
      );

      if (result.statusCode == 200) {
        var signUpResult = jsonDecode(result.body);
        if (signUpResult['success'] == true) {
          isSuccess = true;
        } else {
          statusCode = ApiResponseStatus.unknownError;
        }
      } else if (result.statusCode == 400) {
        statusCode = ApiResponseStatus.badRequest;
      } else if (result.statusCode == 401) {
        statusCode = ApiResponseStatus.unauthorized;
      } else if (result.statusCode == 408) {
        statusCode = ApiResponseStatus.requestTimeout;
      } else if (result.statusCode == 500) {
        statusCode = ApiResponseStatus.serverError;
      } else {
        statusCode = ApiResponseStatus.unknownError;
      }
    } catch (e) {
      statusCode = ApiResponseStatus.unknownError;
    } finally {
      // 상태 코드에 따른 메시지를 던짐
      if (!isSuccess) {
        throw getMessageForStatusCode(
            statusCode ?? ApiResponseStatus.unknownError);
      }
    }
  }

  // 3. DB에서 선택한 관광지 팔로우 정보가 존재하는지 확인
  Future<bool> checkTravelFollow(String contentId) async {
    try {
      // 기기에 저장한 email 정보 불러오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('loginEmail');

      var result = await http.post(
        Uri.parse(API.checkTravelFollow),
        headers: {
          'Content-Type':
              'application/x-www-form-urlencoded', // 적절한 Content-Type 설정
        },
        body: {
          'email': email,
          'content_id': contentId,
        },
      ).timeout(
        const Duration(minutes: 1), // 타임아웃을 1분으로 설정
        onTimeout: () {
          return http.Response(
              'Error: Request Timeout', 408); // 408은 타임아웃 상태 코드
        },
      );

      // 서버와 연동 여부 확인
      if (result.statusCode == 200) {
        var responseBody = jsonDecode(result.body);

        if (responseBody['existTravelInfo'] == true) {
          return true;
        }
      } else if (result.statusCode == 400) {
        statusCode = ApiResponseStatus.badRequest;
      } else if (result.statusCode == 401) {
        statusCode = ApiResponseStatus.unauthorized;
      } else if (result.statusCode == 408) {
        statusCode = ApiResponseStatus.requestTimeout;
      } else if (result.statusCode == 500) {
        statusCode = ApiResponseStatus.serverError;
      } else {
        statusCode = ApiResponseStatus.unknownError;
      }
    } catch (e) {
      statusCode = ApiResponseStatus.unknownError;
      return false;
    }
    return false;
  }
}
