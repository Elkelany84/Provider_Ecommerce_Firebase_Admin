import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hadi_ecommerce_firebase_admin/models/order_model.dart';
import 'package:hadi_ecommerce_firebase_admin/models/order_user_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrdersModelAdvanced> orders = [];
  List<OrdersModelAdvanced> get getOrders => orders;

  OrderUserModel? _orderUserModel;
  //getters
  OrderUserModel? get getUserModel => _orderUserModel;

  //fetch orders from firebase original way in course
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
