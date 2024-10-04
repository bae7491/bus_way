import 'dart:convert';

import 'package:bus_way/data/api/api.dart';
import 'package:bus_way/data/api/api_enum.dart';
import 'package:bus_way/data/model/signup_user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthLocalDatasource with ChangeNotifier {
  ApiResponseStatus? statusCode; // 상태 코드 저장

  // db에 회원 정보 저장
  Future<void> saveUserInfo(SignUpUserModel signUpUser) async {
    bool isSuccess = false;
    try {
      var result = await http
          .post(
        Uri.parse(API.signup), // 회원가입 API 호출
        headers: {
          'Content-Type':
              'application/x-www-form-urlencoded', // 적절한 Content-Type 설정
        },
        body: signUpUser.toJson(),
      )
          .timeout(
        const Duration(minutes: 1), // 타임아웃을 1분으로 설정
        onTimeout: () {
          return http.Response(
              'Error: Request Timeout', 408); // 408은 타임아웃 상태 코드
        },
      );

      print('result: ${result.statusCode}');

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

  // 중복 체크 값 검사
  Future<bool> checkUserUnique(
      String email, String phoneNumber, String nickName) async {
    bool isDuplicate = false; // 중복 여부 저장 변수

    try {
      var result = await http.post(
        Uri.parse(API.validateUserUnique),
        headers: {
          'Content-Type':
              'application/x-www-form-urlencoded', // 적절한 Content-Type 설정
        },
        body: {'email': email, 'phoneNumber': phoneNumber},
      ).timeout(
        const Duration(seconds: 5), // 타임아웃을 1분으로 설정
        onTimeout: () {
          return http.Response(
              'Error: Request Timeout', 408); // 408은 타임아웃 상태 코드
        },
      );

      // 서버와 연동 여부 확인
      if (result.statusCode == 200) {
        var responseBody = jsonDecode(result.body);

        if (responseBody['existUserUnique'] == true) {
          statusCode = ApiResponseStatus.duplicateUser;
          isDuplicate = true;
        } else {
          isDuplicate = false;
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
    } finally {
      // 중복값이 있거나 상태 코드가 에러일 때만 메시지 던짐
      if (isDuplicate && statusCode != null) {
        throw getMessageForStatusCode(
            statusCode ?? ApiResponseStatus.unknownError);
      }
    }

    return false;
  }
}
