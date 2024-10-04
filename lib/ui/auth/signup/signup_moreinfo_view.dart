import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/auth/signup/signup_viewmodel.dart';
import 'package:bus_way/widget/custom_continue_button.dart';
import 'package:bus_way/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupMoreinfoView extends StatelessWidget {
  const SignupMoreinfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer<SignUpViewModel>(
        builder: (context, signUpViewModel, child) {
          return PopScope(
            // 로딩 중 일떄, 뒤로가기 막기
            canPop: !signUpViewModel.isLoading,
            child: Stack(
              children: [
                Scaffold(
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
                  body: Column(
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
                                  onSubmitted: (value) {
                                    FocusScope.of(context).requestFocus(
                                        signUpViewModel.phoneNumberFocusNode);
                                  },
                                  onChanged: (value) {
                                    signUpViewModel.updateMoreInfoBtn();
                                  },
                                  hintText: '이름을 입력하세요',
                                  controller: signUpViewModel.nameController,
                                  focusNode: signUpViewModel.nameFocusNode,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 40),
                                const Text(
                                  '전화번호를 입력해주세요',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  onSubmitted: (value) {
                                    FocusScope.of(context).requestFocus(
                                        signUpViewModel.nickNameFocusNode);
                                  },
                                  onChanged: (value) {
                                    signUpViewModel.updateMoreInfoBtn();
                                  },
                                  inputFormatters: [
                                    signUpViewModel.maskFormatter
                                  ],
                                  hintText: '전화번호를 입력하세요',
                                  controller:
                                      signUpViewModel.phoneNumberController,
                                  focusNode:
                                      signUpViewModel.phoneNumberFocusNode,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 40),
                                const Text(
                                  '사용할 별명을 입력해주세요',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  onSubmitted: (value) {
                                    signUpViewModel.handleValidateMoreInfo(
                                      context,
                                      signUpViewModel.nameController.text,
                                      signUpViewModel
                                          .phoneNumberController.text,
                                      signUpViewModel.nickNameController.text,
                                    );
                                  },
                                  onChanged: (value) {
                                    signUpViewModel.updateMoreInfoBtn();
                                  },
                                  hintText: '별명을 입력하세요',
                                  controller:
                                      signUpViewModel.nickNameController,
                                  focusNode: signUpViewModel.nickNameFocusNode,
                                  textInputAction: TextInputAction.done,
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
                              signUpViewModel.handleValidateMoreInfo(
                                context,
                                signUpViewModel.nameController.text,
                                signUpViewModel.phoneNumberController.text,
                                signUpViewModel.nickNameController.text,
                              );
                            },
                            color: signUpViewModel.isMoreInfoActiveBtn
                                ? orchid
                                : Colors.grey,
                            text: '계속하기'),
                      ),
                    ],
                  ),
                ),
                // 로딩 중일 때 보여줄 회색 배경과 CircularProgressIndicator
                if (signUpViewModel.isLoading)
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
