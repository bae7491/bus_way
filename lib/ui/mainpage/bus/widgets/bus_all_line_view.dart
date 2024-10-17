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
              onTap: () {},
              child: Stack(
                children: [
                  // 세로로 된 일직선 추가
                  Positioned(
                    left: 10, // 아이콘 뒤에 선이 오도록 위치 설정
                    top: index == 0 ? 35 : 0.0,
                    bottom: index == busLineInfo.length - 1 ? 35 : 0,
                    child: Container(
                      width: 5, // 선의 너비
                      color: checkBusColor(busType), // 선의 색상
                    ),
                  ),
                  Row(
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
                                  Icon(Icons.restart_alt,
                                      size: 16, color: Colors.black), // 회차지 아이콘
                                  SizedBox(width: 4),
                                  Text(
                                    '회차지',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : busLineInfo[index].busNumber!.isNotEmpty &&
                                  index != busLineInfo.length - 1
                              ? Container(
                                  width: 24, // 원하는 아이콘의 크기
                                  height: 24,
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
                                    size: 18, // 아이콘 크기
                                  ),
                                )
                              : Container(
                                  width: 24, // 원하는 아이콘의 크기
                                  height: 24,
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
                                    Icons.keyboard_arrow_down,
                                    color: checkBusColor(busType), // 아이콘 테두리 색상
                                    size: 20, // 아이콘 크기
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
