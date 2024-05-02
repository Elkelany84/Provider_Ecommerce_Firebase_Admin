import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/cart_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/categories_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/order_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/user_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/wishlist_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/cart/cart_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/home_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/profile_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/search_screen.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});
  static const String routeName = "RootScreen";

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late PageController controller;
  late List<Widget> screens;
  int currentScreen = 0;
  bool isLoadingProd = true;

  @override
  void initState() {
    screens = [
      const HomeScreen(),
      const SearchScreen(),
      const CartScreen(),
      const ProfileScreen()
    ];
    controller = PageController(initialPage: currentScreen);
    super.initState();
  }

  //fetch products from firebase function
  Future<void> fetchFct() async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: false);

    try {
      // await productsProvider.fetchProducts();
      // await categoriesProvider.fetchCategories();
      // await userProvider.fetchUserInfo();
      Future.wait({
        productsProvider.fetchProducts(),
        categoriesProvider.fetchCategories(),
        userProvider.fetchUserInfo(),
        // orderProvider.getFirebase()
        // orderProvider.fetchOrders()
      });
      Future.wait({
        cartProvider.getCartItemsFromFirebase(),
        wishlistProvider.getWishListItemsFromFirebase(),
        // orderProvider.fetchOrders()
      });
      // orderProvider.fetchOrders();
    } catch (error) {
      log(error.toString());
    }
    // try {
    //   //fetch many future functions
    //   // Future.wait({productsProvider.fetchProducts()});
    //   await productsProvider.fetchProducts();
    //   await cartProvider.getCartItemsFromFirebase();
    //   await wishlistProvider.getWishListItemsFromFirebase();
    //   await userProvider.fetchUserInfo();
    // } catch (e) {
    //   log(e.toString());
    // }
  }

  @override
  void didChangeDependencies() {
    if (isLoadingProd) {
      fetchFct();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      body: PageView(
        physics:
            const NeverScrollableScrollPhysics(), //DISABLE SCROLL  OR SWIPE
        controller: controller,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 5,
        height: kBottomNavigationBarHeight,
        selectedIndex: currentScreen,
        onDestinationSelected: (index) {
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(currentScreen);
        },
        destinations: [
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.home),
            icon: Icon(IconlyLight.home),
            label: "Home",
          ),
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.search),
            icon: Icon(IconlyLight.search),
            label: "Search",
          ),
          NavigationDestination(
            selectedIcon: const Icon(IconlyBold.bag2),
            icon: Badge(
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                label: Text("${cartProvider.cartItems.length}"),
                child: const Icon(IconlyLight.bag2)),
            label: "Cart",
          ),
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.profile),
            icon: Icon(IconlyLight.profile),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
