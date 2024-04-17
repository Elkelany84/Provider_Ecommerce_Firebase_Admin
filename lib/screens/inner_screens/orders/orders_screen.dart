import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/order_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/orders/orders_widget.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/empty_bag.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
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
          title: TitleTextWidget(label: "Placed Orders"),
        ),
        body: FutureBuilder(
          future: orderProvider.fetchOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.red,
              ));
            } else if (snapshot.hasError) {
              return Center(child: SelectableText(snapshot.error.toString()));
            } else if (!snapshot.hasData || orderProvider.getOrders.isEmpty) {
              return EmptyBag(
                title: "No Orders Have Been Placed Yet",
                subtitle: "",
                imagePath: AssetsManager.orderBag,
                buttonText: "Shop Now",
              );
            }
            return ListView.separated(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    child: OrdersWidgetFree(
                      ordersModelAdvanced: orderProvider.getOrders[index],
                      // ordersModelAdvanced:
                      //     orderProvider.newOrders.values.toList()[index],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 6,
                  );
                },
                itemCount: orderProvider.getOrders.length
                // itemCount: snapshot.data!.length
                );
          },
        ));
  }
}
