import 'package:flutter/material.dart';

class SubtitleTextWidget extends StatelessWidget {
  const SubtitleTextWidget(
      {super.key,
      required this.label,
      this.fontSize = 18,
      this.fontWeight = FontWeight.normal,
      this.textDecoration = TextDecoration.none,
      this.color,
      this.fontStyle = FontStyle.normal,
      this.textOverflow});
  final String label;
  final double fontSize;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final TextDecoration textDecoration;
  final Color? color;
  final TextOverflow? textOverflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          decoration: textDecoration,
          color: color,
          fontStyle: fontStyle,
          overflow: textOverflow),
    );
  }
}
