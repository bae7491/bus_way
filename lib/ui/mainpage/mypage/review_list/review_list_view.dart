import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/main_map/main_map_bus_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mainpage_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mypage/mypage_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mypage/review_list/review_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewListView extends StatelessWidget {
  const ReviewListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReviewListViewModel>(
      create: (_) => ReviewListViewModel(),
      child: Consumer2<ReviewListViewModel, MainPageViewModel>(
        builder: (context, reviewListViewModel, mainPageViewModel, child) {
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
