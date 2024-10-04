import 'package:bus_way/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomContinueButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const CustomContinueButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color = orchid,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(64),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          const Icon(Icons.keyboard_arrow_right),
        ],
      ),
    );
  }
}
