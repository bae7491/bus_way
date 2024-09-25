import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final void Function(String)? onSubmitted;
  final Widget? suffixIcon;
  
  const CustomTextField(
    {
      super.key,
      required this.controller,
      required this.hintText,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.obscureText = false,
      this.onSubmitted,
      this.suffixIcon,
    }
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      onSubmitted: onSubmitted,
      // textField 밖을 클릭하면 focus 해제
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }
}