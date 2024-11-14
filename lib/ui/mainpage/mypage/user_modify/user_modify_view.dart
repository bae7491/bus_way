import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/mypage/mypage_viewmodel.dart';
import 'package:bus_way/ui/mainpage/mypage/user_modify/user_modify_viewmodel.dart';
import 'package:bus_way/widget/custom_alert_dialog.dart';
import 'package:bus_way/widget/custom_continue_button.dart';
import 'package:bus_way/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class UserModifyView extends StatelessWidget {
  const UserModifyView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final myPageViewModel =
        Provider.of<MypageViewModel>(context, listen: false);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ChangeNotifierProvider<UserModifyViewModel>(
        create: (_) => UserModifyViewModel(),
        child: Consumer<UserModifyViewModel>(
          builder: (context, userModifyViewModel, child) {
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) async {
                if (!didPop) {
                  final shouldPop = await showCustomAlertDialog(
                          context, '내정보 수정을 취소하시겠습니까?') ??
                      false;

                  userModifyViewModel.phoneNumberFocusNode.unfocus();
                  userModifyViewModel.nickNameFocusNode.unfocus();

                  if (shouldPop && context.mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                    myPageViewModel.loadUserInfo();
                  }
                }
              },
              child: Stack(
                children: [
                  Scaffold(
                    resizeToAvoidBottomInset: true,
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      centerTitle: true,
                      title: const Text(
                        '내정보 수정',
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
                                  const SizedBox(height: 20),
                                  const Text(
                                    '이메일',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    enabled: false,
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade200,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    controller:
                                        userModifyViewModel.emailController,
                                  ),
                                  const SizedBox(height: 30),
                                  const Text(
                                    '이름',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    enabled: false,
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade200,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    controller:
                                        userModifyViewModel.nameController,
                                  ),
                                  const SizedBox(height: 30),
                                  const Text(
                                    '전화번호',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextField(
                                    onSubmitted: (value) {
                                      FocusScope.of(context).requestFocus(
                                          userModifyViewModel
                                              .nickNameFocusNode);
                                    },
                                    onChanged: (value) {
                                      userModifyViewModel.updateMoreInfoBtn();
                                    },
                                    inputFormatters: [
                                      userModifyViewModel.maskFormatter
                                    ],
                                    hintText: '변경할 전화번호를 입력하세요',
                                    controller: userModifyViewModel
                                        .phoneNumberController,
                                    focusNode: userModifyViewModel
                                        .phoneNumberFocusNode,
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: 30),
                                  const Text(
                                    '별명',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextField(
                                    onSubmitted: (value) {
                                      userModifyViewModel
                                          .checkModifyReivew(context);
                                    },
                                    onChanged: (value) {
                                      userModifyViewModel.updateMoreInfoBtn();
                                    },
                                    hintText: '변경할 별명을 입력하세요',
                                    controller:
                                        userModifyViewModel.nickNameController,
                                    focusNode:
                                        userModifyViewModel.nickNameFocusNode,
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
                                userModifyViewModel.checkModifyReivew(context);
                              },
                              color: userModifyViewModel.isActiveBtn
                                  ? orchid
                                  : Colors.grey,
                              text: '정보 수정'),
                        ),
                      ],
                    ),
                  ),
                  // 로딩 중일 때 보여줄 회색 배경과 CircularProgressIndicator
                  if (userModifyViewModel.isLoading)
                    const Positioned.fill(
                      child: Center(
                        child: SpinKitRing(
                          color: orchid,
                          size: 120,
                          lineWidth: 12.0,
                        ), // 로딩 인디케이터
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
