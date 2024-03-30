import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/subtitle_text.dart';

class DashboardButtonsWidget extends StatelessWidget {
  const DashboardButtonsWidget(
      {super.key,
      required this.text,
      required this.imagePath,
      required this.onPressed});
  final text, imagePath;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 65,
                width: 65,
              ),
              const SizedBox(height: 10),
              SubtitleTextWidget(label: text)
            ],
          ),
        ),
      ),
    );
  }
}
