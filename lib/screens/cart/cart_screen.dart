import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/cart_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/products_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/user_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/cart/cart_bottom_checkout.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/cart/cart_widget.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/inner_screens/orders/payment_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/loading_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/empty_bag.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static const routeName = "/cart_screen";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;
  // String? _sessionId;

  // Future<void> createSession() async {
  //   final auth = FirebaseAuth.instance;
  //   final User user = auth.currentUser!;
  //   final String uid = user.uid;
  //   //Register user in FirebaseFirestore
  //   await FirebaseFirestore.instance
  //       .collection("ordersAdvanced")
  //       .doc(_sessionId)
  //       .set({
  //     "userId": uid,
  //     "userName": user.displayName,
  //     "userEmail": user.email,
  //     "createdAt": Timestamp.now(),
  //     "userOrder": [],
  //   });
  // }

  @override
  void initState() {
    // _sessionId = const Uuid().v4();
    // print(_sessionId);
    super.initState();
  }

  // storeSessionID(String sessionId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final sessionId = Uuid().v4();
  //   prefs.setString("sessionId", sessionId);
  //   print(_sessionId);
  //   setState(() {
  //     _sessionId = sessionId;
  //   });
  // }
  //
  //
  // getSessionId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _sessionId = prefs.getString("sessionId");
  //   print(_sessionId);
  //   return _sessionId;
  // }
  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return cartProvider.cartItems.isEmpty
        ? Scaffold(
            body: EmptyBag(
              imagePath: AssetsManager.shoppingBasket,
              title: "Whoops",
              subtitle: "Your Cart Is Empty!",
              details: "Looks Like Your Cart is Empty,Start Shopping!",
              buttonText: "Shop now",
            ),
          )
        : Scaffold(
            bottomSheet: CartBottomSheetWidget(function: () {
              Navigator.pushNamed(context, PaymentScreen.routeName);
              // await placeOrderAdvanced(
              //   cartProvider: cartProvider,
              //   productProvider: productProvider,
              //   userProvider: userProvider,
              // );
            }),
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsManager.shoppingCart),
              ),
              title: AppNameTextWidget(
                label: "Cart (${cartProvider.cartItems.length})",
                fontSize: 22,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    MyAppFunctions.showErrorOrWarningDialog(
                        isError: false,
                        context: context,
                        fct: () async {
                          await cartProvider.clearCartFirebase();
                          await cartProvider.getCartItemsFromFirebase();
                          // cartProvider.clearCart();
                        },
                        subTitle: "Clear Cart?");
                  },
                  icon: const Icon(Icons.delete_forever_rounded),
                )
              ],
            ),
            body: LoadingManager(
              isLoading: isLoading,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: cartProvider.cartItems.length,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                              value:
                                  cartProvider.cartItems.values.toList()[index],
                              child: const CartWidget());
                        }),
                  ),
                  const SizedBox(
                    height: kBottomNavigationBarHeight + 10,
                  )
                ],
              ),
            ),
          );
  }

  //customized function
  // Future<void> placeOrderAdvanced({
  //   required UserProvider userProvider,
  //   required ProductsProvider productProvider,
  //   required CartProvider cartProvider,
  // }) async {
  //   final auth = FirebaseAuth.instance;
  //   final User? user = auth.currentUser;
  //   final ordersDb = FirebaseFirestore.instance.collection("ordersAdvanced");
  //
  //   if (user == null) {
  //     return;
  //   }
  //   final uid = user.uid;
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     cartProvider.cartItems.forEach((key, value) async {
  //       final getCurrProd = productProvider.findByProdId(value.productId);
  //       final orderId = const Uuid().v4();
  //       // print(orderId);
  //       await createSession();
  //       await ordersDb.doc(_sessionId).update({
  //         "userOrder": FieldValue.arrayUnion([
  //           {
  //             "orderId": orderId,
  //             "userId": uid,
  //             "userName": userProvider.getUserModel!.userName,
  //             "productId": value.productId,
  //             "productTitle": getCurrProd!.productTitle,
  //             "imageUrl": getCurrProd.productImage,
  //             "price": double.parse(getCurrProd.productPrice) * value.quantity,
  //             "totalPrice":
  //                 cartProvider.getTotal(productsProvider: productProvider),
  //             "quantity": value.quantity,
  //             "orderDate": Timestamp.now(),
  //           }
  //         ])
  //       });
  //     });
  //     await cartProvider.clearCartFirebase();
  //     cartProvider.clearCart();
  //   } catch (error) {
  //     MyAppFunctions.showErrorOrWarningDialog(
  //         context: context, fct: () {}, subTitle: error.toString());
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  //original function
  // Future<void> placeOrderAdvanced({
  //   required UserProvider userProvider,
  //   required ProductsProvider productProvider,
  //   required CartProvider cartProvider,
  // }) async {
  //   final auth = FirebaseAuth.instance;
  //   final User? user = auth.currentUser;
  //   final ordersDb = FirebaseFirestore.instance.collection("ordersAdvanced");
  //
  //   if (user == null) {
  //     return;
  //   }
  //   final uid = user.uid;
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     cartProvider.cartItems.forEach((key, value) async {
  //       final getCurrProd = productProvider.findByProdId(value.productId);
  //       final orderId = Uuid().v4();
  //       await ordersDb.doc(orderId).set({
  //         "orderId": orderId,
  //         "userId": uid,
  //         "userName": userProvider.getUserModel!.userName,
  //         "productId": value.productId,
  //         "productTitle": getCurrProd!.productTitle,
  //         "imageUrl": getCurrProd.productImage,
  //         "price": double.parse(getCurrProd.productPrice) * value.quantity,
  //         "totalPrice":
  //             cartProvider.getTotal(productsProvider: productProvider),
  //         "quantity": value.quantity,
  //         "orderDate": Timestamp.now(),
  //       });
  //     });
  //     await cartProvider.clearCartFirebase();
  //     cartProvider.clearCart();
  //   } catch (error) {
  //     MyAppFunctions.showErrorOrWarningDialog(
  //         context: context, fct: () {}, subTitle: error.toString());
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
}
