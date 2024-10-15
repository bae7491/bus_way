import 'package:flutter/material.dart';

class TravelTab extends StatelessWidget {
  const TravelTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // 예시 데이터
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.place),
          title: Text('관광지 $index'),
          subtitle: Text('관광지 설명 $index'),
        );
      },
    );
  }
}
