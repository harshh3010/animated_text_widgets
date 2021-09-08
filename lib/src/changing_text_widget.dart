import 'dart:math';

import 'package:flutter/material.dart';

class ChangingTextWidget extends StatefulWidget {
  final String text;
  final String letters;
  final int letterChangeTime;
  final int letterSwitchCount;
  final bool changeRandomly;
  final Function? onComplete;

  const ChangingTextWidget({
    Key? key,
    required this.text,
    this.letters =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#\$%&",
    this.letterChangeTime = 50,
    this.letterSwitchCount = 50,
    this.changeRandomly = true,
    this.onComplete,
  }) : super(key: key);

  @override
  _ChangingTextWidgetState createState() => _ChangingTextWidgetState();
}

class _ChangingTextWidgetState extends State<ChangingTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<int> textAnimation;

  late List<List<int>> arr;

  @override
  void initState() {
    super.initState();

    arr = List.generate(widget.text.length, (index) {
      List<int> temp = List.generate(widget.letterSwitchCount, (index) {
        int idx = widget.changeRandomly
            ? Random().nextInt(widget.letters.length)
            : index % widget.letters.length;
        return idx;
      });
      return temp;
    });

    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.letterChangeTime * widget.letterSwitchCount,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.onComplete != null) {
          widget.onComplete!();
        }
      }
    });

    textAnimation = StepTween(
      begin: 0,
      end: widget.letterSwitchCount,
    ).animate(animationController);
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: textAnimation,
      builder: (context, child) {
        String str = "";

        if (textAnimation.value == widget.letterSwitchCount) {
          str = widget.text;
        } else {
          for (int i = 0; i < widget.text.length; i++) {
            str += widget.letters[arr[i][textAnimation.value]];
          }
        }

        return Text(
          str,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
