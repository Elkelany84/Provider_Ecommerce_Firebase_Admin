import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/google_auth_provider.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

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
    return Consumer<GoogleProvider>(
      builder: (builder, google, child) {
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
            Provider.of<GoogleProvider>(context, listen: false)
                .googleSignSignIn(context: context);
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
      },
      // child: ElevatedButton.icon(
      //   style: ElevatedButton.styleFrom(
      //     elevation: 1,
      //     padding: EdgeInsets.all(12),
      //     backgroundColor: Colors.white,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(12),
      //     ),
      //   ),
      //   onPressed: () async {
      //     Provider.of<GoogleProvider>(context, listen: false)
      //         .googleSignSignIn(context: context);
      //     // await _googleSignSignIn(context: context);
      //   },
      //   label: Text(
      //     "SignIn With Google",
      //     style: TextStyle(fontSize: 20, color: Colors.black),
      //   ),
      //   icon: Icon(
      //     Ionicons.logo_google,
      //     color: Colors.red,
      //   ),
      // ),
    );
  }
}
