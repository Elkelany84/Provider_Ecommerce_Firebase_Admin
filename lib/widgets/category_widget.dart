import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/categories_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/search_screen.dart';

class category_widget extends StatelessWidget {
  const category_widget({
    super.key,
    required this.categoriesProvider,
    // required this.categoryId,
  });

  final CategoriesProvider categoriesProvider;
  // final String categoryId;

  @override
  Widget build(BuildContext context) {
    // final getCurrCategory = categoriesProvider.findByCategoryId(categoryId);
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
      // Step 2: Create a Stream
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          default:
            // Step 3: Build UI based on the stream
            return GridView.count(
              crossAxisCount: 2,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SearchScreen.routeName,
                          arguments: document['categoryName']);
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            height: size.height * 0.25,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FancyShimmerImage(
                                  imageUrl: document['categoryImage'],
                                  height: size.height * 0.18,
                                  width: double.infinity,
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          document['categoryName'],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
