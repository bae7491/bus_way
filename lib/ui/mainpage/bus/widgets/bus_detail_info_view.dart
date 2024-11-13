import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/bus/bus_detail_viewmodel.dart';
import 'package:flutter/material.dart';

class BusDetailInfoView extends StatelessWidget {
  const BusDetailInfoView({
    super.key,
    required this.busDetailViewModel,
    required this.busType,
  });

  final BusDetailViewModel busDetailViewModel;
  final String? busType;

  @override
  Widget build(BuildContext context) {
    final busDetailInfo = busDetailViewModel.busInfoModel!;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            busDetailInfo[0].busLineNum!,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: checkBusColor(busType),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                busDetailInfo[0].startPoint!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
              ),
              Image.asset(
                'assets/images/double_arrow.png',
                width: 40,
                height: 21,
              ),
              Text(
                busDetailInfo[0].endPoint!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            '첫차 - ${busDetailInfo[0].firstTime!} | 막차 - ${busDetailInfo[0].endTime!}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            '배차간격 - 출퇴근 ${busDetailInfo[0].headWayPeak!} 분, 평일 ${busDetailInfo[0].headWayNormal!} 분, 주말 ${busDetailInfo[0].headWayHoliday!} 분',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Divider(
                height: 0,
                thickness: 5,
                indent: 12.0,
                endIndent: 12.0,
                color: paleBlueGray),
          ),
        ],
      ),
    );
  }
}
