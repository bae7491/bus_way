/* 
  ViewModel -> Model과 View를 연결하는 역할.
  상태 관리 로직 담당.

  signup_viewmodel : auth_repository.dart 및 signup_view.dart와 상호작용.

  - 역할
    1. 상태 관리 / Model의 메서드 호출 -> 데이터 가져옴.
      (auth_repository.dart로 연결.)
    2. notifyListeners 추가 후, 이를 통해 데이터에 업데이트가 있다는 것을 ViewModel이 참조하고 있는 View에 알림.

    signup_view.dart의 TextField에서 입력한 이메일 주소로 FirebaseAuth의 인증 메일 보내기.
*/

import 'package:bus_way/data/respository/auth_repository.dart';
import 'package:bus_way/ui/auth/signup/signup_complete_view.dart';
import 'package:bus_way/ui/auth/signup/signup_moreinfo_view.dart';
import 'package:bus_way/ui/auth/signup/signup_password_view.dart';
import 'package:bus_way/widget/custom_snackbar.dart';
import 'package:bus_way/widget/navigator_animation.dart';
import 'package:flutter/material.dart';
import '../../../data/model/user_model.dart';

class SignUpViewModel with ChangeNotifier {
  AuthRepository authRepository = AuthRepository();

  // 회원가입 textField의 값을 저장하는 Controller 목록
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final nickNameController = TextEditingController();

  // 회원가입 textField에 줄 Focus 목록
  final focusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final passwordConfirmFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final nickNameFocusNode = FocusNode();

  UserModel? _user;
  String? _errorMessage;
  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _passwordConfirmVisible = false;

  String? _email;

  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get passwordVisible => _passwordVisible;
  bool get passwordConfirmVisible => _passwordConfirmVisible;

  String? get email => _email;

  // 메모리 누수 방지를 위한 리소스 해제
  @override
  void dispose() {
    // TextEditingController 해제
    print('textEditingController dispose');
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    nickNameController.dispose();

    // FocusNode 해제
    focusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    passwordConfirmFocusNode.dispose();
    nameFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    nickNameFocusNode.dispose();

    super.dispose();
  }

  // TODO: Firebase 회원가입 요청 로직
  Future<void> signUp(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await authRepository.signUp(email, password);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 이메일 정규식 체크 로직
  String? isValidEmailFormat(String email) {
    if (email.isEmpty) {
      return '이메일을 입력해 주세요.';
    } else {
      String pattern =
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(email)) {
        return '이메일 형식을 다시 확인해 주세요.';
      }
    }
    return null; // 유효한 이메일 형식일 경우
  }

  // 이메일 정규식 체크 후, 판정 로직
  void handleValidateEmail(BuildContext context, String email) {
    final emailError = isValidEmailFormat(email);

    // 이메일 형식이 잘못되었을 때 에러 메시지 출력
    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbar(content: Text(emailError)),
      );
    } else {
      _email = email;
      print('email: $_email');
      emailFocusNode.unfocus();
      Navigator.of(context).push(
          const NavigatorAnimation(destination: SignUpPassWordView())
              .createRoute(SlideDirection.rightToLeft));
    }
  }

  // 비밀번호 정규식 체크 로직
  String? isValidPasswordFormat(String password) {
    String pattern =
        r'^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{8,15}$';
    RegExp regExp = RegExp(pattern);

    if (password.isEmpty) {
      return '비밀번호를 입력해 주세요';
    } else if (password.length < 8) {
      return '비밀번호는 8자리 이상이어야 합니다';
    } else if (!regExp.hasMatch(password)) {
      return '특수문자, 문자, 숫자 포함 8자 이상 15자 이내로 입력해 주세요.';
    } else {
      return null; // 유효한 비밀번호일 경우
    }
  }

  // 비밀번호 확인 유효성 검사 로직
  String? isValidatePasswordConfirmFormat(
      String password, String passwordConfirm) {
    if (passwordConfirm.isEmpty) {
      return '비밀번호 확인칸을 입력해 주세요';
    } else if (password != passwordConfirm) {
      return '입력한 비밀번호가 서로 다릅니다.';
    } else {
      return null; // 비밀번호와 비밀번호 확인이 같은 경우
    }
  }

  // 비밀번호 정규식 체크 및 확인 유효성 검사 후, 판정 로직
  void handleValidatePassword(
      BuildContext context, String password, String passwordConfirm) {
    final passwordError = isValidPasswordFormat(password);
    // 비밀번호 형식이 잘못되었을 때 에러 메시지 출력
    if (passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbar(content: Text(passwordError)),
      );
    } else {
      final passwordConfirmError =
          isValidatePasswordConfirmFormat(password, passwordConfirm);
      // 비밀번호와 비밀번호 확인이 매칭이 안되었을 때, 에러 메시지 출력
      if (passwordConfirmError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackbar(content: Text(passwordConfirmError)),
        );
      } else {
        print('email on password: $_email');
        passwordFocusNode.unfocus();
        passwordConfirmFocusNode.unfocus();
        Navigator.of(context).push(
            const NavigatorAnimation(destination: SignupMoreinfoView())
                .createRoute(SlideDirection.rightToLeft));
      }
    }
  }

  // 추가 정보 체크 후, 판정 로직
  void handleValidateMoreInfo(
      BuildContext context, String name, String phoneNumber, String nickName) {
    nameFocusNode.unfocus();
    phoneNumberFocusNode.unfocus();
    nickNameFocusNode.unfocus();
    Navigator.of(context).pushAndRemoveUntil(
        const NavigatorAnimation(destination: SignUpCompleteView())
            .createRoute(SlideDirection.rightToLeft),
        (route) => false);
  }

  // 비밀번호 textField 보이기/숨기기 토글 로직
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  // 비밀번호 재확인 textField 보이기/숨기기 토글 로직
  void togglePasswordConfirmVisibility() {
    _passwordConfirmVisible = !_passwordConfirmVisible;
    notifyListeners();
  }
}
