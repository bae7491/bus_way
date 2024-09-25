import 'package:bus_way/ui/auth/auth_check.dart';
import 'package:bus_way/ui/mainpage/mainpage_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/auth/login/login_viewmodel.dart';
import 'ui/auth/signup/signup_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 로그인
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
        ),
        // 회원가입
        ChangeNotifierProvider(
          create: (_) => SignUpViewModel(),
        ),
        // 메인페이지
        ChangeNotifierProvider(
          create: (_) => MainPageViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthCheck(), // AuthCheck 위젯을 따로 분리
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
      ),
    );
  }
}
