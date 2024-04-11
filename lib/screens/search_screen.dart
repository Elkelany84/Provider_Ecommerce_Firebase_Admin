import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/products_provider.dart';
import '../widgets/product_widget.dart';
import '../widgets/title_text.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<ProductModel> productListSearch = [];
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;
    List<ProductModel> productList = passedCategory == null
        ? productsProvider.products
        : productsProvider.findByCategory(categoryName: passedCategory);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          // leading: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Image.asset(
          //     AssetsManager.shoppingCart,
          //   ),
          // ),
          title: TitlesTextWidget(label: passedCategory ?? "Search products"),
        ),
        body: productList.isEmpty
            ? Center(
                child: TitlesTextWidget(label: "No Products Found!"),
              )
            : StreamBuilder<List<ProductModel>>(
                stream: productsProvider.fetchProductStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const MaterialApp(
                      debugShowCheckedModeBanner: false,
                      home: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(snapshot.error.toString()),
                    );
                  } else if (snapshot.data == null) {
                    return Center(
                      child: SelectableText("No Products Found!"),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: searchTextController,
                          decoration: InputDecoration(
                            hintText: "Search",
                            prefixIcon: Icon(
                              Icons.search,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                searchTextController.clear();
                                FocusScope.of(context).unfocus();
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          //Decrease The Performance a little bit
                          onChanged: (value) {
                            setState(() {
                              productListSearch = productsProvider.searchQuery(
                                  searchText: searchTextController.text,
                                  passedList: productList);
                            });
                          },
                          onSubmitted: (value) {
                            setState(() {
                              productListSearch = productsProvider.searchQuery(
                                  searchText: searchTextController.text,
                                  passedList: productList);
                            });
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        if (searchTextController.text.isNotEmpty &&
                            productListSearch.isEmpty) ...[
                          Center(
                              child:
                                  TitlesTextWidget(label: "No Products Found"))
                        ],
                        Expanded(
                          child: DynamicHeightGridView(
                            // mainAxisSpacing: 12,
                            // crossAxisSpacing: 12,
                            builder: (context, index) {
                              return ProductWidget(
                                productId: searchTextController.text.isEmpty
                                    ? productList[index].productId
                                    : productListSearch[index].productId,
                              );
                            },
                            itemCount: searchTextController.text.isEmpty
                                ? productList.length
                                : productListSearch.length,
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
