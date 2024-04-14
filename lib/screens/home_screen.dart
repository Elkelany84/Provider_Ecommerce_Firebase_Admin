import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/constants/app_constants.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/category_runded_widget.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/latest_arrival.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    // UserModel? userModel;
    // User? user = FirebaseAuth.instance.currentUser;
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              // Visibility(
              //   visible: user == null ? false : true,
              //   child: SubtitleTextWidget(
              //     label: "Delivery to :${userModel!.userName}",
              //   ),
              // ),
              SizedBox(
                height: size.height * 0.22,
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(20),
                  child: Swiper(
                    autoplay: true,
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
              Visibility(
                  visible: productsProvider.getProducts.isNotEmpty,
                  child: TitleTextWidget(label: "Latest Arrivals")),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: productsProvider.getProducts.isNotEmpty,
                child: SizedBox(
                  height: size.height * 0.2,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productsProvider.getProducts.length < 10
                          ? productsProvider.getProducts.length
                          : 3,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: productsProvider.getProducts[index],
                            child: LatestArrivalProductWidgets());
                      }),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TitleTextWidget(label: "Categories"),
              SizedBox(
                height: 10,
              ),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children:
                    List.generate(AppConstants.categoriesList.length, (index) {
                  return CategoryRoundedWidget(
                    name: AppConstants.categoriesList[index].name,
                    image: AppConstants.categoriesList[index].image,
                  );
                }),
              )
            ],
          ),
        ),
      ),
      // backgroundColor: AppColors.lightScaffoldColor,
    );
  }
}
