import 'package:bus_way/data/model/bus_model/bus_stop_info_model.dart';
import 'package:flutter/material.dart';

class BusDetailView extends StatelessWidget {
  const BusDetailView({super.key, required this.busStopInfo});

  final BusStopInfoModel busStopInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [Text(busStopInfo.lineno!), Text(busStopInfo.lineid!)],
        ),
      ),
    );
  }
}
