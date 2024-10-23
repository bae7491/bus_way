import 'package:bus_way/constant/travel_category_constant.dart';
import 'package:bus_way/data/model/travel_model/near_travel_info_model.dart';
import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/main_map/main_map_travel_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class TravelInfoCard extends StatelessWidget {
  const TravelInfoCard({
    super.key,
    required this.travelViewModel,
  });

  final MainMapTravelViewModel travelViewModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => travelViewModel.pageController.refresh(),
        ),
        child: PagedListView<int, NearTravelInfoModel>(
          pagingController: travelViewModel.pageController,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, item, index) => Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: InkWell(
                onTap: () {
                  // TODO: 관광지 선택 후, 뷰 이동 및 이벤트 추가.
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: Center(
                            child: item.travelImage != null &&
                                    item.travelImage!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: item.travelImage!,
                                    progressIndicatorBuilder:
                                        (context, url, progress) =>
                                            const Center(
                                      child: SpinKitRing(
                                        color: orchid, // 원하는 색상
                                        size: 30.0, // 크기 설정
                                        lineWidth: 5.0,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.image_not_supported_outlined),
                          ),
                        ),
                      ),
                      // 텍스트 정보 (관광지 이름, 카테고리, 평점, 거리 등)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 장소 이름
                              Text(
                                item.travelTitle ?? '장소 이름',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // 카테고리 (예: 관광지, 문화시설)
                              Text(
                                travelCategory[
                                        int.parse(item.contentTypeId!)] ??
                                    '카테고리',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // 평점 및 거리 정보
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // TODO: 별점 불러오기.
                                  // Row(
                                  //   children: List.generate(5, (starIndex) {
                                  //     return const Icon(
                                  //       // starIndex < item.rating ? Icons.star : Icons.star_border,
                                  //       Icons.star,
                                  //       color: Colors.blueAccent,
                                  //       size: 20,
                                  //     );
                                  //   }),
                                  // ),
                                  // const SizedBox(width: 8),
                                  // 거리 정보
                                  Text(
                                    '${double.parse(item.distance!).round()} m',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                    '검색된 여행지가 없습니다!',
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
      ),
    );
  }
}
