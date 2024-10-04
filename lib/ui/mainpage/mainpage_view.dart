import 'package:bus_way/ui/auth/login/login_view.dart';
import 'package:bus_way/ui/auth/login/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mainpage/mainpage_viewmodel.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final mainPageViewModel = Provider.of<MainPageViewModel>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                mainPageViewModel.signOut();
                if (context.mounted) {
                  // 로그인 화면으로 이동 및 모든 페이지 제거
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                    (route) => false, // 스택에 남아 있는 모든 화면을 제거
                  );
                  final loginViewModel =
                      Provider.of<LoginViewModel>(context, listen: false);
                  loginViewModel.autoLoginOff();
                  loginViewModel.emailController.clear();
                  loginViewModel.passwordController.clear();
                }
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
