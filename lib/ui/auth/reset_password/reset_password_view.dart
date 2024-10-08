import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/auth/reset_password/reset_password_viewmodel.dart';
import 'package:bus_way/widget/custom_continue_button.dart';
import 'package:bus_way/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer<ResetPasswordViewModel>(
        builder: (context, resetPasswordViewModel, child) {
          return PopScope(
            canPop: !resetPasswordViewModel.isLoading,
            child: Stack(
              children: [
                Scaffold(
                  resizeToAvoidBottomInset: true,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    centerTitle: true,
                    title: const Text(
                      '비밀번호 재설정',
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
                                      resetPasswordViewModel
                                          .handleValidateEmail(
                                        context,
                                        resetPasswordViewModel
                                            .emailController.text,
                                      );
                                    },
                                    onChanged: (value) {
                                      resetPasswordViewModel.updateEmailBtn();
                                    },
                                    hintText: '이메일을 입력하세요.',
                                    controller:
                                        resetPasswordViewModel.emailController,
                                    focusNode:
                                        resetPasswordViewModel.emailFocusNode,
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
                              resetPasswordViewModel.handleValidateEmail(
                                context,
                                resetPasswordViewModel.emailController.text,
                              );
                            },
                            color: resetPasswordViewModel.isEmailActiveBtn
                                ? orchid
                                : Colors.grey,
                            text: '계속하기',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 로딩 중일 때 보여줄 회색 배경과 CircularProgressIndicator
                if (resetPasswordViewModel.isLoading)
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
      ),
    );
  }
}
