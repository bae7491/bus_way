import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/main_map/main_map_bus_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mainpage_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mypage/mypage_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mypage/review_list/review_list_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mypage/review_list/review_paged_list_view.dart';
import 'package:bus_way/ui/mainpage/mypage/review_list/widgets/review_list_sort_option_view.dart';
import 'package:bus_way/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReviewListView extends StatelessWidget {
  const ReviewListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final myPageViewModel =
        Provider.of<MypageViewModel>(context, listen: false);

    return ChangeNotifierProvider<ReviewListViewModel>(
      create: (_) => ReviewListViewModel(),
      child: Consumer2<ReviewListViewModel, MainPageViewModel>(
        builder: (context, reviewListViewModel, mainPageViewModel, child) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (reviewListViewModel.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackbar(
                    content: Text(reviewListViewModel.errorMessage!),
                  ),
                );
                reviewListViewModel.clearErrorMessage();
              }
            },
          );

          return PopScope(
            onPopInvokedWithResult: (didPop, result) {
              myPageViewModel.loadUserInfo();
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                centerTitle: true,
                title: const Text(
                  '후기 목록',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: reviewListViewModel.isLoading
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
                  : RefreshIndicator(
                      onRefresh: () => Future.sync(() {
                        reviewListViewModel.reviewPageController.refresh();
                      }),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0,
                                      vertical: 8.0,
                                    ),
                                    child: // 전체 후기 개수
                                        Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '총 ${NumberFormat('###,###,###,###').format(
                                            int.parse(reviewListViewModel
                                                .reviewTotalCount!),
                                          )} 개',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        if (int.parse(reviewListViewModel
                                                .reviewTotalCount!) >
                                            0)
                                          ReviewListSortOptinView(
                                            viewmodel: reviewListViewModel,
                                          ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    indent: 20,
                                    endIndent: 20,
                                    thickness: 5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          reviewPagedListView(reviewListViewModel),
                        ],
                      ),
                    ),
              bottomNavigationBar: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  onTap: (int index) {
                    final mainMapViewModel =
                        Provider.of<MainMapViewModel>(context, listen: false);
                    final myPageViewModel =
                        Provider.of<MypageViewModel>(context, listen: false);

                    if (index == 1) {
                      // MypageView 탭이 선택되면 새로고침
                      myPageViewModel.loadUserInfo();
                    }

                    if (index == 1 && mainMapViewModel.isBottomSheetVisible) {
                      Navigator.of(context).pop(); // 바텀 시트 닫기
                      mainMapViewModel.hideBottomSheet(); // 상태 업데이트
                    }

                    if (!mainMapViewModel.isLoading) {
                      mainPageViewModel.updateCurrentPage(index);
                      Navigator.of(context).pop(); // 네비게이션 바에서 선택 시 이전 화면으로 이동
                    }
                  },
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person), label: 'MY'),
                  ],
                  currentIndex: mainPageViewModel.index,
                  fixedColor: orchid,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
