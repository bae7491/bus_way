import 'package:bus_way/data/model/travel_model/travel_review_info_model.dart';
import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/travel/travel_detail_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

class ReviewPagedListView extends StatelessWidget {
  const ReviewPagedListView({
    super.key,
    required this.viewmodel,
  });

  final TravelDetailViewModel viewmodel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PagedListView<int, TravelReviewInfoModel>(
        pagingController: viewmodel.reviewPageController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) => Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // 클릭 시, 리뷰 상세 뷰로 이동.
                    viewmodel.navigateReviewDetailView(context, item.reviewId!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.nickName!,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RatingBarIndicator(
                                rating: double.parse(item.reviewRate!),
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 25,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star_rate,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (item.reviewImage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Container(
                              padding: const EdgeInsets.all(8.0), // 내부 여백 설정
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(8), // 이미지에 직접 둥글기 적용
                                child: CachedNetworkImage(
                                  imageUrl: item.reviewImage!,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, url, progress) => const Center(
                                    child: SpinKitRing(
                                      color: orchid, // 원하는 색상
                                      size: 30.0, // 크기 설정
                                      lineWidth: 5.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            padding: const EdgeInsets.all(15.0), // 내부 여백 설정
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey), // 테두리 색상 및 굵기 설정
                              borderRadius:
                                  BorderRadius.circular(8.0), // 모서리 둥글게 설정
                              color: Colors.transparent, // 배경색 설정
                            ),
                            width: double.infinity,
                            child: Text(
                              item.reviewContent!,
                              style: const TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            DateFormat("yyyy.MM.dd").format(
                              DateTime.parse(item.reviewModifiedDate!),
                            ),
                            style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(),
            ],
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
                  '관광지의 후기 글이 없습니다!',
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
