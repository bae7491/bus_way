import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/travel/travel_review_detail/travel_review_detail_viewmodel.dart';
import 'package:bus_way/widget/custom_snackbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class TravelReviewDetailView extends StatelessWidget {
  const TravelReviewDetailView({
    super.key,
    required this.reviewId,
  });

  final String reviewId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TravelReviewDetailViewModel>(
      create: (_) =>
          TravelReviewDetailViewModel()..loadTravelReviewdetail(reviewId),
      child: Consumer<TravelReviewDetailViewModel>(
        builder: (context, viewmodel, child) {
          final reviewDetailData = viewmodel.travelReviewDetailList;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (viewmodel.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackbar(
                  content: Text(viewmodel.errorMessage!),
                ),
              );
              viewmodel.clearErrorMessage();
            }
          });

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              centerTitle: true,
              title: const Text(
                'BusWay',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: reviewDetailData == null
                ? const Stack(
                    children: [
                      Positioned.fill(
                        child: Center(
                          child: SpinKitRing(
                            color: orchid,
                            size: 120,
                            lineWidth: 12.0,
                          ), // 로딩 인디케이터
                        ),
                      ),
                    ],
                  ) // 데이터 로딩 중
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35.0,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                  child: Text(
                                    "상세 후기",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                const Text(
                                  "1. 관광지에 대한 별점이예요.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                // 별점
                                Center(
                                  child: RatingBarIndicator(
                                    rating: double.parse(
                                        reviewDetailData.reviewRate!),
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    itemSize: 30,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                const Text(
                                  "2. 관광지에 대한 후기 내용이예요.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.all(15.0), // 내부 여백 설정
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border:
                                        Border.all(color: orchid), // 테두리 색상 설정
                                    borderRadius: BorderRadius.circular(
                                        12.0), // 모서리를 둥글게 설정
                                  ),
                                  child: Text(
                                    reviewDetailData.reviewContent!,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                if (reviewDetailData.reviewImagePath != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "3. 관광지에서 찍은 사진이예요.",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            8), // 이미지에 직접 둥글기 적용
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              reviewDetailData.reviewImagePath!,
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder:
                                              (context, url, progress) =>
                                                  const Center(
                                            child: SpinKitRing(
                                              color: orchid, // 원하는 색상
                                              size: 30.0, // 크기 설정
                                              lineWidth: 5.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
