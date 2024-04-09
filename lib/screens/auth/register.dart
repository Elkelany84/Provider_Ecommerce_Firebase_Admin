import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hadi_ecommerce_firebase_admin/constants/validator.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/auth/login_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/loading_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/auth/image_picker_widget.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/root_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static String routeName = "RegisterScreen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isObscureText = true;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _repeatPasswordController;
  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _repeatPasswordFocusNode;
  final _formKey = GlobalKey<FormState>();
  XFile? pickedImage;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _repeatPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _repeatPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> registerFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });
        await auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());

        //Register user in FirebaseFirestore
        final User user = auth.currentUser!;
        final String uid = user.uid;
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          "userId": uid,
          "userName": _nameController.text.trim(),
          "userEmail": _emailController.text.trim().toLowerCase(),
          "userImage": "",
          "createdAt": Timestamp.now(),
          "userCart": [],
          "userWish": []
        });

        //SToast Message
        Fluttertoast.showToast(
            msg: "An Account Has been Created!",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RootScreen.routeName);
      } on FirebaseException catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
            context: context, fct: () {}, subTitle: error.message.toString());
      } catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
            context: context, fct: () {}, subTitle: error.toString());
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> localImagePicker() async {
    final ImagePicker imagePicker = ImagePicker();

    await MyAppFunctions.imagePickerDialog(
        context: context,
        cameraFct: () async {
          pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
          setState(() {});
        },
        galleryFct: () async {
          pickedImage =
              await imagePicker.pickImage(source: ImageSource.gallery);
          setState(() {});
        },
        removeFct: () {
          setState(() {
            pickedImage = null;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoadingManager(
          isLoading: isLoading,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                    height: 20,
                  ),
                  SizedBox(
                      height: size.width * 0.3,
                      width: size.width * 0.3,
                      child: ImagePickerWidget(
                          function: () async {
                            await localImagePicker();
                          },
                          pickedImage: pickedImage)),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: "Enter Your Name",
                            prefixIcon: Icon(Icons.person),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_emailFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.displayNamevalidator(value);
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
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
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.emailValidator(value);
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          obscureText: isObscureText,
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(IconlyLight.lock),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscureText = !isObscureText;
                                  });
                                },
                                icon: Icon(isObscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              )),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_repeatPasswordFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.passwordValidator(value);
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          obscureText: isObscureText,
                          controller: _repeatPasswordController,
                          focusNode: _repeatPasswordFocusNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hintText: "Repeat Password",
                            prefixIcon: Icon(IconlyLight.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isObscureText = !isObscureText;
                                });
                              },
                              icon: Icon(isObscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                          onFieldSubmitted: (value) async {
                            await registerFct();
                          },
                          validator: (value) {
                            return MyValidators.repeatPasswordValidator(
                                value: value,
                                password: _repeatPasswordController.text);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(12),
                              backgroundColor: Colors.purpleAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              await registerFct();
                            },
                            label: Text(
                              "SignUp",
                              style: TextStyle(fontSize: 20),
                            ),
                            icon: Icon(IconlyLight.addUser),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SubtitleTextWidget(label: "Already User?"),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(LoginScreen.routeName);
                              },
                              child: SubtitleTextWidget(
                                label: "SignIn?",
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
        ),
      ),
    );
  }
}
