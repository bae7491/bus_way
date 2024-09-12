/*
  view - 사용자에게 보여지는 화면.

  login_view : 로그인 화면.

  - 역할
    email, password를 입력받고, login_viewmodel.dart에 요청을 보내고, 상태에 따라 UI를 갱신.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_viewmodel.dart';
import '../../mainpage/mainpage_view.dart';
import '../signup/signup_view.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (loginViewModel.isLoading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await loginViewModel.login(
                        _emailController.text,
                        _passwordController.text,
                      );

                      if (loginViewModel.errorMessage == null && loginViewModel.user != null) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const MainView()),
                          (route) => false,
                        );
                      }
                    },
                    child: const Text("로그인"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpView()),
                      );
                    }, 
                    child: const Text("회원가입"),
                    ),
                ],
              ),
            if (loginViewModel.errorMessage != null)
              Text(loginViewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
