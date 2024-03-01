import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';

class EmptyBag extends StatelessWidget {
  const EmptyBag(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.subtile,
      this.details = "",
      required this.buttonText});
  final String title, subtile, details, buttonText, imagePath;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Image.asset(
            imagePath,
            width: double.infinity,
            height: size.height * 0.35,
          ),
          SizedBox(
            height: 20,
          ),
          TitleTextWidget(
            label: title,
            fontSize: 30,
            color: Colors.red,
          ),
          SizedBox(
            height: 20,
          ),
          SubtitleTextWidget(
            label: subtile,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
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
              onPressed: () {},
              child: Text(buttonText))
        ],
      ),
    );
  }
}
