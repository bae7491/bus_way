import 'dart:convert';

import 'package:bus_way/data/api/api.dart';
import 'package:bus_way/data/api/api_enum.dart';
import 'package:bus_way/data/model/mypage_model/mypage_user_model.dart';
import 'package:bus_way/data/model/mypage_model/user_follow_model.dart';
import 'package:bus_way/data/model/mypage_model/user_follow_review_summary_model.dart';
import 'package:bus_way/data/model/mypage_model/user_review_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MypageLocalDatasource with ChangeNotifier {
  ApiResponseStatus? statusCode;

  // 1. 로그인 회원 정보 조회
  Future<MypageUserModel> getUserInfo() async {
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

      if (result.statusCode == 200) {
        final userInfoResult = jsonDecode(result.body);

        if (userInfoResult['success'] == true) {
          return MypageUserModel(
            email: userInfoResult['email'],
            nickName: userInfoResult['nickName'],
            name: userInfoResult['name'],
            phoneNumber: userInfoResult['phoneNumber'],
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

  // 2. 회원의 관광지 팔로우 & 후기 총 개수 조회
  Future<UserFollowReviewSummaryModel> getFollowReviewCount() async {
    try {
      // 기기에 저장된 email 정보 불러오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('loginEmail') ?? "";

      var result = await http.post(
        Uri.parse(API.getFollowReviewCount),
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

      if (result.statusCode == 200) {
        var followReviewResult = jsonDecode(result.body);
        if (followReviewResult['success'] == true) {
          return UserFollowReviewSummaryModel(
            followTotalCount: followReviewResult['follow_count'],
            reviewTotalCount: followReviewResult['review_count'],
          );
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
      throw getMessageForStatusCode(
          statusCode ?? ApiResponseStatus.unknownError);
    } catch (e) {
      statusCode = ApiResponseStatus.unknownError;
      throw getMessageForStatusCode(
          statusCode ?? ApiResponseStatus.unknownError);
    }
  }

  // 3. 회원의 관광지 팔로우 목록 조회
  Future<List<UserFollowModel>> getFollowList(int pageNo, int pageSize) async {
    try {
      // 기기에 저장된 email 정보 불러오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('loginEmail') ?? "";

      var result = await http.post(
        Uri.parse(API.getFollowList),
        headers: {
          'Content-Type':
              'application/x-www-form-urlencoded', // 적절한 Content-Type 설정
        },
        body: {
          'email': email,
          'pageNo': pageNo.toString(),
          'pageSize': pageSize.toString(),
        },
      ).timeout(
        const Duration(minutes: 1), // 타임아웃을 1분으로 설정
        onTimeout: () {
          return http.Response(
              'Error: Request Timeout', 408); // 408은 타임아웃 상태 코드
        },
      );

      if (result.statusCode == 200) {
        final followResult = jsonDecode(result.body);

        if (followResult['success'] == true) {
          return UserFollowModel.fromJsonList(followResult);
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

  // 4. 회원의 관광지 후기 목록 조회
  Future<List<UserReviewModel>> getReviewList(
      int pageNo, int pageSize, String sortIndex) async {
    try {
      // 기기에 저장된 email 정보 불러오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('loginEmail') ?? "";

      var result = await http.post(Uri.parse(API.getReviewList), headers: {
        'Content-Type':
            'application/x-www-form-urlencoded', // 적절한 Content-Type 설정
      }, body: {
        'server_url': API.hostConnect,
        'email': email,
        'pageNo': pageNo.toString(),
        'pageSize': pageSize.toString(),
        'sort': sortIndex,
      }).timeout(
        const Duration(minutes: 1), // 타임아웃을 1분으로 설정
        onTimeout: () {
          return http.Response(
              'Error: Request Timeout', 408); // 408은 타임아웃 상태 코드
        },
      );

      if (result.statusCode == 200) {
        final reviewResult = jsonDecode(result.body);

        if (reviewResult['success'] == true) {
          return UserReviewModel.fromJsonList(reviewResult);
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

  // 5. 회원의 관광지 후기 삭제
  Future<void> deleteReview(String reviewId, [String? reviewImage]) async {
    try {
      var result = await http.post(
        Uri.parse(API.deleteReview),
        headers: {
          'Content-Type':
              'application/x-www-form-urlencoded', // 적절한 Content-Type 설정
        },
        body: {
          'review_id': reviewId,
          'review_image': reviewImage ?? '',
        },
      ).timeout(
        const Duration(minutes: 1), // 타임아웃을 1분으로 설정
        onTimeout: () {
          return http.Response(
              'Error: Request Timeout', 408); // 408은 타임아웃 상태 코드
        },
      );

      if (result.statusCode == 200) {
        final deleteReviewResult = jsonDecode(result.body);

        if (deleteReviewResult['success'] == true) {
          return;
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

  // 6. 회원의 관광지 후기 수정
  Future<void> modifyReview(String reviewId, double rating, String content,
      String contentId, String title,
      [String? originalImagePath, XFile? imageFile]) async {
    try {
      // 기기에 저장된 email 정보 불러오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('loginEmail') ?? "";

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(API.modifyReview),
      );

      request.fields['review_id'] = reviewId;
      request.fields['email'] = email;
      request.fields['content_id'] = contentId;
      request.fields['title'] = title;
      request.fields['review_rate'] = rating.toString();
      request.fields['review_content'] = content;
      if (originalImagePath != null) {
        request.fields['original_image_path'] = originalImagePath;
      }
      if (imageFile != null && imageFile.path.startsWith('http')) {
        request.fields['not_changed'] = 'true';
      }
      if (imageFile != null && !imageFile.path.startsWith('http')) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
          ),
        );
      }

      var result = await request.send();

      if (result.statusCode == 200) {
        // 응답을 문자열로 변환한 후 JSON 파싱
        var responseBody = await result.stream.bytesToString();
        var modifyReviewResult = jsonDecode(responseBody);

        if (modifyReviewResult['success'] == true) {
          return;
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

  // 7. 회원의 내정보 수정 중복값 검사
  Future<bool> validateModifyUserUnique(
      String phoneNumber, String nickName) async {
    try {
      // 기기에 저장된 email 정보 불러오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('loginEmail') ?? "";

      var result = await http.post(
        Uri.parse(API.validateModifyUserInfo),
        headers: {
          'Content-Type':
              'application/x-www-form-urlencoded', // 적절한 Content-Type 설정
        },
        body: {
          'email': email,
          'phoneNumber': phoneNumber,
          'nickName': nickName,
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

        if (responseBody['existUserUnique'] == true) {
          statusCode = ApiResponseStatus.duplicateUser;
          return true;
        } else {
          return false;
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
      return false;
    } catch (e) {
      statusCode = ApiResponseStatus.unknownError;
      return false;
    }
  }

  // 8. 회원의 내정보 수정
  Future<void> modifyUserInfo(String phoneNumber, String nickName) async {
    try {
      // 기기에 저장된 email 정보 불러오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('loginEmail') ?? "";

      var result = await http.post(
        Uri.parse(API.modifyUserInfo),
        headers: {
          'Content-Type':
              'application/x-www-form-urlencoded', // 적절한 Content-Type 설정
        },
        body: {
          'email': email,
          'phoneNumber': phoneNumber,
          'nickName': nickName,
        },
      ).timeout(
        const Duration(minutes: 1), // 타임아웃을 1분으로 설정
        onTimeout: () {
          return http.Response(
              'Error: Request Timeout', 408); // 408은 타임아웃 상태 코드
        },
      );

      if (result.statusCode == 200) {
        final modifyUserInfoResult = jsonDecode(result.body);

        if (modifyUserInfoResult['success'] == true) {
          return;
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
