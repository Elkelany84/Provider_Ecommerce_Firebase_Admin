import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:shimmer/shimmer.dart';

class AppNameTextWidget extends StatelessWidget {
  const AppNameTextWidget(
      {super.key, required this.label, required this.fontSize});
  final String label;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        period: const Duration(seconds: 22),
        baseColor: Colors.red,
        highlightColor: Colors.purple,
        child: TitleTextWidget(
          label: label,
          fontSize: fontSize,
        ));
  }
}
