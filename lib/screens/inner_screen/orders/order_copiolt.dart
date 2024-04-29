import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/title_text.dart';

class OrderStreamScreen extends StatelessWidget {
  OrderStreamScreen({
    super.key,
    this.docName,
  });
  // final String arrayField1Name; // The name of the first array field
  // final String arrayField2Name; // The name of the second array field
  // final dynamic matchingValue;
  static const routeName = "/orderStreamScreen";
  final String? docName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppNameTextWidget(label: "Orders Screen"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ordersAdvanced')
            .doc(docName)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (!snapshot.hasData) {
                return Text('No data found');
              }
              var document = snapshot.data!;
              var arrayData = document['userOrder'] as List<dynamic>? ?? [];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TitlesTextWidget(label: "SessionId: "),
                            Expanded(
                              child: SubtitleTextWidget(
                                  label: "SessionId: ${document['sessionId']}"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            TitlesTextWidget(label: "OrderStatus: "),
                            SubtitleTextWidget(
                                label: "${document['orderStatus']}"),
                          ],
                        ),
                        SizedBox(
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
                              return Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey)),
                                child:
                                    // Image.network(itemImage),
                                    ListTile(
                                  leading: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: ClipRRect(
                                      child: Image.network(
                                        itemImage,
                                        height: 60,
                                        width: 60,
                                      ),
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      TitlesTextWidget(label: itemName),
                                    ],
                                  ),
                                  subtitle: TitlesTextWidget(
                                    label: "\$ $itemPrice",
                                    color: Colors.blue,
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
