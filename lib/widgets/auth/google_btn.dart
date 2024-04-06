import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/root_screen.dart';
import 'package:ionicons/ionicons.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  Future<void> _googleSignIn({required BuildContext context}) async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleAccount = await googleSignIn.signIn();
      if (googleAccount != null) {
        // Perform sign-in with the Google account
        final googleAuth = await googleAccount.authentication;
        // You can now use the Google credentials to authenticate with your backend
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final authResults = await FirebaseAuth.instance.signInWithCredential(
              GoogleAuthProvider.credential(
                  accessToken: googleAuth.accessToken,
                  idToken: googleAuth.idToken));
        }
        // After successful sign-in, navigate to the root screen
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          Navigator.pushReplacementNamed(context, RootScreen.routeName);
        });
      }
    } on FirebaseException catch (error) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        MyAppFunctions.showErrorOrWarningDialog(
            context: context, fct: () {}, subTitle: error.message.toString());
      });
    } catch (error) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        MyAppFunctions.showErrorOrWarningDialog(
            context: context, fct: () {}, subTitle: error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: EdgeInsets.all(12),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () async {
        await _googleSignIn(context: context);
      },
      label: Text(
        "SignIn With Google",
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
      icon: Icon(
        Ionicons.logo_google,
        color: Colors.red,
      ),
    );
  }
}
