import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/empty_bag.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/product_widget.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  const ViewedRecentlyScreen({super.key});
  final bool isEmpty = false;
  static String routeName = "ViewedRecentlyScreen";

  @override
  Widget build(BuildContext context) {
    return isEmpty
        ? Scaffold(
            body: EmptyBag(
              imagePath: AssetsManager.orderBag,
              title: "No Viewed Products Yet",
              subtile: "Looks Like Your Cart is Empty,Start Shopping!",
              details: "Looks Like Your Cart is Empty,Start Shopping!",
              buttonText: "Shop now",
            ),
          )
        : Scaffold(
            // bottomSheet: CartBottomSheetWidget(),
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsManager.orderBag),
              ),
              title: AppNameTextWidget(
                label: "Viewed Recently",
                fontSize: 22,
              ),
              actions: [
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.delete_forever_rounded))
              ],
            ),
            body: DynamicHeightGridView(
              // mainAxisSpacing: 12,
              // crossAxisSpacing: 12,
              builder: (context, index) {
                return ProductWidget();
              },
              itemCount: 10,
              crossAxisCount: 2,
            ),
          );
  }
}
