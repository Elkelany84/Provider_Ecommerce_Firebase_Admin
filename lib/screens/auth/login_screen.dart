import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hadi_ecommerce_firebase_admin/constants/validator.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String routeName = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> loginFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              AppNameTextWidget(label: "Shop Smart", fontSize: 30),
              Align(
                  alignment: Alignment.centerLeft,
                  child: TitleTextWidget(label: "Welcome Back!")),
              SizedBox(
                height: 16,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email Address",
                        prefixIcon: Icon(IconlyLight.message),
                      ),
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      validator: (value) {
                        return MyValidators.emailValidator(value);
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(IconlyLight.lock),
                      ),
                      onFieldSubmitted: (value) async {
                        await loginFct();
                      },
                      validator: (value) {
                        return MyValidators.passwordValidator(value);
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: SubtitleTextWidget(
                          label: "Forgot Password?",
                          fontStyle: FontStyle.italic,
                          textDecoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(12),
                          // backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          await loginFct();
                        },
                        label: Text(
                          "LogIn",
                          style: TextStyle(fontSize: 20),
                        ),
                        icon: Icon(Icons.logout),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SubtitleTextWidget(label: "Or Connect Using"),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(12),
                            // backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {},
                          child: Text(
                            "Guest",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SubtitleTextWidget(label: "New Here?"),
                        TextButton(
                          onPressed: () {},
                          child: SubtitleTextWidget(
                            label: "Forgot Password?",
                            fontStyle: FontStyle.italic,
                            textDecoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
