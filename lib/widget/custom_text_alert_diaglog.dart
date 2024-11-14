import 'package:bus_way/theme/colors.dart';
import 'package:bus_way/ui/mainpage/mypage/mypage_viewmodel.dart';
import 'package:bus_way/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<dynamic> showCustomTextAlertDialog(
    BuildContext context, MypageViewModel viewmodel, String dialogTitle) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer<MypageViewModel>(
        builder: (context, value, child) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                dialogTitle,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '비밀번호',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    onSubmitted: (value) {
                      if (viewmodel.checkPassword()) {
                        return Navigator.of(context, rootNavigator: true)
                            .pop(true);
                      }
                    },
                    onChanged: (value) {
                      // userModifyViewModel.updateMoreInfoBtn();
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        viewmodel.togglePasswordVisibility();
                      },
                      icon: Icon(
                        viewmodel.passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    hintText: '비밀번호를 입력해주세요',
                    controller: viewmodel.passwordController,
                    focusNode: viewmodel.passwordFocusNode,
                    obscureText: !viewmodel.passwordVisible,
                    textInputAction: TextInputAction.done,
                  ),
                  if (viewmodel.passwordErrorMessage != null)
                    Text(
                      viewmodel.passwordErrorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    if (viewmodel.checkPassword()) {
                      return Navigator.of(context, rootNavigator: true)
                          .pop(true);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: orchid,
                    side: const BorderSide(color: orchid),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text('확인'),
                ),
                OutlinedButton(
                  onPressed: () {
                    return Navigator.of(context, rootNavigator: false)
                        .pop(false);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text('취소'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
