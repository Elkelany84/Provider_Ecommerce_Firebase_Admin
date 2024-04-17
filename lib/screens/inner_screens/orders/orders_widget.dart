import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/models/order_model.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';

class OrdersWidgetFree extends StatefulWidget {
  const OrdersWidgetFree({super.key, required this.ordersModelAdvanced});
  final OrdersModelAdvanced ordersModelAdvanced;

  @override
  State<OrdersWidgetFree> createState() => _OrdersWidgetFreeState();
}

class _OrdersWidgetFreeState extends State<OrdersWidgetFree> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // final f = DateFormat(' dd-MM-yyyy', 'ar');
    // var v = widget.ordersModelAdvanced.orderDate;
    // var myValue = v;
    // var end = f.format(DateTime.fromMillisecondsSinceEpoch(myValue as int));
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
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
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Flexible(
                      //   child: TitleTextWidget(
                      //     label:
                      //         "OrderId: ${widget.ordersModelAdvanced.orderId}",
                      //     // label: widget.ordersModelAdvanced.productTitle,
                      //     maxLines: 2,
                      //     fontSize: 15,
                      //   ),
                      // ),
                      // IconButton(
                      //   onPressed: () {},
                      //   icon: Icon(
                      //     Icons.clear,
                      //     color: Colors.red,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      TitleTextWidget(
                        label: "Total Price: ",
                        fontSize: 15,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: SubtitleTextWidget(
                          label:
                              // "",
                              "\$ ${widget.ordersModelAdvanced.productTitle}",
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
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
