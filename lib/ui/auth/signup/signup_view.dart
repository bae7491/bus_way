/*
  view - 사용자에게 보여지는 화면.

  signup_view : 회원가입 화면.

  - 역할
    email, password, 를 입력받고, login_viewmodel.dart에 요청을 보내고, 상태에 따라 UI를 갱신.
*/

import 'package:bus_way/ui/auth/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../signup/signup_viewmodel.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final signUpViewModel = Provider.of<SignUpViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '회원가입',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText:"Email"),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText:"Password"),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              if (signUpViewModel.isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () {
                    signUpViewModel.signUp(
                      _emailController.text,
                      _passwordController.text,
                    );
                  },
                  child: const Text("회원가입"),
                ),
              if (signUpViewModel.errorMessage != null)
                Text(signUpViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
