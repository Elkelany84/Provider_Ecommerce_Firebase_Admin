import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/constants/app_constants.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/heart_btn.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});
  static String routeName = "ProductDetails";

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        // leading: Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: Image.asset(AssetsManager.shoppingCart),
        // ),
        title: AppNameTextWidget(
          label: "Shop Smart",
          fontSize: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FancyShimmerImage(
                  imageUrl: AppConstants.imageUrl,
                  height: size.height * 0.38,
                  width: double.infinity,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      "title" * 18,
                      softWrap: true,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SubtitleTextWidget(
                    label: "\$ 16.0", color: Colors.blue, fontSize: 20,
                    fontWeight: FontWeight.w700,
                    // maxLines: 2,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  HeartButtonWidget(
                    bgColor: Colors.blue.shade100,
                  ),
                  SizedBox(
                    height: kBottomNavigationBarHeight - 10,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      label: Text(
                        "Add To Cart",
                        style: TextStyle(fontSize: 20),
                      ),
                      icon: Icon(Icons.add_shopping_cart),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleTextWidget(label: "About This Item"),
                  SubtitleTextWidget(label: "In Phones")
                ],
              ),
              SizedBox(
                height: 5,
              ),
              SubtitleTextWidget(
                label: "Description" * 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
