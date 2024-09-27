import 'package:flutter/material.dart';

enum SlideDirection { bottomToTop, rightToLeft }

class NavigatorAnimation {
  final Widget destination;

  const NavigatorAnimation({required this.destination});

  // 애니메이션 시작 위치 설정 함수
  Offset _getBeginOffset(SlideDirection direction) {
    switch (direction) {
      case SlideDirection.bottomToTop:
        return const Offset(0.0, 1.0);
      case SlideDirection.rightToLeft:
        return const Offset(1.0, 0.0);
    }
  }

  // 화면 전환 애니메이션
  Route createRoute(SlideDirection direction) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryanimation) => destination,
      transitionsBuilder:
          // secondaryAnimation: 화면 전화시 사용되는 보조 애니메이션효과
          // child: 화면이 전환되는 동안 표시할 위젯을 의미(즉, 전환 이후 표시될 위젯 정보를 의미)
          (context, animation, secondaryAnimation, child) {
        // Offset에서 x값 1은 오른쪽 끝 y값 1은 아래쪽 끝을 의미한다.
        // 애니메이션이 시작할 포인트 위치를 의미한다.
        var begin = _getBeginOffset(direction);
        var end = Offset.zero;
        // Curves.ease: 애니메이션이 부드럽게 동작하도록 명령
        var curve = Curves.ease;
        // 애니메이션의 시작과 끝을 담당한다.
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(
          CurveTween(
            curve: curve,
          ),
        );
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      // 애니메이션의 속도를 조절하는 부분 (1초로 설정)
      transitionDuration: const Duration(milliseconds: 500), // 1초
      reverseTransitionDuration:
          const Duration(milliseconds: 500), // 반대로 돌아가는 속도도 동일하게 설정 가능
    );
  }
}
