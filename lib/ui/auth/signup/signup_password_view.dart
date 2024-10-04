import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/auth/signup/signup_viewmodel.dart';
import 'package:bus_way/widget/custom_continue_button.dart';
import 'package:bus_way/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPassWordView extends StatelessWidget {
  const SignUpPassWordView({super.key});

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
                              '비밀번호를 입력해주세요',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              onSubmitted: (value) {
                                FocusScope.of(context).requestFocus(
                                    signUpViewModel.passwordConfirmFocusNode);
                              },
                              onChanged: (value) {
                                signUpViewModel.updatePasswordBtn();
                              },
                              hintText: '비밀번호를 입력하세요.',
                              controller: signUpViewModel.passwordController,
                              focusNode: signUpViewModel.passwordFocusNode,
                              obscureText: !signUpViewModel.passwordVisible,
                              textInputAction: TextInputAction.next,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  signUpViewModel.togglePasswordVisibility();
                                },
                                icon: Icon(
                                  signUpViewModel.passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            const Text(
                              '비밀번호를 한 번 더 입력해주세요',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              onSubmitted: (value) {
                                signUpViewModel.handleValidatePassword(
                                  context,
                                  signUpViewModel.passwordController.text,
                                  signUpViewModel
                                      .passwordConfirmController.text,
                                );
                              },
                              onChanged: (value) {
                                signUpViewModel.updatePasswordBtn();
                              },
                              hintText: '비밀번호를 한 번 더 입력하세요.',
                              controller:
                                  signUpViewModel.passwordConfirmController,
                              focusNode:
                                  signUpViewModel.passwordConfirmFocusNode,
                              obscureText:
                                  !signUpViewModel.passwordConfirmVisible,
                              textInputAction: TextInputAction.done,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  signUpViewModel
                                      .togglePasswordConfirmVisibility();
                                },
                                icon: Icon(
                                  signUpViewModel.passwordConfirmVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: CustomContinueButton(
                      onPressed: () {
                        signUpViewModel.handleValidatePassword(
                            context,
                            signUpViewModel.passwordController.text,
                            signUpViewModel.passwordConfirmController.text);
                      },
                      color: signUpViewModel.isPasswordActiveBtn
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
