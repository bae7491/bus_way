import 'package:bus_way/ui/mainpage/mypage/mypage_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bus_way/data/api/api.dart';

class MypageView extends StatelessWidget {
  const MypageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MypageViewmodel>(
      builder: (context, myPageViewModel, child) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(API.busStopImage),
                ElevatedButton(
                  onPressed: () {
                    myPageViewModel.signOut(context);
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
