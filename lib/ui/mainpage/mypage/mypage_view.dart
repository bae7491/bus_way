import 'package:bus_way/ui/mainpage/mypage/mypage_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
