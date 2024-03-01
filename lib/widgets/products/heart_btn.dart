import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget(
      {super.key, this.bgColor = Colors.transparent, this.size = 20});
  final Color bgColor;
  final double size;

  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: widget.bgColor, shape: BoxShape.circle),
      child: IconButton(
        style: IconButton.styleFrom(elevation: 10),
        onPressed: () {},
        icon: Icon(
          IconlyLight.heart,
          size: widget.size,
        ),
      ),
    );
  }
}
