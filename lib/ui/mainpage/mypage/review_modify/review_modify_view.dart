import 'dart:io';

import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/mypage/review_modify/review_modify_viewmodel.dart';
import 'package:bus_way/widget/custom_alert_dialog.dart';
import 'package:bus_way/widget/custom_continue_button.dart';
import 'package:bus_way/widget/custom_snackbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ReviewModifyView extends StatelessWidget {
  const ReviewModifyView({
    super.key,
    required this.reviewId,
    required this.contentId,
    required this.title,
  });

  final String reviewId;
  final String contentId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ChangeNotifierProvider<ReviewModifyViewModel>(
        create: (_) => ReviewModifyViewModel(reviewId),
        child: Consumer<ReviewModifyViewModel>(
          builder: (context, reviewModifyViewModel, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (reviewModifyViewModel.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackbar(
                    content: Text(reviewModifyViewModel.errorMessage!),
                  ),
                );
                reviewModifyViewModel.clearErrorMessage();
              }
            });

            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) async {
                if (!didPop) {
                  final shouldPop = await showCustomAlertDialog(
                          context, '후기 수정을 취소하시겠습니까?') ??
                      false;

                  reviewModifyViewModel.reviewFocusNode.unfocus();

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
                    '후기 수정',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                body: reviewModifyViewModel.isLoading
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
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Text(
                                            "1. 별점을 수정해주세요.",
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
                                          initialRating:
                                              reviewModifyViewModel.rating,
                                          direction: Axis.horizontal,
                                          allowHalfRating: false,
                                          tapOnlyMode: true,
                                          itemCount: 5,
                                          itemSize: 30,
                                          minRating: 1,
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            reviewModifyViewModel
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
                                            "2. 리뷰를 수정해주세요.",
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
                                          reviewModifyViewModel
                                              .updateReviewBtn();
                                        },
                                        decoration: const InputDecoration(
                                          hintText: '이 곳을 눌러 리뷰를 작성',
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 18),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0)),
                                            borderSide:
                                                BorderSide(color: orchid),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0)),
                                            borderSide: BorderSide(
                                                color: orchid, width: 2),
                                          ),
                                        ),
                                        controller: reviewModifyViewModel
                                            .reviewController,
                                        focusNode: reviewModifyViewModel
                                            .reviewFocusNode,
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
                                            reviewModifyViewModel
                                                .getReviewImage(
                                                    ImageSource.gallery);
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
                                          child: reviewModifyViewModel
                                                      .reviewImage !=
                                                  null
                                              ? Stack(
                                                  children: [
                                                    Center(
                                                      child: reviewModifyViewModel
                                                              .reviewImage!.path
                                                              .startsWith(
                                                                  'http')
                                                          ? CachedNetworkImage(
                                                              imageUrl:
                                                                  reviewModifyViewModel
                                                                      .reviewImage!
                                                                      .path,
                                                              progressIndicatorBuilder:
                                                                  (context, url,
                                                                          progress) =>
                                                                      const Center(
                                                                child:
                                                                    SpinKitRing(
                                                                  color:
                                                                      orchid, // 원하는 색상
                                                                  size:
                                                                      30.0, // 크기 설정
                                                                  lineWidth:
                                                                      5.0,
                                                                ),
                                                              ),
                                                            )
                                                          : Image.file(
                                                              File(reviewModifyViewModel
                                                                  .reviewImage!
                                                                  .path),
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
                                                          reviewModifyViewModel
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
                                                      fontWeight: FontWeight
                                                          .bold, // 텍스트 굵기
                                                      color:
                                                          Colors.grey, // 텍스트 색상
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 22.0),
                              child: CustomContinueButton(
                                onPressed: () {
                                  reviewModifyViewModel.checkModifyReivew(
                                      context, reviewId, contentId, title);
                                },
                                color: reviewModifyViewModel.isReviewActiveBtn
                                    ? orchid
                                    : Colors.grey,
                                text: '후기 수정',
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
