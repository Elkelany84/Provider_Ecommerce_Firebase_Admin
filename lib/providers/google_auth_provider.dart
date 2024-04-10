// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:hadi_ecommerce_firebase_admin/services/myapp_functions.dart';
// import 'package:hadi_ecommerce_firebase_admin/widgets/root_screen.dart';
//
// class GoogleProvider extends ChangeNotifier {
//   Future<void> googleSignSignIn({required BuildContext context}) async {
//     try {
//       final googleSignIn = GoogleSignIn();
//       final googleAccount = await googleSignIn.signIn();
//       if (googleAccount != null) {
//         final googleAuth = await googleAccount.authentication;
//         if (googleAuth.accessToken != null && googleAuth.idToken != null) {
//           final authResults = await FirebaseAuth.instance
//               .signInWithCredential(GoogleAuthProvider.credential(
//             accessToken: googleAuth.accessToken,
//             idToken: googleAuth.idToken,
//           ));
//         }
//       }
//       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//         Navigator.pushReplacementNamed(context, RootScreen.routeName);
//       });
//     } on FirebaseException catch (error) {
//       await MyAppFunctions.showErrorOrWarningDialog(
//         context: context,
//         subTitle: error.message.toString(),
//         fct: () {},
//       );
//     } catch (error) {
//       await MyAppFunctions.showErrorOrWarningDialog(
//         context: context,
//         subTitle: error.toString(),
//         fct: () {},
//       );
//     }
//   }
//
//   @override
//   notifyListeners();
// }
