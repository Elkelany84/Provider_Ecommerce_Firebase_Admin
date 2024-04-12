import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hadi_ecommerce_firebase_admin/models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrdersModelAdvanced> orders = [];
  List<OrdersModelAdvanced> get getOrders => orders;

  //fetch orders from firebase
  Future<List<OrdersModelAdvanced>> fetchOrders() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    final uid = user!.uid;
    try {
      final ordersDb = FirebaseFirestore.instance
          .collection("ordersAdvanced")
          .where("userId", isEqualTo: uid)
          .orderBy("orderDate");
      await ordersDb.get().then((orderSnapshot) {
        orders.clear();
        for (var element in orderSnapshot.docs) {
          orders.insert(
            0,
            OrdersModelAdvanced(
                orderId: element.get("orderId"),
                userId: element.get("userId"),
                productId: element.get("productId"),
                productTitle: element.get("productTitle"),
                userName: element.get("userName"),
                price: element.get("price").toString(),
                imageUrl: element.get("imageUrl"),
                quantity: element.get("quantity").toString(),
                orderDate: element.get("orderDate")),
          );
        }
      });
      return orders;
    } catch (error) {
      rethrow;
    }
  }
}
