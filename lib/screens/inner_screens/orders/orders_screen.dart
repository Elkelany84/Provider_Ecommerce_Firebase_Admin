import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/orders/orders_widget.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/empty_bag.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';

class OrdersScreenFree extends StatefulWidget {
  const OrdersScreenFree({super.key});
  static String routeName = "OrdersScreenFree";

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  bool isEmptyOrders = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleTextWidget(label: "Placed Orders"),
      ),
      body: isEmptyOrders
          ? EmptyBag(
              title: "No Orders Have Been Placed Yet",
              subtile: "",
              imagePath: AssetsManager.orderBag,
              buttonText: "Shop Now",
            )
          : ListView.separated(
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                  child: OrdersWidgetFree(),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 6,
                );
              },
              itemCount: 15),
    );
  }
}
