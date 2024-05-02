import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/root_screen.dart';
import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
import 'package:ionicons/ionicons.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  Future<UserCredential?> signInWithGoogle(
      {required BuildContext context}) async {
    try {
      // Trigger the authentication flow
      final googleAccount = await GoogleSignIn().signIn();
      if (googleAccount != null) {
        final googleAuth = await googleAccount.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final authResults = await FirebaseAuth.instance
              .signInWithCredential(GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ));
          if (authResults.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(authResults.user!.uid)
                .set({
              "userId": authResults.user!.uid,
              "userName": authResults.user!.displayName,
              "userEmail": authResults.user!.email,
              "userImage": authResults.user!.photoURL,
              "createdAt": Timestamp.now(),
              "userAddress": "",
              "userPhone": "",
              'userCart': [],
              "userWish": [],
              "orderSummary": []
            });
          }
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, RootScreen.routeName);
      });
      // Once signed in, return the UserCredential
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

  //google sign in

  signInWithGoog({required BuildContext context}) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication?.idToken,
          accessToken: googleSignInAuthentication?.accessToken);

      UserCredential result =
          await firebaseAuth.signInWithCredential(credential);

      User? userDetails = result.user;

      if (result.additionalUserInfo!.isNewUser) {
        // Map<String, dynamic> userInfoMap = {
        //   "email": userDetails!.email,
        //   "name": userDetails.displayName,
        //   "imgUrl": userDetails.photoURL,
        //   "id": userDetails.uid
        // };
        await FirebaseFirestore.instance
            .collection('users')
            .doc(result.user!.uid)
            .set({
          "userId": result.user!.uid,
          "userName": result.user!.displayName,
          "userEmail": result.user!.email,
          "userImage": result.user!.photoURL,
          "createdAt": Timestamp.now(),
          'userCart': [],
          "userWish": [],
        });
      }
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, RootScreen.routeName);
      });
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
        await signInWithGoog(context: context);
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
