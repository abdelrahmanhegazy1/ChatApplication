import 'package:flutter/material.dart';

class MyAwesomeAnimation extends StatelessWidget {
  final Animation animation;
  final Padding myWidget;
  MyAwesomeAnimation({this.animation, this.myWidget});
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animation, curve: Curves.decelerate),
        child: myWidget);
  }
}
