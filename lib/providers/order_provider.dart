import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hadi_ecommerce_firebase_admin/models/order_model.dart';
import 'package:hadi_ecommerce_firebase_admin/models/order_user_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrderSummary> orders = [];
  List<OrderSummary> get getOrders => orders;

  // final Map<String, OrdersModelAdvanced> _orders = {};
  // Map<String, OrdersModelAdvanced> get newOrders => _orders;

  OrderUserModel? _orderUserModel;
  //getters
  OrderUserModel? get getUserModel => _orderUserModel;

  //fetch orders from firebase original way in course
  // Future<List<OrdersModelAdvanced>> fetchOrders() async {
  //   final auth = FirebaseAuth.instance;
  //   User? user = auth.currentUser;
  //   final uid = user!.uid;
  //   try {
  //     final ordersDb = FirebaseFirestore.instance
  //         .collection("ordersAdvanced")
  //         .where("userId", isEqualTo: uid)
  //         .orderBy("orderDate");
  //     await ordersDb.get().then((orderSnapshot) {
  //       orders.clear();
  //       // original function
  //       for (var element in orderSnapshot.docs) {
  //         orders.insert(
  //           0,
  //           OrdersModelAdvanced(
  //               orderId: element.get("orderId"),
  //               userId: element.get("userId"),
  //               productId: element.get("productId"),
  //               productTitle: element.get("productTitle"),
  //               userName: element.get("userName"),
  //               totalPrice: element.get("totalPrice").toString(),
  //               imageUrl: element.get("imageUrl"),
  //               quantity: element.get("quantity").toString(),
  //               sessionId: element.get("sessionId"),
  //               orderDate: element.get("orderDate")),
  //         );
  //       }
  //     });
  //     return orders;
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

//customize fetch orders from firebase original way in course
//   Future<void> fetchOrderss() async {
//     final auth = FirebaseAuth.instance;
//     final User? user = auth.currentUser;
//     if (user == null) {
//       return;
//     }
//     try {
//       final usersDb = FirebaseFirestore.instance.collection("ordersAdvanced");
//
//       final userDoc = await usersDb.doc(user.uid).get();
//       final data = userDoc.data();
//       if (data == null || !data.containsKey("userOrder")) {
//         return;
//       }
//       final length = userDoc.get("userOrder").length;
//       for (int index = 0; index < length; index++) {
//         _orders.putIfAbsent(
//             userDoc.get("userOrder")[index]["orderId"],
//             () => OrdersModelAdvanced(
//                 productId: userDoc.get("userOrder")[index]["productId"],
//                 orderId: userDoc.get("userOrder")[index]["orderId"],
//                 userId: userDoc.get("userOrder")[index]["userId"],
//                 productTitle: userDoc.get("userOrder")[index]["productTitle"],
//                 userName: userDoc.get("userOrder")[index]["userName"],
//                 totalPrice:
//                     userDoc.get("userOrder")[index]["totalPrice"].toString(),
//                 imageUrl: userDoc.get("userOrder")[index]["imageUrl"],
//                 orderDate: userDoc.get("userOrder")[index]["orderDate"],
//                 sessionId: userDoc.get("userOrder")[index]["sessionId"],
//                 quantity:
//                     userDoc.get("userOrder")[index]["quantity"].toString()));
//       }
//     } catch (error) {
//       rethrow;
//     }
//     notifyListeners();
//   }

  // fetch orders from firebase advanced way
  Future<List<OrderSummary>> fetchOrders() async {
    final auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) {
      orders.clear();
    }
    try {
      final usersDb = FirebaseFirestore.instance.collection("ordersAdvanced");

      final userDoc = await usersDb.doc(user!.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("orderSummary")) return [];

      final length = userDoc.get("orderSummary").length;
      orders.clear();
      for (int index = 0; index < length; index++) {
        orders.insert(
            0,
            //Original working one
            //     OrdersModelAdvanced(
            //         productId: userDoc.get("userOrder")[index]["productId"],
            //         orderId: userDoc.get("userOrder")[index]["orderId"],
            //         userId: userDoc.get("userOrder")[index]["userId"],
            //         productTitle: userDoc.get("userOrder")[index]["productTitle"],
            //         userName: userDoc.get("userOrder")[index]["userName"],
            //         totalPrice:
            //             userDoc.get("userOrder")[index]["totalPrice"].toString(),
            //         imageUrl: userDoc.get("userOrder")[index]["imageUrl"],
            //         quantity:
            //             userDoc.get("userOrder")[index]["quantity"].toString(),
            //         sessionId: userDoc.get("userOrder")[index]["sessionId"],
            //         orderDate: userDoc.get("userOrder")[index]["orderDate"])
            OrderSummary(
                // orderId: userDoc.get("orderSummary")[index]["orderId"],
                userId: userDoc.get("orderSummary")[index]["userId"],
                totalPrice:
                    userDoc.get("orderSummary")[index]["totalPrice"].toString(),
                totalProducts: userDoc
                    .get("orderSummary")[index]["totalProducts"]
                    .toString(),
                sessionId: userDoc.get("orderSummary")[index]["sessionId"],
                paymentMethod: userDoc.get("paymentMethod")[index]["sessionId"],
                orderStatus: userDoc.get("orderSummary")[index]["orderStatus"],
                orderDate: userDoc.get("orderSummary")[index]["orderDate"]));
        // );
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
    return orders;
  }

  //get whole quantity from firebase
  // Future<int> getWholeQuantity() async {
  //   final auth = FirebaseAuth.instance;
  //   final User? user = auth.currentUser;
  //   if (user == null) {
  //     return 0;
  //   }
  //   try {
  //     final usersDb = FirebaseFirestore.instance.collection("ordersAdvanced");
  //
  //     final userDoc = await usersDb.doc(user.uid).get();
  //     final data = userDoc.data();
  //     if (data == null || !data.containsKey("orderSummary")) return 0;
  //
  //     final length = userDoc.get("orderSummary").length;
  //     int totalQuantity = 0;
  //     for (int index = 0; index < length; index++) {
  //       totalQuantity += int.parse(
  //           userDoc.get("orderSummary")[index]["quantity"].toString());
  //     }
  //     notifyListeners();
  //     return totalQuantity;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  //customized fetch user address and phone from firestore
  Future<OrderUserModel?> fetchUserInfo() async {
    final auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;

    if (user == null) {
      return null;
    }
    String uid = user.uid;
    try {
      //get user info
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      //to get the userCart and userWish
      final userDocDic = userDoc.data() as Map<String, dynamic>;

      //assign the values to the model
      _orderUserModel = OrderUserModel(
        userId: userDoc.get("userId"),
        userName: userDoc.get("userName"),
        userEmail: userDoc.get("userEmail"),
        userAddress: userDoc.get("userAddress"),
        createdAt: userDoc.get("createdAt"),
        userImage: userDoc.get("userImage"),
        userPhone: userDoc.get("userPhone"),
        userCart:
            userDocDic.containsKey("userCart") ? userDoc.get("userCart") : [],
        userWish:
            userDocDic.containsKey("userWish") ? userDoc.get("userWish") : [],
      );
      // notifyListeners();
      return _orderUserModel;
    } on FirebaseException catch (error) {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }
}
