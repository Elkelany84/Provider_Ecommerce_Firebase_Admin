import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static const String imageUrl =
      'https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png';

  static List<String> categoriesList = [
    'Phones',
    'Laptops',
    'Electronics',
    'Watches',
    'Clothes',
    'Shoes',
    'Books',
    'Cosmetics',
    "Accessories",
  ];
  List catList = [];

  static List<DropdownMenuItem<String>>? get categoriesDropDownList {
    List<DropdownMenuItem<String>>? menuItem =
        List<DropdownMenuItem<String>>.generate(
      categoriesList.length,
      (index) => DropdownMenuItem(
        value: categoriesList[index],
        child: Text(categoriesList[index]),
      ),
    );
    return menuItem;
  }

  StreamBuilder<QuerySnapshot>? getStreams() {
    StreamBuilder(
        stream: FirebaseFirestore.instance.collection("categories").snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data.docs;

            return ListView.builder(
                itemCount: snap.length,
                itemBuilder: (context, index) {
                  catList.add(snap[index]['categoryName']);
                  return catList[index];
                });
          } else {
            return CircularProgressIndicator();
          }
        });
    return null;
  }
}
