import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/wishlist_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/empty_bag.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/product_widget.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});
  final bool isEmpty = true;
  static String routeName = "WishListScreen";

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(
      context,
    );
    return wishlistProvider.wishlistItems.isEmpty
        ? Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                EmptyBag(
                  imagePath: AssetsManager.bagWish,
                  title: "Nothing In Your WishList Yet",
                  // subtitle: "Looks Like Your Wishlist is Empty,Start Shopping!",
                  // details: "Looks Like Your Cart is Empty,Start Shopping!",
                  buttonText: "Shop now",
                ),
              ],
            ),
          )
        : Scaffold(
            // bottomSheet: CartBottomSheetWidget(),
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsManager.bagWish),
              ),
              title: AppNameTextWidget(
                label: "WishList (${wishlistProvider.wishlistItems.length})",
                fontSize: 22,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      MyAppFunctions.showErrorOrWarningDialog(
                          isError: false,
                          context: context,
                          fct: () async {
                            wishlistProvider.wishlistItems.clear();
                            await wishlistProvider.clearCartFirebase();
                          },
                          subTitle: "Clear Wishlist");
                    },
                    icon: Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.red,
                    ))
              ],
            ),
            body: DynamicHeightGridView(
              // mainAxisSpacing: 12,
              // crossAxisSpacing: 12,
              builder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProductWidget(
                    productId: wishlistProvider.wishlistItems.values
                        .toList()[index]
                        .productId,
                  ),
                );
              },
              itemCount: wishlistProvider.wishlistItems.length,
              crossAxisCount: 2,
            ),
          );
  }
}
