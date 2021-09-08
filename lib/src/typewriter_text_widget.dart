import 'dart:math';

import 'package:flutter/material.dart';

class TypewriterTextWidget extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final int millisecondsPerLetter;
  final Function? onComplete;

  const TypewriterTextWidget({
    Key? key,
    required this.millisecondsPerLetter,
    required this.text,
    this.textStyle,
    this.onComplete,
  }) : super(
          key: key,
        );

  @override
  _TypewriterTextWidgetState createState() => _TypewriterTextWidgetState();
}

class _TypewriterTextWidgetState extends State<TypewriterTextWidget>
    with SingleTickerProviderStateMixin {
  final int cursorCount = 8;

  late AnimationController animationController;
  late Animation<int> textAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.millisecondsPerLetter * widget.text.length,
      ),
    );

    textAnimation = IntTween(
      begin: 0,
      end: widget.text.length + cursorCount,
    ).animate(animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (widget.onComplete != null) {
            widget.onComplete!();
          }
        }
      });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: textAnimation,
      builder: (context, child) {
        int size = min<int>(widget.text.length, textAnimation.value);
        int extra = max<int>(0, textAnimation.value - size);
        String str = widget.text.substring(0, size);
        str += extra == 0 || extra % 2 != 0 ? '_' : '  ';
        return Text(
          str,
          style: widget.textStyle,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}
