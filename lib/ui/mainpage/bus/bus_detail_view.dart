import 'package:bus_way/data/model/bus_model/bus_arrive_info_model.dart';
import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/bus/bus_detail_viewmodel.dart';
import 'package:bus_way/ui/mainpage/bus/widgets/bus_all_line_view.dart';
import 'package:bus_way/ui/mainpage/bus/widgets/bus_detail_info_view.dart';
import 'package:bus_way/ui/mainpage/main_map/main_map_bus_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mainpage_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mypage/mypage_viewmodel.dart';
import 'package:bus_way/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class BusDetailView extends StatelessWidget {
  const BusDetailView({
    super.key,
    required this.busStopInfoModel,
  });

  final BusArriveInfoModel busStopInfoModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BusDetailViewModel>(
      create: (_) =>
          BusDetailViewModel()..loadBusInfo(busStopInfoModel.lineid!),
      child: Consumer2<BusDetailViewModel, MainPageViewModel>(
        builder: (context, busDetailViewModel, mainPageViewModel, child) {
          final busDetailInfo = busDetailViewModel.busInfoModel;
          final busLineInfo = busDetailViewModel.busLineModel;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (busDetailViewModel.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackbar(content: Text(busDetailViewModel.errorMessage!)),
              );
              busDetailViewModel.clearErrorMessage();
            }
          });

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    // 버스 새로고침
                    busDetailViewModel.refreshBusInfo(busStopInfoModel.lineid!);
                  },
                  icon: busDetailViewModel.isRefreshLoading
                      ? Lottie.asset(
                          'assets/lottie/refresh_icon.json',
                          width: 24,
                          height: 24,
                        )
                      : const Icon(
                          Icons.refresh,
                          size: 24,
                        ),
                ),
              ],
              title: const Text(
                'BusWay',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: <Widget>[
                          if (busDetailInfo != null && busDetailInfo.isNotEmpty)
                            // 버스 상세 정보
                            BusDetailInfoView(
                              busDetailViewModel: busDetailViewModel,
                              busType: busStopInfoModel.bustype,
                            ),
                          if (busLineInfo != null && busLineInfo.isNotEmpty)
                            // 버스 전체 노선 정보
                            BusAllLineView(
                              busDetailViewModel: busDetailViewModel,
                              busType: busStopInfoModel.bustype,
                            ),
                        ],
                      ),
                    ),
                  ),
                  // 기능 동작 중일 때, 로딩 애니메이션 보이기
                  if (busDetailViewModel.isLoading)
                    const Positioned.fill(
                      child: Center(
                        child: SpinKitRing(
                          color: orchid,
                          size: 120,
                          lineWidth: 12.0,
                        ), // 로딩 인디케이터
                      ),
                    ),
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
          );
        },
      ),
    );
  }
}
