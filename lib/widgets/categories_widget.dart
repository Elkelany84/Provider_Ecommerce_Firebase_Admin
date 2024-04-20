import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/title_text.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(
      {super.key,
      required this.categoryId,
      required this.categoryName,
      required this.categoryImage});
  final String categoryId, categoryName, categoryImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Card(
          child: Row(
            children: [
              Image.asset(categoryImage),
              TitlesTextWidget(label: categoryName),
              IconButton(onPressed: () {}, icon: Icon(Icons.delete))
            ],
          ),
        ),
      ),
    );
  }
}
