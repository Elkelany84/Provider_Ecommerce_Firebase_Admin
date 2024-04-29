import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/root_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';

class EmptyBag extends StatelessWidget {
  const EmptyBag(
      {super.key,
      required this.imagePath,
      required this.title,
      this.subtitle = "",
      this.details = "",
      required this.buttonText});
  final String title, subtitle, details, buttonText, imagePath;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          Image.asset(
            imagePath,
            width: double.infinity,
            height: size.height * 0.35,
          ),
          const SizedBox(
            height: 20,
          ),
          TitleTextWidget(
            label: title,
            fontSize: 25,
            color: Colors.red,
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: SubtitleTextWidget(
              label: subtitle,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SubtitleTextWidget(
              label: details,
              fontWeight: FontWeight.w400,
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(RootScreen.routeName);
              },
              child: Text(buttonText))
        ],
      ),
    );
  }
}
