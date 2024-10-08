import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/main_map/main_map_view.dart';
import 'package:bus_way/ui/mainpage/mainpage_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mypage/mypage_view.dart';
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
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'MY'),
            ],
            onTap: (int index) {
              mainPageViewModel.updateCurrentPage(index);
            },
            currentIndex: mainPageViewModel.index,
            fixedColor: orchid,
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }
}
