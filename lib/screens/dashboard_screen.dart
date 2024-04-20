import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/models/dashboard_buttons_model.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/dashboard_btn.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../services/assets_manager.dart';
import '../widgets/title_text.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/DashboardScreen';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  bool isLoadingProd = true;

  //very important to fetch products and make stream function to work
  Future<void> fetchFct() async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    // final categoryProvider =
    //     Provider.of<CategoriesProvider>(context, listen: false);
    try {
      //fetch many future functions
      // Future.wait({productsProvider.fetchProducts()});
      await productsProvider.fetchProducts();
      await productsProvider.countProducts();
      // await categoryProvider.fetchCategories();
    } catch (e) {
      log(e.toString());
    }
  }

  final CollectionReference<Map<String, dynamic>> productList =
      FirebaseFirestore.instance.collection('products');
  int? quer;
  Future<int?> countProducts() async {
    AggregateQuerySnapshot query = await productList.count().get();
    // debugPrint('The number of products: ${query.count}');
    quer = query.count;
    return query.count;
  }

  @override
  void didChangeDependencies() {
    if (isLoadingProd) {
      fetchFct();
      countProducts();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(label: "Dashboard Screen"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
        actions: [
          IconButton(
            onPressed: () {
              themeProvider.setDarkTheme(
                  themeValue: !themeProvider.getIsDarkTheme);
            },
            icon: Icon(themeProvider.getIsDarkTheme
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(
          //we add context because we had to add it to list
          DashboardButtonsModel.dashboardBtnsList(context).length,
          (index) => DashboardButtonsWidget(
            text: DashboardButtonsModel.dashboardBtnsList(context)[index].text,
            imagePath: DashboardButtonsModel.dashboardBtnsList(context)[index]
                .imagePath,
            onPressed: DashboardButtonsModel.dashboardBtnsList(context)[index]
                .onPressed,
          ),
        ),
      ),
    );
  }
}
