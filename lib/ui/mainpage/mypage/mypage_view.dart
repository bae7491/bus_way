import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/mypage/mypage_viewmodel.dart';
import 'package:bus_way/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MypageView extends StatelessWidget {
  const MypageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MypageViewModel>(
      builder: (context, myPageViewModel, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (myPageViewModel.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackbar(
                content: Text(myPageViewModel.errorMessage!),
              ),
            );
            myPageViewModel.clearErrorMessage();
          }
        });

        final userInfo = myPageViewModel.userInfo;
        final followReviewSummary = myPageViewModel.followReviewSummary;

        return Scaffold(
          body: (userInfo == null && followReviewSummary == null)
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
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Center(
                        child: Text(
                          "회원 정보",
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
                      Text(
                        '환영합니다, ${userInfo!.nickName!} 님!',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        userInfo.email!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      const Divider(
                        height: 30,
                        thickness: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          // color: Colors.grey[300], // 배경색
                          color: orchid,
                          borderRadius:
                              BorderRadius.circular(10.0), // 모서리 둥글게 설정
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // 팔로우 섹션
                              Expanded(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      // 팔로우 클릭 시의 동작
                                      myPageViewModel.navigateFollowList(
                                          context,
                                          followReviewSummary!
                                              .followTotalCount!);
                                    },
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                    ), // 모서리 둥글게 설정
                                    child: Container(
                                      color: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            NumberFormat('###,###,###,###')
                                                .format(
                                              int.parse(myPageViewModel
                                                  .followReviewSummary!
                                                  .followTotalCount!),
                                            ),
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          const Text(
                                            '팔로우',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // 구분선
                              Container(
                                width: 3,
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                              ),
                              // 후기 섹션
                              Expanded(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      // 후기 클릭 시의 동작
                                      myPageViewModel
                                          .navigateReviewList(context);
                                    },
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                    ), // 모서리 둥글게 설정
                                    child: Container(
                                      color: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            NumberFormat('###,###,###,###')
                                                .format(
                                              int.parse(myPageViewModel
                                                  .followReviewSummary!
                                                  .reviewTotalCount!),
                                            ),
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          const Text(
                                            '후기',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 5,
                      ),
                      Expanded(
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            ListTile(
                              onTap: () {
                                // 내정보 수정 페이지 이동
                                myPageViewModel.navigateUserModify(context);
                              },
                              title: const Text(
                                '내정보 수정',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            ListTile(
                              onTap: () {
                                myPageViewModel.checkWithDraw(
                                    context, myPageViewModel);
                              },
                              title: const Text(
                                '계정 탈퇴',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            ListTile(
                              onTap: () {
                                myPageViewModel.checkSignOut(context);
                              },
                              title: const Text(
                                '로그아웃',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
