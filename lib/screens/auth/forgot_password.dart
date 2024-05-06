import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hadi_ecommerce_firebase_admin/constants/validator.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static const String routeName = "ForgotPasswordScreen";

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _emailController;
  late final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _emailController.dispose();
    }

    super.dispose();
  }

  Future<void> forgetPassFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) return;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const AppNameTextWidget(
          label: "Shop Smart",
          fontSize: 22,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(
              height: 10,
            ),
            Image.asset(
              AssetsManager.forgotPassword,
              width: size.width * 0.6,
              height: size.width * 0.6,
            ),
            const SizedBox(
              height: 10,
            ),
            const TitleTextWidget(
              label: "Forget Password",
              fontSize: 22,
            ),
            const SubtitleTextWidget(
              label: "Enter your email to get reset link",
              fontSize: 14,
            ),
            const SizedBox(
              height: 40,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "Enter Your Email Address",
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(IconlyLight.message),
                          ),
                          filled: true),
                      validator: (value) {
                        MyValidators.emailValidator(value);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          forgetPassFct();
                        },
                        icon: const Icon(IconlyLight.send),
                        label: const Text(
                          "Request Link",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
