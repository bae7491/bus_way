import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/main_map/main_map_bus_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mainpage_viewmodel.dart';
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
  });

  final String contentId;
  final String contentTypeId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TravelDetailViewModel>(
      create: (_) =>
          TravelDetailViewModel()..loadTravelInfo(contentId, contentTypeId),
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
              // TODO: 앱바의 오른쪽 상단에 팔로우 하트 아이콘 및 기능 추가 예정.
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
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 관광지 이름
                        if (travelCommonInfo != null)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              travelCommonInfo.travelTitle!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 14,
                        ),
                        // 관광지 대표 이미지
                        if (travelCommonInfo!.travelImage != null)
                          Container(
                            width: 250,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade300, // 이미지가 없을 때 배경
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: CachedNetworkImage(
                                imageUrl: travelCommonInfo.travelImage!,
                                fit: BoxFit.contain,
                                progressIndicatorBuilder:
                                    (context, url, progress) => const Center(
                                  child: SpinKitRing(
                                    color: orchid,
                                    size: 30.0, // 로딩 인디케이터 크기 설정
                                    lineWidth: 5.0,
                                  ),
                                ),
                              )),
                            ),
                          ),
                        const SizedBox(height: 14),
                        TravelDetailTab(
                          viewmodel: travelDetailViewmodel,
                          contentId: contentId,
                          contentTypeId: contentTypeId,
                          detailData: detailData,
                          travelCommonInfo: travelCommonInfo,
                        ),
                      ],
                    ),
                  ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (int index) {
                final mainMapViewModel =
                    Provider.of<MainMapViewModel>(context, listen: false);

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
