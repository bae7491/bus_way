import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/travel/travel_detail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Widget travelReviewListView(
    BuildContext context, TravelDetailViewModel viewmodel) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 전체 후기 개수
                        const Text(
                          '전체 (0,000 건)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        // 별점
                        Row(
                          children: [
                            const Text(
                              '3.0',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(width: 10.0),
                            RatingBar.builder(
                              initialRating: 3,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              ignoreGestures: true,
                              itemCount: 5,
                              itemSize: 25,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // TODO: 후기 작성 버튼 작성
                ElevatedButton(
                  onPressed: () {
                    // print('rating: $rating')
                    viewmodel.writeReviewNavigate(context);
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
}
