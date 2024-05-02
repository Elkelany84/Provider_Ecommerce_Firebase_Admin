import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/order_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/user_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const AppNameTextWidget(
          label: "Placed Orders",
          fontSize: 22,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("ordersAdvanced")
            .where("userId", isEqualTo: userProvider.uidd)
            .orderBy("orderDate", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(8),
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const TitleTextWidget(
                                label: "OrderDate: ",
                              ),
                              Expanded(
                                child: SubtitleTextWidget(
                                  label: timeago.format(
                                    snapshot.data!.docs[index]["orderDate"]
                                        .toDate(),
                                  ),
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
                                label: "SessionId: ",
                              ),
                              Expanded(
                                child: SubtitleTextWidget(
                                    label: snapshot.data!.docs[index]
                                        ["sessionId"]),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const TitleTextWidget(
                                label: "OrderStatus: ",
                              ),
                              Expanded(
                                child: SubtitleTextWidget(
                                  label: snapshot.data!.docs[index]
                                      ["orderStatus"],
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
                                label: "TotalProducts: ",
                              ),
                              Expanded(
                                child: SubtitleTextWidget(
                                    label: snapshot
                                        .data!.docs[index]["totalProducts"]
                                        .toString(),
                                    color: Colors.blue),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const TitleTextWidget(
                                label: "TotalPrice: ",
                              ),
                              Expanded(
                                child: SubtitleTextWidget(
                                    label:
                                        "\$ ${snapshot.data!.docs[index]["totalPrice"].toString()}",
                                    color: Colors.blue),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const TitleTextWidget(
                                label: "PaymentMethod: ",
                              ),
                              Expanded(
                                child: SubtitleTextWidget(
                                    label: snapshot.data!.docs[index]
                                        ["paymentMethod"],
                                    color: Colors.blue),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      //original futurebuilder to get the data from ordersummary arrayfield using fetchorders in orderProvider
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
      //       return EmptyBag(
      //         title: "No Orders Have Been Placed Yet",
      //         subtitle: "",
      //         imagePath: AssetsManager.orderBag,
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
