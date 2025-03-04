import 'package:flutter/material.dart';

class AppText extends StatelessWidget{
  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  const AppText({
    super.key,
    required this.text,
    this.style = const TextStyle(),
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
    );
  }
}