import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: 
                // e-mail
                TextFormField(
                  controller: _emailController,
                  obscureText: false,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'E-mail을 입력하세요. ex) aaa@aaa.com',
                    hintStyle: TextStyle(fontSize: 15),
                  ),
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.emailAddress,
                ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 100),
              child:
                // pw
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.visibility_off_outlined),
                    labelText: 'password',
                    hintText: '비밀번호를 입력하세요.',
                  ),
                  keyboardType: TextInputType.text,
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 메인 화면으로 이동
                  },
                  child: const Text("로그인"),
                ),
                const SizedBox(width: 50),
                ElevatedButton(
                  onPressed: () {
                    // 회원가입 화면으로 이동
                  },
                  child: const Text("회원가입"),
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}
