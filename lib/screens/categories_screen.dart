import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/models/categories_model.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/categories_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/inner_screen/add_category_modelsheet.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/category_widget.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../widgets/title_text.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/CategoriesScreen';

  const CategoriesScreen({
    super.key,
    // required this.categoryId,
  });

  // final String categoryId;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    // countCategories();
    // fetchFct();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<ProductModel> productListSearch = [];
  @override
  Widget build(BuildContext context) {
    final categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: true);
    // List<ProductModel> productList =
    //      categoriesProvider.categories
    //     : categoriesProvider.findByCategory(categoryName: passedCategory);
    final String categoryId;
    // final getCurrCategory =
    //     categoriesProvider.findByCategoryId(widget.categoryId);

    List<CategoryModel> categoriesList = categoriesProvider.categories;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.purpleAccent,
            onPressed: () {
              //create modelbottomsheet to add category
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (builder) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddCategoryBottomSheet(),
                    );
                  });
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
          appBar: AppBar(
            // leading: Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Image.asset(
            //     AssetsManager.shoppingCart,
            //   ),
            // ),
            title: Consumer<CategoriesProvider>(
              builder: (context, categoriesProvider, child) => TitlesTextWidget(
                  label: "All Categories ( ${categoriesProvider.quer} )"),
            ),
            // label: "All Categories ( $quer )"),
          ),
          body: categoriesList.isEmpty
              ? Center(
                  child: TitlesTextWidget(label: "No Categories Found!"),
                )
              : //create streambuilder to fetch categories from firebase
              category_widget(
                  categoriesProvider: categoriesProvider,
                ),
          // : StreamBuilder<List<ProductModel>>(
          //     stream: categoriesProvider.fetchCategoryStream(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const MaterialApp(
          //           debugShowCheckedModeBanner: false,
          //           home: Center(
          //             child: CircularProgressIndicator(),
          //           ),
          //         );
          //       } else if (snapshot.hasError) {
          //         return Center(
          //           child: SelectableText(snapshot.error.toString()),
          //         );
          //       } else if (snapshot.data == null) {
          //         return Center(
          //           child: SelectableText("No Products Found!"),
          //         );
          //       }
          //       return Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Column(
          //           children: [
          //             TextField(
          //               controller: searchTextController,
          //               decoration: InputDecoration(
          //                 hintText: "Search",
          //                 prefixIcon: Icon(
          //                   Icons.search,
          //                 ),
          //                 suffixIcon: GestureDetector(
          //                   onTap: () {
          //                     searchTextController.clear();
          //                     FocusScope.of(context).unfocus();
          //                   },
          //                   child: Icon(
          //                     Icons.clear,
          //                     color: Colors.red,
          //                   ),
          //                 ),
          //               ),
          //               //Decrease The Performance a little bit
          //               onChanged: (value) {
          //                 // setState(() {
          //                 productListSearch = productsProvider.searchQuery(
          //                     searchText: searchTextController.text,
          //                     passedList: productList);
          //                 // });
          //               },
          //               onSubmitted: (value) {
          //                 setState(() {
          //                   productListSearch =
          //                       productsProvider.searchQuery(
          //                           searchText: searchTextController.text,
          //                           passedList: productList);
          //                 });
          //               },
          //             ),
          //             SizedBox(
          //               height: 15,
          //             ),
          //             if (searchTextController.text.isNotEmpty &&
          //                 productListSearch.isEmpty) ...[
          //               Center(
          //                   child: TitlesTextWidget(
          //                       label: "No Products Found"))
          //             ],
          //             Expanded(
          //               child: DynamicHeightGridView(
          //                 // mainAxisSpacing: 12,
          //                 // crossAxisSpacing: 12,
          //                 builder: (context, index) {
          //                   return ProductWidget(
          //                     productId: searchTextController.text.isEmpty
          //                         ? productList[index].productId
          //                         : productListSearch[index].productId,
          //                   );
          //                 },
          //                 itemCount: searchTextController.text.isEmpty
          //                     ? productList.length
          //                     : productListSearch.length,
          //                 crossAxisCount: 2,
          //               ),
          //             ),
          //           ],
          //         ),
          //       );
          //     }),
        ));
  }
}

// class category_widget extends StatelessWidget {
//   const category_widget({
//     super.key,
//     required this.categoriesProvider,
//   });
//
//   final CategoriesProvider categoriesProvider;
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       // Step 2: Create a Stream
//       stream: FirebaseFirestore.instance.collection('categories').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }
//         switch (snapshot.connectionState) {
//           case ConnectionState.waiting:
//             return CircularProgressIndicator();
//           default:
//             // Step 3: Build UI based on the stream
//             return ListView(
//               children: snapshot.data!.docs.map((DocumentSnapshot document) {
//                 return Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Container(
//                     height: 90,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all()),
//                     child: Card(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           children: [
//                             Image.network(document['categoryImage']),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Text(
//                               document['categoryName'],
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Spacer(),
//                             IconButton(
//                               onPressed: () {
//                                 showModalBottomSheet(
//                                     isScrollControlled: true,
//                                     context: context,
//                                     builder: (builder) {
//                                       return Padding(
//                                         padding: EdgeInsets.only(
//                                             bottom: MediaQuery.of(context)
//                                                 .viewInsets
//                                                 .bottom),
//                                         child: EditCategoryBottomSheet(
//                                             // categoryModel:
//                                             //     getCurrCategory,
//                                             ),
//                                       );
//                                     });
//                                 // categoriesProvider
//                                 //     .deleteCategory(document.id);
//                               },
//                               icon: Icon(
//                                 Icons.edit,
//                                 color: Colors.purpleAccent,
//                                 size: 30,
//                               ),
//                             ),
//                             //create icon to delete category from firebase
//                             IconButton(
//                               onPressed: () {
//                                 MyAppFunctions.showErrorOrWarningDialog(
//                                     isError: false,
//                                     context: context,
//                                     subtitle: "Delete Category",
//                                     fct: () {
//                                       categoriesProvider
//                                           .deleteCategory(document.id);
//                                     });
//                                 // categoriesProvider
//                                 //     .deleteCategory(document.id);
//                               },
//                               icon: Icon(
//                                 Icons.delete,
//                                 color: Colors.red,
//                                 size: 30,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             );
//         }
//       },
//     );
//   }
// }
