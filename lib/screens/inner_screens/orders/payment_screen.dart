import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/models/order_user_model.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/cart_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/order_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/user_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/orders/payment_bottom_checkout.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/orders/payment_success.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/personal_profile.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/payment/payment_radio_option_widget.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  static const routeName = "/payment-screen";

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool isLoading = false;
  String? _sessionId;
  User? user = FirebaseAuth.instance.currentUser;
  OrderUserModel? orderUserModel;
  bool _isLoading = true;

  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<OrderProvider>(context, listen: false);
    final orderUserProvider =
        Provider.of<OrderProvider>(context, listen: false);

    try {
      setState(() {
        _isLoading = true;
      });
      orderUserModel = await orderUserProvider.fetchUserInfo();
    } catch (error) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subTitle: error.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> createSession() async {
    final auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final String uid = user.uid;

    //Register user in FirebaseFirestore
    // await FirebaseFirestore.instance
    //     .collection("ordersAdvanced")
    //     .doc(_sessionId)
    //     .set({
    //   "userId": uid,
    //   "userName": user.displayName,
    //   "userEmail": user.email,
    //   "createdAt": Timestamp.now(),
    //   "userOrder": [],
    // });
  }

  @override
  void initState() {
    _sessionId = const Uuid().v4();
    print(_sessionId);
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    return Scaffold(
      bottomSheet: PaymentBottomSheetWidget(function: () async {
        await placeOrderAdvanced(
          cartProvider: cartProvider,
          productProvider: productProvider,
          userProvider: userProvider,
        );
      }),
      appBar: AppBar(
        centerTitle: true,
        // automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        // leading: Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: Image.asset(AssetsManager.shoppingCart),
        // ),
        title: const AppNameTextWidget(
          label: "CheckOut",
          fontSize: 30,
        ),
      ),
      body: orderUserModel == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const TitleTextWidget(
                      label: "Shipping to : ",
                      fontSize: 24,
                    ),
                    const SizedBox(
                      height: 18,
                    ),

                    Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade100),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8, right: 8, left: 8, bottom: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SubtitleTextWidget(
                              label: orderUserModel!.userAddress * 3,
                              fontSize: 20, color: Colors.black,
                              // textDecoration: TextDecoration.underline,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(PersonalProfile.routeName);
                                },
                                child: const SubtitleTextWidget(
                                  label: "Edit Address",
                                  fontStyle: FontStyle.italic,
                                  textDecoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // DeliveryContainerWidget(),
                    const SizedBox(
                      height: 30,
                    ),

                    const TitleTextWidget(
                      label: "Payment Method : ",
                      fontSize: 24,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const PaymentMethodWidget(),
                    // TitleTextWidget(
                    //   label: "Payment On Delivery",
                    //   fontSize: 24,
                    // ),
                    //Total Button
                    const SizedBox(
                      height: 40,
                    ),
                    // Center(
                    //   child: SizedBox(
                    //     height: 50,
                    //     width: 150,
                    //     child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //         elevation: 0,
                    //         backgroundColor: Colors.blue,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(10),
                    //         ),
                    //       ),
                    //       onPressed: () {},
                    //       child: Text(
                    //         "Buy Now",
                    //         style: TextStyle(
                    //             fontSize: 22,
                    //             // fontWeight: FontWeight.bold,
                    //             color: Colors.white),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const TitleTextWidget(
                      label: "Order Summary : ",
                      fontSize: 24,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TitleTextWidget(
                      label:
                          "\$ ${cartProvider.getTotal(productsProvider: productProvider).toStringAsFixed(2)}",
                      fontSize: 18,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const TitleTextWidget(
                      label: "Delivery Fees : \$ 10 ",
                      fontSize: 18,
                    ),
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
      //Original working one
      // cartProvider.cartItems.forEach((key, value) async {
      //   final getCurrProd = productProvider.findByProdId(value.productId);
      //   final orderId = const Uuid().v4();
      //   // print(orderId);
      //   await createSession();
      //   await ordersDb.doc(uid).update({
      //     // await ordersDb.doc(_sessionId).update({
      //     "userId": uid,
      //     "orderDate": Timestamp.now(),
      //     "sessionId": _sessionId,
      //     "totalPrice": cartProvider.getTotalForPayment(
      //         productsProvider: productProvider),
      //     "orderSummary": FieldValue.arrayUnion([
      //       {
      //         "orderId": orderId,
      //         "userId": uid,
      //         "sessionId": _sessionId,
      //         // "userName": userProvider.getUserModel!.userName,
      //         // "productId": value.productId,
      //         // "productTitle": getCurrProd!.productTitle,
      //         // "price": double.parse(getCurrProd.productPrice) * value.quantity,
      //         "totalPrice": cartProvider.getTotalForPayment(
      //             productsProvider: productProvider),
      //         "totalProducts": cartProvider.getQty(),
      //         "orderDate": Timestamp.now(),
      //       }
      //     ]),
      //     "userOrder": FieldValue.arrayUnion([
      //       {
      //         "orderId": orderId,
      //         "userId": uid,
      //         "sessionId": _sessionId,
      //         "userName": userProvider.getUserModel!.userName,
      //         "productId": value.productId,
      //         "productTitle": getCurrProd!.productTitle,
      //         "imageUrl": getCurrProd.productImage,
      //         "price": double.parse(getCurrProd.productPrice) * value.quantity,
      //         "totalPrice": cartProvider.getTotalForPayment(
      //             productsProvider: productProvider),
      //         "quantity": value.quantity,
      //         "orderDate": Timestamp.now(),
      //       }
      //     ])
      //   });
      // });

//customized one
      cartProvider.cartItems.forEach((key, value) async {
        final getCurrProd = productProvider.findByProdId(value.productId);
        final orderId = const Uuid().v4();
        // print(orderId);
        await createSession();
        await ordersDb.doc(uid).update({
          // await ordersDb.doc(_sessionId).update({
          "userId": uid,
          "orderDate": Timestamp.now(),
          "sessionId": _sessionId,
          "totalPrice": cartProvider.getTotalForPayment(
              productsProvider: productProvider),
          // "totalProducts": cartProvider.getQty(),
          "userOrder": FieldValue.arrayUnion([
            {
              "orderId": orderId,
              "userId": uid,
              "sessionId": _sessionId,
              "userName": userProvider.getUserModel!.userName,
              "productId": value.productId,
              "productTitle": getCurrProd!.productTitle,
              "imageUrl": getCurrProd.productImage,
              "price": double.parse(getCurrProd.productPrice) * value.quantity,
              "totalPrice": cartProvider.getTotalForPayment(
                  productsProvider: productProvider),
              "quantity": value.quantity,
              "orderDate": Timestamp.now(),
            }
          ])
        });
      });
      await ordersDb.doc(uid).update({
        "orderSummary": FieldValue.arrayUnion([
          {
            "userId": uid,
            "sessionId": _sessionId,
            // "userName": userProvider.getUserModel!.userName,
            // "productId": value.productId,
            // "productTitle": getCurrProd!.productTitle,
            // "price": double.parse(getCurrProd.productPrice) * value.quantity,
            "totalPrice": cartProvider.getTotalForPayment(
                productsProvider: productProvider),
            "totalProducts": cartProvider.getQty(),
            "orderDate": Timestamp.now(),
          }
        ])
      });
      await cartProvider.clearCartFirebase();
      cartProvider.clearCart();
      Navigator.pushNamed(context, PaymentSuccess.routeName);
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
