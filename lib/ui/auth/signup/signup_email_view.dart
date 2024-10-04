/*
  view - 사용자에게 보여지는 화면.

  signup_email_view : 회원가입 (이메일) 화면.

  - 역할
    email 값을 입력받고, signup_viewmodel.dart에 요청을 보내고, 상태에 따라 UI를 갱신.
*/

import 'package:bus_way/widget/custom_continue_button.dart';
import 'package:bus_way/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../signup/signup_viewmodel.dart';
import 'package:bus_way/theme/colors.dart';

class SignUpEmailView extends StatelessWidget {
  const SignUpEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer<SignUpViewModel>(
        builder: (context, signUpViewModel, child) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
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
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 50),
                            const Text(
                              '이메일을 입력해주세요',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              onSubmitted: (value) {
                                signUpViewModel.handleValidateEmail(
                                  context,
                                  signUpViewModel.emailController.text,
                                );
                              },
                              onChanged: (value) {
                                signUpViewModel.updateEmailBtn();
                              },
                              hintText: '이메일을 입력하세요.',
                              controller: signUpViewModel.emailController,
                              focusNode: signUpViewModel.emailFocusNode,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: CustomContinueButton(
                      onPressed: () {
                        signUpViewModel.handleValidateEmail(
                          context,
                          signUpViewModel.emailController.text,
                        );
                      },
                      color: signUpViewModel.isEmailActiveBtn
                          ? orchid
                          : Colors.grey,
                      text: '계속하기',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
