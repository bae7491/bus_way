import 'package:bus_way/widget/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

// 공통 HTML 렌더링 함수
Widget customHtmlWidget(BuildContext context, String htmlData,
    [dynamic viewmodel]) {
  return Html(
    data: htmlData.replaceAll(r'\\n', '\n'), // \\n을 실제 개행 문자로 변환
    onLinkTap: (url, _, __) async {
      if (context.mounted) {
        final isOpenHtmlLink = await showCustomAlertDialog(
              context,
              '링크로 이동하시겠습니까?',
            ) ??
            false;
        if (url != null && viewmodel != null && isOpenHtmlLink) {
          viewmodel.launchExternalUrl(url);
        }
      }
    },
    style: {
      "a": Style(
        color: Colors.blue,
        textDecoration: TextDecoration.underline,
      ),
      "body": Style(
        fontSize: FontSize(12.0),
      ),
    },
  );
}
