import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/product_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.shoppingCart),
          ),
          title: AppNameTextWidget(
            label: "Search Products",
            fontSize: 22,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      controller.clear();
                      FocusScope.of(context).unfocus();
                    },
                    child: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  ),
                ),
                onSubmitted: (value) {
                  controller.text = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: DynamicHeightGridView(
                  // mainAxisSpacing: 12,
                  // crossAxisSpacing: 12,
                  builder: (context, index) {
                    return ProductWidget(
                      productId: productsProvider.getProducts[index].productId,
                    );
                  },
                  itemCount: productsProvider.getProducts.length,
                  crossAxisCount: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
