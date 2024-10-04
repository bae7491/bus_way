import 'package:bus_way/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool onTapOutside;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final List<MaskTextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.onTapOutside = false,
    this.onSubmitted,
    this.onChanged,
    this.suffixIcon,
    this.focusNode,
    this.inputFormatters,
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
          borderSide: BorderSide(color: orchid, width: 2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: orchid, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      // textField 밖을 클릭하면 focus 해제
      onTapOutside: onTapOutside
          ? (event) => FocusManager.instance.primaryFocus?.unfocus()
          : null,
    );
  }
}
