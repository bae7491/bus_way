import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/main_map/main_map_bus_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mainpage_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mypage/mypage_viewmodel.dart';
import 'package:bus_way/ui/mainpage/travel/travel_detail_viewmodel.dart';
import 'package:bus_way/ui/mainpage/travel/travel_tabs/travel_detail_tab.dart';
import 'package:bus_way/widget/custom_snackbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class TravelDetailView extends StatelessWidget {
  const TravelDetailView({
    super.key,
    required this.contentId,
    required this.contentTypeId,
    required this.title,
    required this.travelImage,
  });

  final String contentId;
  final String contentTypeId;
  final String title;
  final String travelImage;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TravelDetailViewModel>(
      create: (_) => TravelDetailViewModel()
        ..loadTravelInfo(contentId, contentTypeId, title),
      child: Consumer2<TravelDetailViewModel, MainPageViewModel>(
        builder: (context, travelDetailViewmodel, mainPageViewModel, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (travelDetailViewmodel.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackbar(
                  content: Text(travelDetailViewmodel.errorMessage!),
                ),
              );
              travelDetailViewmodel.clearErrorMessage();
            }
          });

          final travelCommonInfo = travelDetailViewmodel.travelCommonInfoList;
          final detailData = travelDetailViewmodel.travelDetailInfoList;
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
              // 앱바 오른쪽에 위치하는 팔로우 버튼
              actions: [
                if (detailData != null)
                  IconButton(
                    onPressed: () {
                      travelDetailViewmodel.toggleTravelFollow(
                          contentId, contentTypeId, title, travelImage);
                    },
                    enableFeedback: travelDetailViewmodel.isFollowProcessing,
                    icon: travelDetailViewmodel.isTravelFollow
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                          )
                        : const Icon(
                            Icons.favorite_border_outlined,
                          ),
                  ),
              ],
            ),
            body: detailData == null
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
                : Column(
                    children: [
                      // 관광지 이름
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: Text(
                          travelCommonInfo!.travelTitle!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: NestedScrollView(
                          headerSliverBuilder: (context, innerBoxIsScrolled) {
                            return [
                              SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    // 관광지 대표 이미지
                                    if (travelCommonInfo.travelImage != null)
                                      Container(
                                        width: 250,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.grey.shade300,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                imageUrl: travelCommonInfo
                                                    .travelImage!,
                                                fit: BoxFit.contain,
                                                progressIndicatorBuilder:
                                                    (context, url, progress) =>
                                                        const Center(
                                                  child: SpinKitRing(
                                                    color: orchid,
                                                    size: 30.0,
                                                    lineWidth: 5.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 14),
                                  ],
                                ),
                              ),
                            ];
                          },
                          body: TravelDetailTab(
                            viewmodel: travelDetailViewmodel,
                            contentId: contentId,
                            contentTypeId: contentTypeId,
                            detailData: detailData,
                            travelCommonInfo: travelCommonInfo,
                          ),
                        ),
                      ),
                    ],
                  ),
            bottomNavigationBar: BottomNavigationBar(
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
                  mainMapViewModel.hideBottomSheet(); // 상태 업데이트
                  Navigator.of(context).pop(); // 바텀 시트 닫기
                }

                if (!mainMapViewModel.isLoading) {
                  mainPageViewModel.updateCurrentPage(index);
                  Navigator.of(context).pop(); // 네비게이션 바에서 선택 시 이전 화면으로 이동
                }
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'MY'),
              ],
              currentIndex: mainPageViewModel.index,
              fixedColor: orchid,
              backgroundColor: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
