import 'dart:convert';

import 'package:bus_way/data/api/api.dart';
import 'package:bus_way/data/api/api_enum.dart';
import 'package:bus_way/data/model/travel_model/travel_review_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_review_summary_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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
        var followResult = jsonDecode(result.body);
        if (followResult['success'] == true) {
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
        var unFollowResult = jsonDecode(result.body);
        if (unFollowResult['success'] == true) {
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

  // 4. 관광지 리뷰 업로드 DB 요청
  Future<void> uploadTravelReview(
      double rating, String content, String contentId,
      [XFile? imageFile]) async {
    bool isSuccess = false;
    try {
      // 기기에 저장된 email 정보 불러오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('loginEmail') ?? "";

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(API.uploadTravelReview),
      );

      request.fields['email'] = email;
      request.fields['content_id'] = contentId;
      request.fields['review_rate'] = rating.toString();
      request.fields['review_content'] = content;
      if (imageFile != null) {
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
        var reviewResult = jsonDecode(responseBody);

        if (reviewResult['success'] == true) {
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

  // 5. 관광지 리뷰 총 개수, 평점 평균 조회
  Future<TravelReviewSummaryModel> getTravelReviewSummary(
      String contentId) async {
    try {
      // 기기에 저장된 email 정보 불러오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('loginEmail') ?? "";

      var result = await http.post(
        Uri.parse(API.getTravelReviewSummary),
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

      if (result.statusCode == 200) {
        var reviewResult = jsonDecode(result.body);
        if (reviewResult['success'] == true) {
          return TravelReviewSummaryModel(
            reviewCount: reviewResult['review_count'],
            reviewAverageRate: reviewResult['review_rate'],
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

  // 6. 관광지 리뷰 조회
  Future<List<TravelReviewInfoModel>> getTravelReviewInfo(
      int pageNo, int pageSize, String contentId, String sortIndex) async {
    try {
      // 기기에 저장한 email 정보 불러오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('loginEmail');

      var result = await http.post(
        Uri.parse(API.getTravelReviewInfo),
        headers: {
          'Content-Type':
              'application/x-www-form-urlencoded', // 적절한 Content-Type 설정
        },
        body: {
          'server_url': API.hostConnect,
          'email': email,
          'content_id': contentId,
          'pageNo': pageNo.toString(),
          'pageSize': pageSize.toString(),
          'sort': sortIndex,
        },
      ).timeout(
        const Duration(minutes: 1), // 타임아웃을 1분으로 설정
        onTimeout: () {
          return http.Response(
              'Error: Request Timeout', 408); // 408은 타임아웃 상태 코드
        },
      );

      if (result.statusCode == 200) {
        final reviewResult = jsonDecode(result.body);

        if (reviewResult['success'] == true) {
          return TravelReviewInfoModel.fromJsonList(reviewResult);
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
