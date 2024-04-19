import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/empty_bag.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

  static const String routeName = "/payment_success";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: EmptyBag(
      imagePath: AssetsManager.paymentSuccess,
      title: "Thanks For Shopping With Us",
      subtitle: "Payment Success !",
      details: "Your Order Place Successfully and Forward to Our Store!",
      buttonText: "Continue Shopping",
    ));
  }
}
