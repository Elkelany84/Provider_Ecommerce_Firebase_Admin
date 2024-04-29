import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/models/order_model.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/order_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrdersWidgetFree extends StatefulWidget {
  const OrdersWidgetFree({super.key, required this.orderSummary});
  // final OrdersModelAdvanced ordersModelAdvanced;
  final OrderSummary orderSummary;

  @override
  State<OrdersWidgetFree> createState() => _OrdersWidgetFreeState();
}

class _OrdersWidgetFreeState extends State<OrdersWidgetFree> {
  bool customIcon = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final orderUserProvider =
        Provider.of<OrderProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // final f = DateFormat(' dd-MM-yyyy', 'ar');
    // var v = widget.ordersModelAdvanced.orderDate;
    // var myValue = v;
    // var end = f.format(DateTime.fromMillisecondsSinceEpoch(myValue as int));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Row(
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(12),
          //   child: FancyShimmerImage(
          //     imageUrl: widget.ordersModelAdvanced.imageUrl,
          //     height: size.width * 0.25,
          //     width: size.width * 0.25,
          //   ),
          // ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TitleTextWidget(
                          label: "SessionId: ${widget.orderSummary.sessionId}",
                          // label: widget.ordersModelAdvanced.productTitle,
                          maxLines: 2,
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const TitleTextWidget(
                        label: "Total Price: ",
                        fontSize: 15,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: SubtitleTextWidget(
                          label:
                              // "",
                              "\$ ${widget.orderSummary.totalPrice}",
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const TitleTextWidget(
                        label: "Total Products: ",
                        fontSize: 15,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SubtitleTextWidget(
                        label: widget.orderSummary.totalProducts,
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const TitleTextWidget(
                        label: "Order Date: ",
                        fontSize: 15,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SubtitleTextWidget(
                        label: timeago
                            .format(widget.orderSummary.orderDate.toDate()),
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const TitleTextWidget(
                        label: "Payment Method: ",
                        fontSize: 15,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SubtitleTextWidget(
                        label: widget.orderSummary.paymentMethod,
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  // ExpansionTile(
                  //   title: const TitleTextWidget(
                  //     label: "Products: ",
                  //     fontSize: 15,
                  //   ),
                  //   trailing: Icon(customIcon
                  //       ? Icons.arrow_drop_down_circle
                  //       : Icons.arrow_drop_up),
                  //   onExpansionChanged: (bool value) {
                  //     setState(() {
                  //       customIcon = value;
                  //     });
                  //   },
                  //   children: [
                  //     StreamBuilder<QuerySnapshot>(
                  //       stream: FirebaseFirestore.instance
                  //           .collection('orderFees')
                  //           .snapshots(),
                  //       builder: (context, snapshot) {
                  //         if (snapshot.hasError) {
                  //           return Text('Error: ${snapshot.error}');
                  //         }
                  //         return SingleChildScrollView(
                  //             child: SizedBox(
                  //                 height: 50,
                  //                 child: ListView(
                  //                   children: snapshot.data!.docs
                  //                       .map((DocumentSnapshot document) {
                  //                     return Text(document["fees"]);
                  //                   }).toList(),
                  //                 )));
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     TitleTextWidget(
                  //       label: "Qty: ",
                  //       fontSize: 15,
                  //     ),
                  //     SizedBox(
                  //       width: 5,
                  //     ),
                  //     Flexible(
                  //       child: SubtitleTextWidget(
                  //         label: widget.ordersModelAdvanced.quantity,
                  //         fontSize: 15,
                  //         color: Colors.blue,
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Row(
                  //   children: [
                  //     TitleTextWidget(
                  //       label: "Order Date: ",
                  //       fontSize: 15,
                  //     ),
                  //     SizedBox(
                  //       width: 5,
                  //     ),
                  //     Flexible(
                  //       child: SubtitleTextWidget(
                  //         label: timeago.format(
                  //             widget.ordersModelAdvanced.orderDate.toDate()),
                  //         // widget.ordersModelAdvanced.orderDate.toString(),
                  //         fontSize: 15,
                  //         color: Colors.blue,
                  //       ),
                  //     )
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
