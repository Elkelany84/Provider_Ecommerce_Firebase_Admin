import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/root_screen.dart';
import 'package:ionicons/ionicons.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  Future<UserCredential?> signInWithGoogle(
      {required BuildContext context}) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, RootScreen.routeName);
      });
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseException catch (error) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subTitle: error.message.toString(),
        fct: () {},
      );
    } catch (error) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subTitle: error.toString(),
        fct: () {},
      );
    }
  }

  // Future<void> _googleSignSignIn({required BuildContext context}) async {
  //   try {
  //     final googleSignIn = GoogleSignIn();
  //     final googleAccount = await googleSignIn.signIn();
  //     if (googleAccount != null) {
  //       final googleAuth = await googleAccount.authentication;
  //       if (googleAuth.accessToken != null && googleAuth.idToken != null) {
  //         final authResults = await FirebaseAuth.instance
  //             .signInWithCredential(GoogleAuthProvider.credential(
  //           accessToken: googleAuth.accessToken,
  //           idToken: googleAuth.idToken,
  //         ));
  //       }
  //     }
  //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //       Navigator.pushReplacementNamed(context, RootScreen.routeName);
  //     });
  //   } on FirebaseException catch (error) {
  //     await MyAppFunctions.showErrorOrWarningDialog(
  //       context: context,
  //       subTitle: error.message.toString(),
  //       fct: () {},
  //     );
  //   } catch (error) {
  //     await MyAppFunctions.showErrorOrWarningDialog(
  //       context: context,
  //       subTitle: error.toString(),
  //       fct: () {},
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final googleProvider = Provider.of<GoogleProvider>(
    //   context,
    // );
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
        signInWithGoogle(context: context);
        // Provider.of<GoogleProvider>(context, listen: false)
        //     .googleSignSignIn(context: context);
        // await _googleSignSignIn(context: context);
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
