import 'package:bus_way/ui/auth/reset_password/reset_password_view.dart';
import 'package:bus_way/widget/custom_continue_button.dart';
import 'package:bus_way/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_viewmodel.dart';
import '../../mainpage/mainpage_view.dart';
import '../signup/signup_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel> (
        builder: (context, loginViewModel, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: SafeArea(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 175),
                        const Text(
                          '이메일',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: loginViewModel.emailController,
                          hintText: "이메일을 입력하세요",
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          '비밀번호',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: loginViewModel.passwordController,
                          hintText: "비밀번호를 입력하세요",
                          obscureText: !loginViewModel.passwordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              loginViewModel.passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              loginViewModel.togglePasswordVisibility();
                            },
                          ),
                          onSubmitted: (value) async {
                            await loginViewModel.login(
                              loginViewModel.emailController.text,
                              loginViewModel.passwordController.text,
                            );
                            if (loginViewModel.errorMessage == null &&
                                loginViewModel.user != null &&
                                context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainView()),
                                (route) => false,
                              );
                            }
                          },
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
                              value: loginViewModel.autoLogin,
                              // TODO: 체크박스 내부 색상 변경해야함.
                              activeColor: Colors.grey,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  loginViewModel.setAutoLogin(value);
                                }
                              },
                            ),
                            const Text(
                              '자동 로그인',
                              style: TextStyle(fontSize: 15),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ResetPasswordView(),
                                  ),
                                );
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
                                child: const Text('비밀번호를 잊으셨나요?',
                                    style: TextStyle(
                                      fontSize: 17,
                                      letterSpacing: -1,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        if (loginViewModel.isLoading) ...[
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [CircularProgressIndicator()],
                          )
                        ] else ...[
                          Column(
                            children: [
                              CustomContinueButton(
                                text: "로그인",
                                onPressed: () async {
                                  await loginViewModel.login(
                                    loginViewModel.emailController.text,
                                    loginViewModel.passwordController.text,
                                  );
                                  if (loginViewModel.errorMessage == null &&
                                      loginViewModel.user != null &&
                                      context.mounted) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MainView()),
                                      (route) => false,
                                    );
                                  }
                                },
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
                                text: '회원가입',
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUpView(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),   
          );
        },
      ),
    );
  }
}
