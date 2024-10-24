import 'package:bus_way/data/model/travel_model/travel_detail_info_model/course_detail_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/culture_detail_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/event_detail_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/food_detail_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/leports_detail_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/lodging_detail_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/shopping_detail_info_model.dart';
import 'package:bus_way/data/model/travel_model/travel_detail_info_model/travel_detail_info_model.dart';

dynamic travelDetailInfoModelParser(
    Map<String, dynamic> json, String contentTypeId) {
  switch (contentTypeId) {
    // 관광지
    case '12':
      return TravelDetailInfoModel.fromJson(json);
    // 문화시설
    case '14':
      return CultureDetailInfoModel.fromJson(json);
    // 축제/공연/행사
    case '15':
      return EventDetailInfoModel.fromJson(json);
    // 여행 코스
    case '25':
      return CourseDetailInfoModel.fromJson(json);
    // 레포츠
    case '28':
      return LeportsDetailInfoModel.fromJson(json);
    // 숙박
    case '32':
      return LodgingDetailInfoModel.fromJson(json);
    // 쇼핑
    case '38':
      return ShoppingDetailInfoModel.fromJson(json);
    // 음식점
    case '39':
      return FoodDetailInfoModel.fromJson(json);
  }
}
