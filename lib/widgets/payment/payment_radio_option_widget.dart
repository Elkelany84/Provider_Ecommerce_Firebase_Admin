import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';

// typedef void IntCallback(int id);

class PaymentMethodWidget extends StatefulWidget {
  PaymentMethodWidget(
    this.hobby,
    this.changedHobby, {
    super.key,
  });
  int hobby;
  Function(int value) changedHobby;

  @override
  State<PaymentMethodWidget> createState() => _PaymentMethodWidgetState();
}

class _PaymentMethodWidgetState extends State<PaymentMethodWidget> {
  ///newHobby
  int? radioPaymentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildRadioPayment(
            name: "Cash On Delivery",
            image: AssetsManager.paymentCash,
            scale: 0.5,
            value: 1,
            onChange: (value) {
              setState(() {
                radioPaymentIndex = value;
                widget.changedHobby(radioPaymentIndex!);
              });
            }),
        const SizedBox(
          height: 20,
        ),
        buildRadioPayment(
            name: "CreditCard On Delivery",
            image: AssetsManager.paymentPos,
            scale: 0.5,
            value: 2,
            onChange: (value) {
              setState(() {
                radioPaymentIndex = value;
                widget.changedHobby(radioPaymentIndex!);
              });
            }),
      ],
    );
  }

  Widget buildRadioPayment(
      {required String image,
      required double scale,
      required String name,
      required int value,
      required Function onChange}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade300,
      ),
      height: 70,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                image,
                scale: scale,
              ),
              const SizedBox(
                width: 10,
              ),
              TitleTextWidget(
                label: name,
                fontSize: 20,
                color: Colors.black,
              )
            ],
          ),
          Radio(
              value: value,
              groupValue: radioPaymentIndex,
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.black),
              onChanged: (value) {
                onChange(value);
              })
        ],
      ),
    );
  }
}
