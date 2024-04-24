import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/models/product_model.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/products/product_widget.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static String routeName = "SearchScreen";

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

  List<ProductModel> productListSearch = [];
  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final passedCategory =
        ModalRoute.of(context)?.settings.arguments as String?;
    List<ProductModel> productList = passedCategory == null
        ? productsProvider.products
        : productsProvider.findByCategory(categoryName: passedCategory);
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
            label: passedCategory ?? "Search Products",
            fontSize: 22,
          ),
        ),
        body: productList.isEmpty
            ? const Center(
                child: TitleTextWidget(label: "No Products Found!"),
              )
            : StreamBuilder<List<ProductModel>>(
                stream: productsProvider.fetchProductStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(snapshot.error.toString()),
                    );
                  } else if (snapshot.data == null) {
                    return const Center(
                      child: SelectableText("No Products Found!"),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: "Search",
                            prefixIcon: const Icon(
                              Icons.search,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                // setState(() {
                                FocusScope.of(context).unfocus();
                                controller.clear();
                                // });
                              },
                              child: const Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          //Decrease The Performance a little bit
                          onChanged: (value) {
                            // setState(() {
                            productListSearch = productsProvider.searchQuery(
                                // searchText: controller.text,
                                searchText: value,
                                passedList: productList);
                            // });
                          },
                          onSubmitted: (value) {
                            setState(() {
                              productListSearch = productsProvider.searchQuery(
                                  searchText: controller.text,
                                  passedList: productList);
                            });
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        if (controller.text.isNotEmpty &&
                            productListSearch.isEmpty) ...[
                          const Center(
                              child:
                                  TitleTextWidget(label: "No Products Found"))
                        ],
                        Expanded(
                          child: DynamicHeightGridView(
                            // mainAxisSpacing: 12,
                            // crossAxisSpacing: 12,
                            builder: (context, index) {
                              return ProductWidget(
                                productId: controller.text.isNotEmpty
                                    ? productListSearch[index].productId
                                    : productList[index].productId,
                              );
                            },
                            itemCount: controller.text.isNotEmpty
                                ? productListSearch.length
                                : productList.length,
                            crossAxisCount: 2,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
