import 'package:flutter/material.dart';

void slideHorizontalNavigateStateful(BuildContext context, Widget screen, {bool deleteStack = false}) {
  Route createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // 오른쪽에서 왼쪽으로 이동
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      fullscreenDialog: false,
    );
  }

  if (deleteStack) {
    Navigator.pushAndRemoveUntil(context, createRoute(), (route) => false);
  } else {
    Navigator.push(context, createRoute());
  }
}