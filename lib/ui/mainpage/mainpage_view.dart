import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/auth/login/login_view.dart';
import 'package:bus_way/ui/auth/login/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';
import '../mainpage/mainpage_viewmodel.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final mainPageViewModel = Provider.of<MainPageViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: Stack(
        children: [
          // 카카오 맵을 표시하는 부분
          KakaoMap(
            onMapCreated: mainPageViewModel.onMapCreated, // 맵 생성 시 콜백
            center: mainPageViewModel.center, // Provider에서 관리하는 중앙 좌표
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // 로그아웃 로직 추가
                mainPageViewModel.signOut();

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginView(),
                    ),
                    (route) => false);
                final loginViewModel =
                    Provider.of<LoginViewModel>(context, listen: false);
                loginViewModel.autoLoginOff();
                loginViewModel.emailController.clear();
                loginViewModel.passwordController.clear();
              },
              child: const Text('로그아웃'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'MY'),
        ],
        fixedColor: orchid,
        backgroundColor: Colors.white,
      ),
    );
  }
}
