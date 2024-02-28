import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/constants/app_constants.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/latest_arrival.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
        title: AppNameTextWidget(
          label: "Shop Smart",
          fontSize: 40,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: size.height * 0.25,
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(20),
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.asset(
                      AppConstants.bannerImages[index],
                      fit: BoxFit.fill,
                    );
                  },
                  itemCount: AppConstants.bannerImages.length,
                  pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                        activeColor: Colors.red, color: Colors.white),
                  ),
                  // control: SwiperControl(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TitleTextWidget(label: "Latest Arrivals"),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: size.height * 0.2,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return LatestArrivalProductWidgets();
                  }),
            )
          ],
        ),
      ),
      // backgroundColor: AppColors.lightScaffoldColor,
    );
  }
}
