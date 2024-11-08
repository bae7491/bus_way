import 'package:bus_way/constant/travel_category_constant.dart';
import 'package:bus_way/data/model/mypage_model/user_follow_model.dart';
import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/mypage/follow_list/follow_list_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

Widget followPagedListView(FollowListViewModel viewmodel) {
  return Expanded(
    child: PagedListView<int, UserFollowModel>(
      pagingController: viewmodel.followPageController,
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 썸네일 이미지
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade300, // 이미지가 없을 때 배경
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Center(
                          child: item.firstImage != null &&
                                  item.firstImage!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: item.firstImage!,
                                  progressIndicatorBuilder:
                                      (context, url, progress) => const Center(
                                    child: SpinKitRing(
                                      color: orchid, // 원하는 색상
                                      size: 30.0, // 크기 설정
                                      lineWidth: 5.0,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.image_not_supported_outlined),
                        ),
                      ),
                    ),
                  ),
                  // 텍스트 정보 (관광지 이름, 카테고리) 및 삭제 버튼
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 장소 이름
                          Text(
                            item.title!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // 카테고리 (예: 관광지, 문화시설)
                          Text(
                            travelCategory[int.parse(item.contentTypeId!)]!,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              viewmodel.checkDeleteFollow(context, item);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: orchid,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              '삭제',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (index <
                  viewmodel.followPageController.itemList!.length -
                      1) // 마지막 항목이 아닐 때만 Divider 추가
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Divider(
                    thickness: 1,
                    height: 0,
                  ),
                ),
            ],
          ),
        ),
        noItemsFoundIndicatorBuilder: (context) => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded, // 경고 아이콘
                size: 50.0, // 아이콘 크기
                color: Colors.orange, // 아이콘 색상
              ),
              SizedBox(height: 16), // 텍스트와 아이콘 사이 간격
              Text(
                '관광지 팔로우 목록이 없습니다!',
                style: TextStyle(
                  fontSize: 18, // 텍스트 크기
                  fontWeight: FontWeight.bold, // 텍스트 굵기
                  color: Colors.black, // 텍스트 색상
                ),
              ),
            ],
          ),
        ),
        firstPageProgressIndicatorBuilder: (context) => const Center(
          child: SpinKitRing(
            color: orchid, // 원하는 색상
            size: 100.0, // 크기 설정
          ),
        ),
        newPageProgressIndicatorBuilder: (context) => const Center(
          child: SpinKitRing(
            color: orchid, // 원하는 색상
            size: 30.0, // 크기 설정
            lineWidth: 5.0,
          ),
        ),
      ),
    ),
  );
}
