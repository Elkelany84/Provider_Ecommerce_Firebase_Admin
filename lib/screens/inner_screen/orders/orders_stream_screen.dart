// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hadi_ecommerce_firebase_adminpanel/widgets/app_name_text.dart';
// import 'package:hadi_ecommerce_firebase_adminpanel/widgets/subtitle_text.dart';
// import 'package:hadi_ecommerce_firebase_adminpanel/widgets/title_text.dart';
//
// class OrderStreamScreen extends StatelessWidget {
//   const OrderStreamScreen({super.key});
//   static const routeName = "/orderStreamScreen";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: AppNameTextWidget(label: "OrdersScreen"),
//         ),
//         body: StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection('ordersAdvanced')
//               .where("orderSummary", arrayContains: "Processing")
//               // .orderBy("orderDate", descending: true)
//               .snapshots(),
//           builder:
//               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             }
//             switch (snapshot.connectionState) {
//               case ConnectionState.waiting:
//                 return Text('Loading...');
//               default:
//                 // Create a list of ListTiles for each item in each document's 'items' array
//                 List<Widget> listTiles = [];
//                 snapshot.data!.docs.forEach((DocumentSnapshot document) {
//                   Map<String, dynamic> data =
//                       document.data() as Map<String, dynamic>;
//                   List<dynamic> items = data['orderSummary'] as List<dynamic>;
//
//                   items.forEach((item) {
//                     listTiles.add(Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(color: Colors.grey)),
//                         child: ListTile(
//                           title: TitlesTextWidget(label: item['sessionId']),
//                           subtitle: SubtitleTextWidget(
//                             label: 'orderStatus: ${item['orderStatus']}',
//                           ),
//                         ),
//                       ),
//                     ));
//                   });
//
//                   // Remove items with paymentMethod = 1 (cash on delivery)
//                   items.removeWhere((element) => element['totalPrice'] == 3232);
//                 });
//
//                 return ListView(children: listTiles);
//             }
//           },
//         ));
//   }
// }
//
// // StreamBuilder(
// //   stream:
// //       FirebaseFirestore.instance.collection("ordersAdvanced").snapshots(),
// //   builder: (context, snapshot) {
// //     if (snapshot.hasData) {
// //       return ListView.builder(
// //         itemCount: snapshot.data!.docs.length,
// //         itemBuilder: (context, index) {
// //           return ListTile(
// //             title: Text(snapshot.data!.docs[index]["sessionId"]),
// //             subtitle: Text(snapshot.data!.docs[index]["userId"]),
// //           );
// //         },
// //       );
// //     } else {
// //       return Center(
// //         child: CircularProgressIndicator(),
// //       );
// //     }
// //   },
// // ),
//
// //     //streambuilder to show subfields in array in firebase
// //     StreamBuilder(
// //   stream:
// //       FirebaseFirestore.instance.collection('ordersAdvanced').snapshots(),
// //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
// //     if (snapshot.hasError) {
// //       return Text('Error: ${snapshot.error}');
// //     }
// //     switch (snapshot.connectionState) {
// //       case ConnectionState.waiting:
// //         return Text('Loading...');
// //       default:
// //         return ListView(
// //             children:
// //                 snapshot.data!.docs.map((DocumentSnapshot document) {
// //           Map<String, dynamic> data =
// //               document.data() as Map<String, dynamic>;
// //           // Accessing the array field 'items'
// //           List<dynamic> items = data['orderSummary'] as List<dynamic>;
// //           return ExpansionTile(
// //             title: Text('Order ID: ${document.id}'),
// //             // title: Text(snapshot.data.docs),
// //             children: items.map((item) {
// //               // Assuming each item in the array is a map with 'name' and 'quantity'
// //               return ListTile(
// //                 title: Text(item['orderStatus']),
// //                 subtitle: Text('Status: ${item['orderStatus']}'),
// //               );
// //             }).toList(),
// //           );
// //         }).toList());
// //     }
// //   },
// // ),
