import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/bus/bus_detail_viewmodel.dart';
import 'package:flutter/material.dart';

class BusAllLineView extends StatelessWidget {
  const BusAllLineView({
    super.key,
    required this.busDetailViewModel,
    required this.busType,
  });

  final BusDetailViewModel busDetailViewModel;
  final String? busType;

  @override
  Widget build(BuildContext context) {
    final busLineInfo = busDetailViewModel.busLineModel!;

    return Expanded(
      child: ListView.builder(
        itemCount: busLineInfo.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: index == busLineInfo.length - 1
                ? const EdgeInsets.symmetric(horizontal: 20.0)
                    .copyWith(bottom: 10)
                : const EdgeInsets.symmetric(horizontal: 20.0),
            child: InkWell(
              onTap: () {
                busDetailViewModel.onTapBusStop(
                    context,
                    busLineInfo[index].busStopName!,
                    busLineInfo[index].busStopId!);
              },
              child: Stack(
                children: [
                  // 세로로 된 일직선 추가
                  Positioned(
                    left: 13, // 아이콘 뒤에 선이 오도록 위치 설정
                    top: index == 0 ? 35 : 0.0,
                    bottom: index == busLineInfo.length - 1 ? 35 : 0,
                    child: Container(
                      width: 5, // 선의 너비
                      color: checkBusColor(busType), // 선의 색상
                    ),
                  ),
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // 아이콘들을 중앙에 맞추기 위해 추가
                    children: [
                      busLineInfo[index].returnPoint == '1'
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: paleBlueGray,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.u_turn_right,
                                      size: 16, color: Colors.black), // 회차지 아이콘
                                  SizedBox(width: 4),
                                  Text(
                                    '회차',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : busLineInfo[index].busNumber!.isNotEmpty &&
                                  index != busLineInfo.length - 1
                              ? Container(
                                  width: 30, // 원하는 버스 아이콘 크기
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white, // 내부를 하얗게 설정
                                    border: Border.all(
                                      color:
                                          checkBusColor(busType), // 외부 테두리 색상
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.directions_bus,
                                    color: checkBusColor(busType), // 아이콘 테두리 색상
                                    size: 20, // 버스 아이콘 크기
                                  ),
                                )
                              : SizedBox(
                                  width: 30,
                                  child: Container(
                                    width: 18, // 원하는 화살표 컨테이너 크기 (아이콘 크기와 동일하게)
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white, // 내부를 하얗게 설정
                                      border: Border.all(
                                        color: Colors.grey, // 외부 테두리 색상
                                        width: 2.0,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey, // 아이콘 테두리 색상
                                      size: 15, // 화살표 아이콘 크기 줄임
                                    ),
                                  ),
                                ),
                      Padding(
                        padding: index == 0
                            ? const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0)
                                .copyWith(top: 10)
                            : const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              busLineInfo[index].busStopName!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(busLineInfo[index].busStopNumber!),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Divider는 모든 항목에서 나오게 함 (맨 아래 추가)
                  const Positioned(
                    left: 0, // Divider의 위치
                    right: 0,
                    bottom: 0,
                    child: Divider(
                      height: 1,
                      color: paleBlueGray, // 원하는 색상으로 변경 가능
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
