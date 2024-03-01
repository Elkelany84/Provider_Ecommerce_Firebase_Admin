import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';

class QuantityBottomSheetWidget extends StatelessWidget {
  const QuantityBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //YOU CAN'T PUT LISTVIEW.BUILDER DIRECTLY IN COLUMN unless you wrap the column with singlechild
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          height: 6,
          width: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.grey),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
              // physics: NeverScrollableScrollPhysics(),
              // shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SubtitleTextWidget(label: "${index + 1}"),
                  )),
                );
              }),
        ),
      ],
    );
  }
}
