import 'package:bus_way/ui/auth/verify_email/verify_email_viewmodel.dart';
import 'package:bus_way/widget/custom_continue_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VerifyEmailViewmodel>(
      builder: (context, verifyEmailViewModel, child) {
        return PopScope(
          canPop: !verifyEmailViewModel.isLoading,
          child: Stack(
            children: [
              Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  centerTitle: true,
                  title: const Text(
                    '이메일 인증',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                body: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 150),
                            Text(
                              '입력하신 주소로\n인증 메일을 보냈어요',
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.0),
                        child: Text(
                          '메일을 확인한 후,\n아래의 계속하기를 눌러주세요.',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: CustomContinueButton(
                            onPressed: () {
                              verifyEmailViewModel.handleVerifyEmail(context);
                            },
                            text: '계속하기'),
                      ),
                    ],
                  ),
                ),
              ),
              // 로딩 중일 때 보여줄 회색 배경과 CircularProgressIndicator
              if (verifyEmailViewModel.isLoading)
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
