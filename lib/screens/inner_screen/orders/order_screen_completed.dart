import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/order_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/inner_screen/orders/order_details.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrdersScreenCompleted extends StatefulWidget {
  const OrdersScreenCompleted({super.key});
  static String routeName = "OrdersScreenCompleted";

  @override
  State<OrdersScreenCompleted> createState() => _OrdersScreenCompletedState();
}

class _OrdersScreenCompletedState extends State<OrdersScreenCompleted> {
  // bool isEmptyOrders = false;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    Color _getTextColor(String textValue) {
      // Define your logic to return different colors based on textValue
      if (textValue == 'Visa') {
        return Colors.red;
      } else if (textValue == 'Cash') {
        return Colors.green;
      }
      // Add more conditions as needed
      return Colors.black; // Default color
    }

    return Scaffold(
      appBar: AppBar(
        title: const AppNameTextWidget(label: "Placed Orders"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("ordersAdvanced")
            .where("orderStatus", isEqualTo: "Completed")
            .orderBy("orderDate", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    // splashColor: Colors.amber,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderStreamScreen(
                                  docName: snapshot.data!.docs[index]
                                      ["sessionId"],
                                  userId: snapshot.data!.docs[index]["userId"],
                                )),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      height: 240,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                TitlesTextWidget(
                                  label: "SessionId: ",
                                ),
                                Expanded(
                                  child: SubtitleTextWidget(
                                      label: snapshot.data!.docs[index]
                                          ["sessionId"]),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                TitlesTextWidget(
                                  label: "OrderDate: ",
                                ),
                                Expanded(
                                  child: SubtitleTextWidget(
                                      label: timeago.format(snapshot
                                          .data!.docs[index]["orderDate"]
                                          .toDate())),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                TitlesTextWidget(
                                  label: "OrderStatus: ",
                                ),
                                Expanded(
                                  child: SubtitleTextWidget(
                                      label: snapshot.data!.docs[index]
                                          ["orderStatus"]),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                TitlesTextWidget(
                                  label: "TotalProducts: ",
                                ),
                                Expanded(
                                  child: SubtitleTextWidget(
                                    label: snapshot
                                        .data!.docs[index]["totalProducts"]
                                        .toString(),
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                TitlesTextWidget(
                                  label: "TotalPrice: ",
                                ),
                                Expanded(
                                  child: SubtitleTextWidget(
                                    label: snapshot
                                        .data!.docs[index]["totalPrice"]
                                        .toString(),
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                TitlesTextWidget(
                                  label: "PaymentMethod: ",
                                ),
                                Expanded(
                                  child: SubtitleTextWidget(
                                    label: snapshot.data!.docs[index]
                                        ["paymentMethod"],
                                    color: _getTextColor(snapshot
                                        .data!.docs[index]["paymentMethod"]),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: kBottomNavigationBarHeight - 10,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(12),
                                  backgroundColor: Colors.purpleAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('ordersAdvanced')
                                      .doc(snapshot.data!.docs[index]
                                          ["sessionId"])
                                      .update({
                                    'orderStatus': 'Processing',
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Mark as Processing",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            )

                            // Row(
                            //   children: [
                            //     TitlesTextWidget(
                            //       label: "userId: ",
                            //     ),
                            //     Expanded(
                            //       child: SubtitleTextWidget(
                            //           label: snapshot.data!.docs[index]
                            //               ["userId"]),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      // FutureBuilder(
      //   future: orderProvider.fetchOrders(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //           child: CircularProgressIndicator(
      //         color: Colors.red,
      //       ));
      //     } else if (snapshot.hasError) {
      //       return Center(child: SelectableText(snapshot.error.toString()));
      //     } else if (!snapshot.hasData || orderProvider.getOrders.isEmpty) {
      //       return EmptyBagWidget(
      //         title: "No Orders Have Been Placed Yet",
      //         subtitle: "",
      //         imagePath: AssetsManager.order,
      //         buttonText: "Shop Now",
      //       );
      //     }
      //     return ListView.separated(
      //         itemBuilder: (context, index) {
      //           return Padding(
      //             padding:
      //                 const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
      //             child: OrdersWidgetFree(
      //               orderSummary: orderProvider.getOrders[index],
      //               // ordersModelAdvanced:
      //               //     orderProvider.newOrders.values.toList()[index],
      //             ),
      //           );
      //         },
      //         separatorBuilder: (context, index) {
      //           return const Divider(
      //             thickness: 6,
      //           );
      //         },
      //         itemCount: orderProvider.getOrders.length
      //         // itemCount: snapshot.data!.length
      //         );
      //   },
      // ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../../../../widgets/empty_bag.dart';
// import '../../../services/assets_manager.dart';
// import '../../../widgets/title_text.dart';
// import 'orders_widget.dart';
//
// class OrdersScreenFree extends StatefulWidget {
//   static const routeName = '/OrderScreen';
//
//   const OrdersScreenFree({Key? key}) : super(key: key);
//
//   @override
//   State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
// }
//
// class _OrdersScreenFreeState extends State<OrdersScreenFree> {
//   bool isEmptyOrders = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const TitlesTextWidget(
//             label: 'Placed orders',
//           ),
//         ),
//         body: isEmptyOrders
//             ? EmptyBagWidget(
//                 imagePath: AssetsManager.order,
//                 title: "No orders has been placed yet",
//                 subtitle: "",
//               )
//             : ListView.separated(
//                 itemCount: 15,
//                 itemBuilder: (ctx, index) {
//                   return const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
//                     child: OrdersWidgetFree(),
//                   );
//                 },
//                 separatorBuilder: (BuildContext context, int index) {
//                   return const Divider(
//                       // thickness: 8,
//                       // color: Colors.red,
//                       );
//                 },
//               ));
//   }
// }
