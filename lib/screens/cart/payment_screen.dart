import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/cart_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/user_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/cart/bottom_checkout.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isLoading = false;
  String? _sessionId;

  Future<void> createSession() async {
    final auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final String uid = user.uid;
    //Register user in FirebaseFirestore
    await FirebaseFirestore.instance
        .collection("ordersAdvanced")
        .doc(_sessionId)
        .set({
      "userId": uid,
      "userName": user.displayName,
      "userEmail": user.email,
      "createdAt": Timestamp.now(),
      "userOrder": [],
    });
  }

  @override
  void initState() {
    _sessionId = Uuid().v4();
    print(_sessionId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      bottomSheet: CartBottomSheetWidget(function: () async {
        await placeOrderAdvanced(
          cartProvider: cartProvider,
          productProvider: productProvider,
          userProvider: userProvider,
        );
      }),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Payment"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleTextWidget(
                label: "Shipping to",
                fontSize: 24,
              ),
              SizedBox(
                height: 20,
              ),
              // DeliveryContainerWidget(),
              SizedBox(
                height: 20,
              ),

              TitleTextWidget(
                label: "Payment Method",
                fontSize: 24,
              ),
              SizedBox(
                height: 30,
              ),
              //Total Button
              SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Buy Now",
                      style: TextStyle(
                          fontSize: 22,
                          // fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //customized function
  Future<void> placeOrderAdvanced({
    required UserProvider userProvider,
    required ProductsProvider productProvider,
    required CartProvider cartProvider,
  }) async {
    final auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final ordersDb = FirebaseFirestore.instance.collection("ordersAdvanced");

    if (user == null) {
      return;
    }
    final uid = user.uid;
    try {
      setState(() {
        isLoading = true;
      });
      cartProvider.cartItems.forEach((key, value) async {
        final getCurrProd = productProvider.findByProdId(value.productId);
        final orderId = Uuid().v4();
        // print(orderId);
        await createSession();
        await ordersDb.doc(_sessionId).update({
          "userOrder": FieldValue.arrayUnion([
            {
              "orderId": orderId,
              "userId": uid,
              "userName": userProvider.getUserModel!.userName,
              "productId": value.productId,
              "productTitle": getCurrProd!.productTitle,
              "imageUrl": getCurrProd.productImage,
              "price": double.parse(getCurrProd.productPrice) * value.quantity,
              "totalPrice":
                  cartProvider.getTotal(productsProvider: productProvider),
              "quantity": value.quantity,
              "orderDate": Timestamp.now(),
            }
          ])
        });
      });
      await cartProvider.clearCartFirebase();
      cartProvider.clearCart();
    } catch (error) {
      MyAppFunctions.showErrorOrWarningDialog(
          context: context, fct: () {}, subTitle: error.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
