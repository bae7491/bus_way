import 'dart:io';

import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/travel/travel_write_review/travel_write_review_viewmodel.dart';
import 'package:bus_way/widget/custom_alert_dialog.dart';
import 'package:bus_way/widget/custom_continue_button.dart';
import 'package:bus_way/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class TravelReviewView extends StatelessWidget {
  const TravelReviewView({
    super.key,
    required this.contentId,
    required this.title,
  });

  final String contentId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ChangeNotifierProvider<TravelWriteReviewViewModel>(
        create: (_) => TravelWriteReviewViewModel(),
        child: Consumer<TravelWriteReviewViewModel>(
          builder: (context, travelReviewViewModel, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (travelReviewViewModel.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackbar(
                    content: Text(travelReviewViewModel.errorMessage!),
                  ),
                );
                travelReviewViewModel.clearErrorMessage();
              }
            });

            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) async {
                if (!didPop) {
                  final shouldPop = await showCustomAlertDialog(
                          context, '후기 작성을 취소하시겠습니까?') ??
                      false;

                  travelReviewViewModel.reviewFocusNode.unfocus();

                  if (shouldPop && context.mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                }
              },
              child: Scaffold(
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
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 35.0,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                  child: Text(
                                    "후기 작성",
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
                                const Row(
                                  children: [
                                    Text(
                                      "1. 별점을 남겨주세요.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "(필수)",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.redAccent,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                // 별점
                                Center(
                                  child: RatingBar.builder(
                                    initialRating: travelReviewViewModel.rating,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    tapOnlyMode: true,
                                    itemCount: 5,
                                    itemSize: 30,
                                    minRating: 1,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      travelReviewViewModel
                                          .updateRating(rating);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                const Row(
                                  children: [
                                    Text(
                                      "2. 리뷰를 작성해주세요.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "(필수)",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.redAccent,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  onChanged: (value) {
                                    travelReviewViewModel.updateReviewBtn();
                                  },
                                  decoration: const InputDecoration(
                                    hintText: '이 곳을 눌러 리뷰를 작성',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(color: orchid),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide:
                                          BorderSide(color: orchid, width: 2),
                                    ),
                                  ),
                                  controller:
                                      travelReviewViewModel.reviewController,
                                  focusNode:
                                      travelReviewViewModel.reviewFocusNode,
                                  maxLength: 100,
                                  maxLines: 6,
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                const Text(
                                  "3. 리뷰 이미지를 선택해주세요.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),

                                AspectRatio(
                                  aspectRatio: 1,
                                  child: MaterialButton(
                                    onPressed: () {
                                      travelReviewViewModel
                                          .getReviewImage(ImageSource.gallery);
                                    },
                                    padding: const EdgeInsets.all(0.0),
                                    shape: const RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: orchid,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: travelReviewViewModel.reviewImage !=
                                            null
                                        ? Stack(
                                            children: [
                                              Center(
                                                child: Image.file(
                                                  File(travelReviewViewModel
                                                      .reviewImage!.path),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                top: 0,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.cancel_outlined,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    travelReviewViewModel
                                                        .removeReviewImage();
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        : const Center(
                                            child: Text(
                                              '이 곳을 눌러 이미지 선택',
                                              style: TextStyle(
                                                fontSize: 18, // 텍스트 크기
                                                fontWeight:
                                                    FontWeight.bold, // 텍스트 굵기
                                                color: Colors.grey, // 텍스트 색상
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 22.0),
                        child: CustomContinueButton(
                          onPressed: () {
                            travelReviewViewModel.checkTravelReview(
                                context, contentId, title);
                          },
                          color: travelReviewViewModel.isReviewActiveBtn
                              ? orchid
                              : Colors.grey,
                          text: '후기 등록',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
