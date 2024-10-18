import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/bus/bus_detail_view.dart';
import 'package:bus_way/widget/navigator_animation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../main_map_viewmodel.dart';

class BusTab extends StatelessWidget {
  const BusTab({
    super.key,
    required this.viewmodel,
    required this.busStopId,
    required this.scrollController,
  });

  final MainMapViewmodel viewmodel;
  final String busStopId;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final busStopInfoModel = viewmodel.busStopInfoModel;
    return Column(
      children: [
        // 정류장 이름과 새로고침 버튼을 중앙 정렬
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 빈 공간을 사용해 정류장 이름을 중앙으로
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 24, // 새로고침 버튼의 크기만큼 맞춤
                  child: Container(), // 빈 공간
                ),
              ),
              // 정류장 이름을 중앙에 배치
              Text(
                busStopInfoModel![0].nodenm!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // 새로고침 버튼을 오른쪽에 배치
              IconButton(
                onPressed: () {
                  // 버스 새로고침
                  viewmodel.refreshBusStopInfo(busStopId);
                },
                icon: viewmodel.isRefreshLoading
                    ? Lottie.asset(
                        'assets/lottie/refresh_icon.json',
                        width: 24,
                        height: 24,
                      )
                    : const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        const Divider(
            height: 0,
            thickness: 5,
            indent: 12.0,
            endIndent: 12.0,
            color: paleBlueGray),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            itemCount: busStopInfoModel.length, // 예시 데이터
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    NavigatorAnimation(
                            destination: BusDetailView(
                                busStopInfoModel: busStopInfoModel[index]))
                        .createRoute(SlideDirection.bottomToTop),
                  );
                },
                child: Padding(
                  padding: index == 0
                      ? const EdgeInsets.symmetric(horizontal: 20.0)
                          .copyWith(top: 10)
                      : const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        busStopInfoModel[index].lineno!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              checkBusColor(busStopInfoModel[index].bustype!),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          busStopInfoModel[index].min1!.isNotEmpty &&
                                  busStopInfoModel[index].station1!.isNotEmpty
                              ? Text(
                                  '${busStopInfoModel[index].min1!} 분 | ${busStopInfoModel[index].station1!} 정류장 전',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              : const Text('정보 없음',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                          busStopInfoModel[index].min2!.isNotEmpty &&
                                  busStopInfoModel[index].station2!.isNotEmpty
                              ? Text(
                                  '${busStopInfoModel[index].min2!} 분 | ${busStopInfoModel[index].station2!} 정류장 전',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              : const Text('정보 없음',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(height: 20, color: paleBlueGray),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
