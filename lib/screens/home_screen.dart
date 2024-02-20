import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.lightScaffoldColor,
      body: Column(
        children: [Text("Hello World")],
      ),
    );
  }
}
