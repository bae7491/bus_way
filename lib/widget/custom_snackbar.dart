import 'package:flutter/material.dart';

class CustomSnackbar extends SnackBar {
  const CustomSnackbar({
    super.key,
    required super.content, // content를 super parameter로 전달
  }) : super(
          padding: const EdgeInsets.all(25),
          duration: const Duration(seconds: 1),
        );
}
