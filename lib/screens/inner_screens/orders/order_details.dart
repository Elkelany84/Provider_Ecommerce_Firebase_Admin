import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';

class OrderStreamScreen extends StatelessWidget {
  OrderStreamScreen({
    super.key,
    this.docName,
    // this.userId,
  });
  // final String arrayField1Name; // The name of the first array field
  // final String arrayField2Name; // The name of the second array field
  // final dynamic matchingValue;
  static const routeName = "/orderStreamScreen";
  final String? docName;
  // final String? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppNameTextWidget(
          label: "Processing Orders",
          fontSize: 30,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('ordersAdvanced')
                  .doc(docName)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (!snapshot.hasData) {
                      return const Text('No data found');
                    }
                    var document = snapshot.data!;
                    var arrayData =
                        document['userOrder'] as List<dynamic>? ?? [];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const TitleTextWidget(label: "SessionId: "),
                                  Expanded(
                                    child: SubtitleTextWidget(
                                        label: "${document['sessionId']}"),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const TitleTextWidget(
                                      label: "Order Status: "),
                                  SubtitleTextWidget(
                                      label: "${document['orderStatus']}"),
                                  const Spacer(),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: arrayData.length,
                                  itemBuilder: (context, index) {
                                    var item = arrayData[index];
                                    // Assuming each item in the array is a Map
                                    var itemName = item['productTitle'];
                                    var itemPrice = item['price'].toString();
                                    var itemImage = item['imageUrl'];
                                    var itemQty = item['quantity'];
                                    return Container(
                                      padding: const EdgeInsets.only(top: 7),
                                      margin: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child:
                                          // Image.network(itemImage),
                                          ListTile(
                                        leading: ClipRRect(
                                          child: FancyShimmerImage(
                                            imageUrl: itemImage,
                                            height: 80,
                                            width: 60,
                                            boxFit: BoxFit.contain,
                                          ),
                                        ),
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: TitleTextWidget(
                                                label: itemName,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TitleTextWidget(
                                              label: "\$ $itemPrice",
                                              color: Colors.blue,
                                            ),
                                            TitleTextWidget(
                                              label: "Qty: $itemQty",
                                              color: Colors.blue,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
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
