import 'package:flutter/material.dart';

class CircularProgressBarWidget extends StatelessWidget {
  final Color? color;
  const CircularProgressBarWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: color,
      strokeWidth: 4,
    );
  }
}