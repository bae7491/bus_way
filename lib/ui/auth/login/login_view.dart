import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/widget/custom_continue_button.dart';
import 'package:bus_way/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_viewmodel.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        return PopScope(
          canPop: !loginViewModel.isLoading,
          child: Stack(
            children: [
              Scaffold(
                resizeToAvoidBottomInset: false,
                body: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 150),
                          const Text(
                            '이메일',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            hintText: "이메일을 입력하세요",
                            controller: loginViewModel.emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onTapOutside: true,
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            '비밀번호',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            onSubmitted: (value) async {
                              await loginViewModel.login(
                                loginViewModel.emailController.text,
                                loginViewModel.passwordController.text,
                              );
                              if (loginViewModel.errorMessage == null &&
                                  loginViewModel.firebaseUser != null &&
                                  context.mounted) {
                                loginViewModel.loginNavigate(context);
                              }
                            },
                            hintText: "비밀번호를 입력하세요",
                            controller: loginViewModel.passwordController,
                            obscureText: !loginViewModel.passwordVisible,
                            onTapOutside: true,
                            suffixIcon: IconButton(
                              onPressed: () {
                                loginViewModel.togglePasswordVisibility();
                              },
                              icon: Icon(
                                loginViewModel.passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (loginViewModel.errorMessage != null) ...[
                            Text(
                              loginViewModel.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                          Row(
                            children: [
                              Checkbox(
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    loginViewModel.setAutoLogin(value);
                                  }
                                },
                                value: loginViewModel.autoLogin,
                                activeColor: orchid,
                              ),
                              const Text(
                                '자동 로그인',
                                style: TextStyle(fontSize: 15),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  loginViewModel.resetPasswordNavigate(context);
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    '비밀번호를 잊으셨나요?',
                                    style: TextStyle(
                                      fontSize: 17,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          Column(
                            children: [
                              CustomContinueButton(
                                onPressed: () async {
                                  await loginViewModel.login(
                                    loginViewModel.emailController.text,
                                    loginViewModel.passwordController.text,
                                  );
                                  if (loginViewModel.errorMessage == null &&
                                      loginViewModel.firebaseUser != null &&
                                      context.mounted) {
                                    loginViewModel.loginNavigate(context);
                                  }
                                },
                                text: "로그인",
                              ),
                              const SizedBox(height: 30),
                              const Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Divider(thickness: 2),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Text('또는'),
                                  ),
                                  Expanded(
                                    child: Divider(thickness: 2),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              CustomContinueButton(
                                onPressed: () {
                                  loginViewModel.signUpNavigate(context);
                                },
                                text: '회원가입',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (loginViewModel.isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // 회색 배경
                    child: const Center(
                      child: CircularProgressIndicator(), // 로딩 인디케이터
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
