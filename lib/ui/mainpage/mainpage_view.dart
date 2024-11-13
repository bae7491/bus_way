import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/main_map/main_map_view.dart';
import 'package:bus_way/ui/mainpage/main_map/main_map_bus_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mainpage_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mypage/mypage_view.dart';
import 'package:bus_way/ui/mainpage/mypage/mypage_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainPageViewModel>(
      builder: (context, mainPageViewModel, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
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
          body: IndexedStack(
            index: mainPageViewModel.index,
            children: const <Widget>[
              MainMapView(),
              MypageView(),
            ],
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

                if (!mainMapViewModel.isLoading) {
                  mainPageViewModel.updateCurrentPage(index);
                }
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_rounded), label: 'MY'),
              ],
              currentIndex: mainPageViewModel.index,
              fixedColor: orchid,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
            ),
          ),
        );
      },
    );
  }
}
