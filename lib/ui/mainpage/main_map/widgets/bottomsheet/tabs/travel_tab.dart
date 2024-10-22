import 'package:bus_way/constant/travel_category_constant.dart';
import 'package:bus_way/data/model/travel_model/near_travel_info_model.dart';
import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/main_map/main_map_travel_viewmodel.dart';
import 'package:bus_way/ui/mainpage/main_map/main_map_viewmodel.dart';
import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class TravelTab extends StatelessWidget {
  const TravelTab({
    super.key,
    required this.viewModel,
    required this.scrollController,
  });

  final MainMapViewModel viewModel;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final mainMapViewModel =
        Provider.of<MainMapViewModel>(context, listen: false);

    return Consumer<MainMapTravelViewModel>(
      builder: (context, travelViewModel, child) {
        return Column(
          children: [
            const SizedBox(height: 20),
            SingleChildScrollView(
              child: ChipList(
                // 상위 카테고리
                listOfChipIndicesCurrentlySelected:
                    travelViewModel.selectedIndex != null
                        ? [travelViewModel.selectedIndex!]
                        : [travelCategory.keys.first],
                listOfChipNames: travelCategory.values.toList(), // 항목 리스트
                supportsMultiSelect: false, // 단일 선택만 가능하게 설정
                activeBgColorList: [Colors.grey.shade400], // 선택된 Chip의 배경 색상
                inactiveBgColorList: [
                  Colors.grey.shade300
                ], // 선택되지 않은 Chip의 배경 색상
                activeTextColorList: const [Colors.black], // 선택된 Chip의 텍스트 색상
                inactiveTextColorList: const [
                  Colors.black
                ], // 선택되지 않은 Chip의 텍스트 색상
                style: const TextStyle(fontSize: 16), // 텍스트 스타일
                extraOnToggle: (index) {
                  travelViewModel.setCategoryIndex(index);

                  // TODO: 컨텐츠 타입 ID를 저장했다가, 위치 기반 관광 API 요청 할 때 contentId로 보내야 함.
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => Future.sync(
                  () => travelViewModel.pageController.refresh(),
                ),
                child: PagedListView<int, NearTravelInfoModel>(
                  pagingController: travelViewModel.pageController,
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (context, item, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
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
                                      ? Image.network(item.travelImage!)
                                      : const Icon(
                                          Icons.image_not_supported_outlined),
                                ),
                              ),
                            ),
                            // 텍스트 정보
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 장소 이름
                                    Text(
                                      item.travelTitle ?? '장소 이름',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    // 카테고리 (예: 관광지, 문화시설)
                                    Text(
                                      travelCategory[item.contentTypeId] ??
                                          '카테고리',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    // 평점 및 거리 정보
                                    Row(
                                      children: [
                                        // 별점
                                        // Row(
                                        //   children: List.generate(5, (starIndex) {
                                        //     return Icon(
                                        //       starIndex < item.rating ? Icons.star : Icons.star_border,
                                        //       color: Colors.blueAccent,
                                        //       size: 20,
                                        //     );
                                        //   }),
                                        // ),
                                        SizedBox(width: 8),
                                        // 거리 정보
                                        Text(
                                          '${item.distance} km',
                                          style: TextStyle(
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
                ),
              ),
            ),
            if (travelViewModel.isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.grey.withOpacity(0.3),
                  child: const Center(
                    child: SpinKitRing(
                      color: orchid,
                      size: 120,
                      lineWidth: 12.0,
                    ), // 로딩 인디케이터
                  ), // 회색 배경
                ),
              ),
          ],
        );
      },
    );
  }
}
