import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/order_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/title_text.dart';
import 'package:provider/provider.dart';

class OrdersScreenFree extends StatefulWidget {
  const OrdersScreenFree({super.key});
  static String routeName = "OrdersScreenFree";

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  // bool isEmptyOrders = false;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(label: "Placed Orders"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("ordersAdvanced")
            .where("orderStatus", isEqualTo: "Processing")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)),
                    child: ListTile(
                      title: Row(
                        children: [
                          TitlesTextWidget(
                            label: "SessionId: ",
                          ),
                          Expanded(
                            child: SubtitleTextWidget(
                                label: snapshot.data!.docs[index]["sessionId"]),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          TitlesTextWidget(
                            label: "userId: ",
                          ),
                          Expanded(
                            child: SubtitleTextWidget(
                                label: snapshot.data!.docs[index]["userId"]),
                          ),
                        ],
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
