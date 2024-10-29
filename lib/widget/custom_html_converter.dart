import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

// 공통 HTML 렌더링 함수
Widget customHtmlWidget(String htmlData, [dynamic viewmodel]) {
  return Html(
    data: htmlData.replaceAll(r'\\n', '\n'), // \\n을 실제 개행 문자로 변환
    onLinkTap: (url, _, __) {
      if (url != null && viewmodel != null) {
        viewmodel.launchExternalUrl(url);
      }
    },
    style: {
      "p": Style(
        fontSize: FontSize(15),
      ),
      "a": Style(
        color: Colors.blue,
        textDecoration: TextDecoration.underline,
      ),
    },
  );
}
