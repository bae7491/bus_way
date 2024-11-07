import 'dart:convert';

import 'package:bus_way/data/api/api.dart';
import 'package:bus_way/data/api/api_enum.dart';
import 'package:bus_way/data/model/mypage_model/mypagae_user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MypageLocalDatasource with ChangeNotifier {
  ApiResponseStatus? statusCode;

  // 1. 로그인 회원 정보 조회
  Future<MypagaeUserModel> getUserInfo() async {
    try {
      // 기기에 저장된 email 정보 불러오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('loginEmail') ?? "";

      var result = await http.post(
        Uri.parse(API.getUserInfo),
        headers: {
          'Content-Type':
              'application/x-www-form-urlencoded', // 적절한 Content-Type 설정
        },
        body: {
          'email': email,
        },
      ).timeout(
        const Duration(minutes: 1), // 타임아웃을 1분으로 설정
        onTimeout: () {
          return http.Response(
              'Error: Request Timeout', 408); // 408은 타임아웃 상태 코드
        },
      );

      print('result.statusCode: ${result.statusCode}');

      if (result.statusCode == 200) {
        final userInfoResult = jsonDecode(result.body);

        if (userInfoResult['success'] == true) {
          return MypagaeUserModel(
            email: userInfoResult['email'],
            nickName: userInfoResult['nickName'],
          );
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

      throw getMessageForStatusCode(
          statusCode ?? ApiResponseStatus.unknownError);
    } catch (e) {
      statusCode = ApiResponseStatus.unknownError;
      throw getMessageForStatusCode(
          statusCode ?? ApiResponseStatus.unknownError);
    }
  }
}
