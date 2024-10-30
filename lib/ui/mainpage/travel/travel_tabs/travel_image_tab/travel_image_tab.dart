import 'package:bus_way/data/model/travel_model/travel_image_info_model.dart';
import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/travel/travel_detail_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

class TravelImageTab extends StatelessWidget {
  const TravelImageTab({
    super.key,
    required this.viewmodel,
    required this.contentId,
  });

  final TravelDetailViewModel viewmodel;
  final String contentId;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => viewmodel.imagePageController.refresh(),
      ),
      child: PagedListView<int, TravelImageInfoModel>(
        pagingController: viewmodel.imagePageController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    child: Text(
                      '전체 (${NumberFormat('###,###,###,###').format(
                        int.parse(viewmodel.travelImageTotalCount!),
                      )} 건)',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                // 이미지 상단 큰 이미지
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8), // 이미지에 직접 둥글기 적용
                    child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: item.imageUrl!,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, progress) => const Center(
                              child: SpinKitRing(
                                color: orchid, // 원하는 색상
                                size: 30.0, // 크기 설정
                                lineWidth: 5.0,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade300,
                            child:
                                const Icon(Icons.image_not_supported_outlined),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
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
                  '여행지의 이미지가 없습니다!',
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
}
