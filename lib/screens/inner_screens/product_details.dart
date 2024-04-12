import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/cart_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/heart_btn.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    super.key,
  });
  static String routeName = "ProductDetails";

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final getCurrentProduct = productsProvider.findByProdId(productId);

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
        child: getCurrentProduct == null
            ? SizedBox.shrink()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FancyShimmerImage(
                        imageUrl: getCurrentProduct.productImage,
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
                            getCurrentProduct.productTitle,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SubtitleTextWidget(
                          label: "\$ ${getCurrentProduct.productPrice}",
                          color: Colors.blue, fontSize: 20,
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
                          productId: getCurrentProduct.productId,
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
                            onPressed: () async {
                              //check if already in cart
                              if (cartProvider.isProductInCart(
                                  productId: getCurrentProduct.productId)) {
                                return;
                              }
                              try {
                                await cartProvider.addToCartFirebase(
                                    productId: getCurrentProduct.productId,
                                    quantity: 1,
                                    context: context);
                              } catch (error) {
                                MyAppFunctions.showErrorOrWarningDialog(
                                    context: context,
                                    fct: () {},
                                    subTitle: error.toString());
                              }
                              // if (cartProvider.isProductInCart(
                              //     productId: getCurrentProduct.productId)) {
                              //   return;
                              // }
                              // cartProvider.addToCart(
                              //     productId: getCurrentProduct.productId);
                            },
                            label: Text(
                              cartProvider.isProductInCart(
                                      productId: getCurrentProduct.productId)
                                  ? "Added Already"
                                  : "Add To Cart",
                              style: TextStyle(fontSize: 20),
                            ),
                            icon: Icon(cartProvider.isProductInCart(
                                    productId: getCurrentProduct.productId)
                                ? Icons.check
                                : Icons.add_shopping_cart),
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
                        SubtitleTextWidget(
                            label: "In ${getCurrentProduct.productCategory}")
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SubtitleTextWidget(
                      label: getCurrentProduct.productDescription,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
