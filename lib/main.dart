import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hadi_ecommerce_firebase_admin/constants/theme_data.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/cart_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/categories_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/theme_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/user_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/auth/forgot_password.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/auth/login_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/auth/register.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/cart/cart_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/orders/orders_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/orders/payment_success.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/product_details.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/viewed_recently.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/wishlist.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/search_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/root_screen.dart';
import 'package:provider/provider.dart';

import 'providers/order_provider.dart';
import 'providers/viewed_recently_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/inner_screens/orders/payment_screen.dart';
import 'screens/inner_screens/personal_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyCUfPySK2s6fR87-DmhzkNTTyEwbHvjK-0",
            appId: "1:493433453225:android:3c381866aa7848ca6207b8",
            messagingSenderId: "493433453225",
            projectId: "hadishopsmarprovideradminpanel",
            storageBucket: "hadishopsmarprovideradminpanel.appspot.com",
          ),
        )
      : await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return ThemeProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return ProductsProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return CartProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return WishlistProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return ViewedProdProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return UserProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return OrderProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return CategoriesProvider();
        }),

        // ChangeNotifierProvider(create: (_) {
        //   return GoogleProvider();
        // }),
      ],
      child: Consumer<ThemeProvider>(
        builder: (builder, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ShopSmart',
            theme: Styles.themeData(
                isDarkTheme: themeProvider.getIsDarkTheme, context: context),
            home: const RootScreen(),
            routes: {
              RootScreen.routeName: (context) => const RootScreen(),
              ProductDetails.routeName: (context) => const ProductDetails(),
              SearchScreen.routeName: (context) => const SearchScreen(),
              ViewedRecentlyScreen.routeName: (context) =>
                  const ViewedRecentlyScreen(),
              OrdersScreenFree.routeName: (context) => const OrdersScreenFree(),
              WishListScreen.routeName: (context) => const WishListScreen(),
              LoginScreen.routeName: (context) => const LoginScreen(),
              RegisterScreen.routeName: (context) => const RegisterScreen(),
              ForgotPasswordScreen.routeName: (context) =>
                  const ForgotPasswordScreen(),
              PaymentScreen.routeName: (context) => const PaymentScreen(),
              PersonalProfile.routeName: (context) => const PersonalProfile(),
              CartScreen.routeName: (context) => const CartScreen(),
              PaymentSuccess.routeName: (context) => const PaymentSuccess(),
            },
          );
        },
      ),
    );
  }
}
