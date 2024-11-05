import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/travel/travel_detail_viewmodel.dart';
import 'package:bus_way/ui/mainpage/travel/travel_review/travel_review_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Widget travelReviewListView(
    BuildContext context, TravelDetailViewModel viewmodel, String contentId) {
  return Consumer<TravelDetailViewModel>(
    builder: (context, viewmodel, child) {
      final reviewInfo = viewmodel.travelReviewInfo;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                            ],
                          ),
                        ],
                      ),
                      // 후기 작성 버튼
                      ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TravelReviewView(
                                contentId: contentId,
                              ),
                            ),
                          );
                          // 두 번째 화면에서 돌아오면 getTravelReview 호출하여 새로고침
                          await viewmodel.getTravelReview(contentId);
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
                  height: 30,
                  thickness: 5,
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
