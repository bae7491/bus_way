// 마커를 클릭하면 모달 창이 보이는 함수
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main_map_viewmodel.dart';
import 'tabs/info_tabbar.dart';

void showCustomModalBottomSheet(BuildContext context, String busStopId) {
  final mainMapViewModel =
      Provider.of<MainMapViewmodel>(context, listen: false);

  mainMapViewModel.showBottomSheet();

  final selectedMarkerId = mainMapViewModel.selectedMarkerId;

  // tabBar의 높이와 전체 화면의 높이를 계산하는 변수들
  const double tabBarHeight = 70.0; // TabBar의 높이 설정
  final double maxHeight = MediaQuery.of(context).size.height * 0.7; // 화면의 80%

  showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    isScrollControlled: true,
    // showDragHandle: true,
    barrierColor: Colors.transparent,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    builder: (context) {
      return Consumer<MainMapViewmodel>(
        builder: (context, mainMapViewModel, child) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.7,
            builder: (context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: InfoTabbar(
                  scrollController: scrollController,
                  maxHeight: maxHeight,
                  tabBarHeight: tabBarHeight,
                  viewmodel: mainMapViewModel,
                  busStopId: busStopId,
                ),
              );
            },
          );
        },
      );
    },
  ).then(
    (_) {
      mainMapViewModel.hideBottomSheet();
      mainMapViewModel.decreaseSelectedMarker(selectedMarkerId!);
    },
  );
}
