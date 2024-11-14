import 'package:bus_way/data/model/mypage_model/mypage_user_model.dart';
import 'package:bus_way/data/respository/mypage_repository/mypage_repository.dart';
import 'package:bus_way/ui/mainpage/mypage/mypage_viewmodel.dart';
import 'package:bus_way/widget/custom_alert_dialog.dart';
import 'package:bus_way/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class UserModifyViewModel with ChangeNotifier {
  MypageRepository mypageRepository = MypageRepository();

  // 내정보 수정 관련 textField의 값을 저장하는 Controller 목록
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final nickNameController = TextEditingController();

  // 전화번호 포맷팅을 위해 사용
  var maskFormatter = MaskTextInputFormatter(
      mask: '###-####-####', filter: {"#": RegExp(r'[0-9]')});

  // 내정보 수정 관련 textField의 Focus 목록
  final phoneNumberFocusNode = FocusNode();
  final nickNameFocusNode = FocusNode();

  MypageUserModel? _userInfo;
  bool _isActiveBtn = false;
  bool _isLoading = false;
  String? _errorMessage;

  MypageUserModel? get userInfo => _userInfo;
  bool get isActiveBtn => _isActiveBtn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserModifyViewModel() {
    loadUserInfo();
    notifyListeners();
  }

  @override
  void dispose() {
    // TextEditingController 해제
    emailController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    nickNameController.dispose();

    // FocusNode 해제
    phoneNumberFocusNode.dispose();
    nickNameFocusNode.dispose();

    super.dispose();
  }

  // 에러 메시지 초기화
  void clearErrorMessage() async {
    _errorMessage = null;
    notifyListeners();
  }

  // 내정보 불러오기
  Future<void> loadUserInfo() async {
    try {
      _isLoading = true;
      notifyListeners();

      _userInfo = await mypageRepository.getUserInfo();

      // 각 TextField에 내정보 초기 값 추가
      if (_userInfo != null) {
        emailController.text = _userInfo!.email!;
        nameController.text = _userInfo!.name!;
        // 초기 전화번호를 포맷에 맞게 설정
        String rawPhoneNumber = _userInfo!.phoneNumber!;
        phoneNumberController.text = maskFormatter
            .formatEditUpdate(
              const TextEditingValue(),
              TextEditingValue(text: rawPhoneNumber),
            )
            .text;
        nickNameController.text = _userInfo!.nickName!;
      }

      updateMoreInfoBtn();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 추가 정보 (전화번호) 유효성 검사 로직
  String? isValidPhoneNumberFormat(String phoneNumber) {
    String pattern = r'^(010)-\d{3,4}-\d{4}$';
    RegExp regExp = RegExp(pattern);

    if (phoneNumber.isEmpty) {
      return '전화번호를 입력해주세요.';
    } else if (!regExp.hasMatch(phoneNumber)) {
      return '010으로 시작하는 유효한 전화번호를 입력해주세요.';
    } else {
      return null;
    }
  }

  // 추가 정보 (별명) 유효성 검사 로직
  String? isValidNickNameFormat(String nickName) {
    String pattern = r'^[a-zA-Z가-힣0-9]+$';
    RegExp regExp = RegExp(pattern);

    if (nickName.isEmpty) {
      return '별명을 입력해주세요.';
    } else if (!regExp.hasMatch(nickName)) {
      return '별명에 특수문자를 포합할 수 없습니다.';
    } else {
      return null;
    }
  }

  // 내정보 수정 요청 확인 팝업
  Future<void> checkModifyReivew(BuildContext context) async {
    final phoneNumberError =
        isValidPhoneNumberFormat(phoneNumberController.text);
    final nickNameError = isValidNickNameFormat(nickNameController.text);

    if (!_isActiveBtn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const CustomSnackbar(content: Text('입력 값을 다시 확인해 주세요.')),
      );
      return;
    } else if (phoneNumberError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbar(
          content: Text(phoneNumberError),
        ),
      );
      return;
    } else if (nickNameError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbar(
          content: Text(nickNameError),
        ),
      );
      return;
    }

    final isModifyUserInfo = await showCustomAlertDialog(
          context,
          '내정보를 수정하시겠습니까?',
        ) ??
        false;

    phoneNumberFocusNode.unfocus();
    nickNameFocusNode.unfocus();

    bool isUnique = await validateModifyUserUnique();

    print('isUnique: $isUnique');

    if (!isUnique && isModifyUserInfo && context.mounted) {
      await uploadModifyUserInfo(context);
    } else {
      _errorMessage = '이미 사용 중인 전화번호나 별명입니다.\n다른 정보를 입력해주세요.';
      notifyListeners();
    }
  }

  // 내정보 수정 전, 중복값 검사
  Future<bool> validateModifyUserUnique() async {
    try {
      bool isUnique = await mypageRepository.validateModifyUserUnique(
        phoneNumberController.text,
        nickNameController.text,
      );

      return isUnique;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 수정한 내정보를 서버에 업로드
  Future<void> uploadModifyUserInfo(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      await mypageRepository.modifyUserInfo(
        phoneNumberController.text,
        nickNameController.text,
      );

      if (context.mounted) {
        navigatePreviousPage(context);
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 내정보 수정 완료 후, 마이 페이지로 이동.
  void navigatePreviousPage(BuildContext context) {
    final myPageViewModel =
        Provider.of<MypageViewModel>(context, listen: false);

    Navigator.of(context).pop();
    myPageViewModel.loadUserInfo();
  }

  // 내정보 수정 페이지 버튼 활성화 여부 변경 로직
  void updateMoreInfoBtn() {
    _isActiveBtn = emailController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        nickNameController.text.isNotEmpty;
    notifyListeners();
  }
}
