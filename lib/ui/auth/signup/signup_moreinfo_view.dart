import 'package:bus_way/ui/auth/signup/signup_complete_view.dart';
import 'package:bus_way/ui/auth/signup/signup_viewmodel.dart';
import 'package:bus_way/widget/custom_continue_button.dart';
import 'package:bus_way/widget/custom_snackbar.dart';
import 'package:bus_way/widget/custom_text_field.dart';
import 'package:bus_way/widget/navigator_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupMoreinfoView extends StatelessWidget {
  const SignupMoreinfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpViewModel(),
      child: GestureDetector(
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
                                '이름을 입력해주세요',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                hintText: '이름을 입력하세요',
                                controller: signUpViewModel.nameController,
                              ),
                              const SizedBox(height: 40),

                              // TODO: 전화번호가 필요한지 재확인 필요.
                              const Text(
                                '전화번호를 입력해주세요',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                hintText: '전화번호를 입력하세요',
                                controller:
                                    signUpViewModel.phoneNumberController,
                              ),
                              const SizedBox(height: 40),
                              // 전화번호 입력 끝부분

                              const Text(
                                '사용할 별명을 입력해주세요',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                hintText: '별명을 입력하세요',
                                controller: signUpViewModel.nickNameController,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: CustomContinueButton(
                          onPressed: () async {
                            // signUpViewModel.handleValidateMoreInfo(
                            //     context,
                            //     signUpViewModel.nameController.text,
                            //     signUpViewModel.phoneNumberController.text,
                            //     signUpViewModel.nickNameController.text);
                            await signUpViewModel.signUp(
                                signUpViewModel.emailController.text,
                                signUpViewModel.passwordConfirmController.text);
                            if (signUpViewModel.errorMessage == null &&
                                signUpViewModel.user != null &&
                                context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  const NavigatorAnimation(
                                          destination: SignUpCompleteView())
                                      .createRoute(SlideDirection.rightToLeft),
                                  (route) => false);
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackbar(
                                    content:
                                        Text(signUpViewModel.errorMessage!)),
                              );
                            }
                          },
                          text: '계속하기'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
