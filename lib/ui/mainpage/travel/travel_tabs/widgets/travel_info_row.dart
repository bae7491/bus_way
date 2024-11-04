import 'package:bus_way/widget/custom_html_converter.dart';
import 'package:flutter/material.dart';

Widget travelInfoRow(BuildContext context, String title, String content) {
  // URL을 여는 함수

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: customHtmlWidget(context, content),
            ),
          ],
        ),
      ),
      const Divider(
        height: 1,
      ),
    ],
  );
}
