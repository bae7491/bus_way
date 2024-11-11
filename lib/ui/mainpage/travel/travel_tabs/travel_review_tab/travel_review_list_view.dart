import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/travel/travel_detail_viewmodel.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_review_tab/widgets/review_list_sort_option_view.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_review_tab/widgets/review_paged_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

Widget travelReviewListView(BuildContext context,
    TravelDetailViewModel viewmodel, String title, String contentId) {
  final reviewInfo = viewmodel.travelReviewInfo;
  return RefreshIndicator(
    onRefresh: () => Future.sync(
      () => viewmodel.reviewPageController.refresh(),
    ),
    backgroundColor: Colors.white,
    color: orchid,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  if (reviewInfo != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 전체 후기 개수
                            Text(
                              '전체 (${NumberFormat('###,###,###,###').format(
                                int.parse(reviewInfo.reviewCount!),
                              )} 건)',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            // 별점
                            Row(
                              children: [
                                Text(
                                  reviewInfo.reviewAverageRate!,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(width: 10.0),
                                RatingBarIndicator(
                                  rating: double.parse(
                                      reviewInfo.reviewAverageRate!),
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemSize: 30,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star_rate,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                            if (int.parse(reviewInfo.reviewCount!) > 0)
                              ReviewListSortOptinView(
                                viewmodel: viewmodel,
                              ),
                          ],
                        ),
                        // 후기 작성 버튼
                        ElevatedButton(
                          onPressed: () async {
                            await viewmodel.writeReviewNavigate(
                                context, contentId, title);
                            await viewmodel.getTravelReviewSummary(contentId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: orchid,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "후기 작성",
                          ),
                        ),
                      ],
                    ),
                  const Divider(
                    thickness: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
        // 스크롤 가능한 리스트 뷰를 Expanded로 감싸 높이 제한
        ReviewPagedListView(
          viewmodel: viewmodel,
        ),
      ],
    ),
  );
}
