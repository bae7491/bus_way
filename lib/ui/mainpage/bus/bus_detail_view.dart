import 'package:bus_way/data/model/bus_model/bus_stop_info_model.dart';
import 'package:flutter/material.dart';

class BusDetailView extends StatelessWidget {
  const BusDetailView({super.key, required this.busStopInfo});

  final BusStopInfoModel busStopInfo;

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [Text(busStopInfo.lineno!), Text(busStopInfo.lineid!)],
        ),
      ),
    );
  }
}
