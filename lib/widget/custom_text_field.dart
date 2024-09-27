import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool onTapOutside;

  // 길게 누르면 나오는 기능 사용 여부 (true: 사용, false: 금지)
  final bool enableInteractiveSelection;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String)? onSubmitted;
  final Widget? suffixIcon;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.onTapOutside = false,
    this.enableInteractiveSelection = true,
    this.onSubmitted,
    this.suffixIcon,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      enableInteractiveSelection: enableInteractiveSelection,
      obscureText: obscureText,
      onSubmitted: onSubmitted,
      // textField 밖을 클릭하면 focus 해제
      onTapOutside: onTapOutside
          ? (event) => FocusManager.instance.primaryFocus?.unfocus()
          : null,
    );
  }
}
