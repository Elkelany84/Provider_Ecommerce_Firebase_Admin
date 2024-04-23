import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _userModel;
  //getters
  UserModel? get getUserModel => _userModel;

  //fetch user info from firestore
  Future<UserModel?> fetchUserInfo() async {
    final auth = FirebaseAuth.instance;

    // final User? user = auth.currentUser;
    final User? user = auth.currentUser;

    if (user == null) {
      return null;
    }
    String uid = user.uid;
    try {
      //get user info
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      //to get the userCart and userWish
      final userDocDic = userDoc.data() as Map<String, dynamic>;

      //assign the values to the model
      _userModel = UserModel(
        userId: userDoc.get("userId"),
        userName: userDoc.get("userName"),
        userEmail: userDoc.get("userEmail"),
        userImage: userDoc.get("userImage"),
        createdAt: userDoc.get("createdAt"),
        userAddress: userDoc.get("userAddress"),
        userPhone: userDoc.get("userPhone"),
        userCart:
            userDocDic.containsKey("userCart") ? userDoc.get("userCart") : [],
        userWish:
            userDocDic.containsKey("userWish") ? userDoc.get("userWish") : [],
      );
      // notifyListeners();
      return _userModel;
    } on FirebaseException catch (error) {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

//count products in firebase
  final CollectionReference<Map<String, dynamic>> categoryList =
      FirebaseFirestore.instance.collection('users');
  int? quer;
  Future<int?> countUsers() async {
    AggregateQuerySnapshot query = await categoryList.count().get();
    debugPrint('The number of users: ${query.count}');
    quer = query.count;
    notifyListeners();
    return query.count;
  }

  //delete user from firebase based on userId
  Future<void> deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
    } catch (e) {
      rethrow;
    }
  }

  //fetch info for specific user from firebase
//   Future<UserModel?> fetchUserInfoById(String userId) async {
//     final auth = FirebaseAuth.instance;
//
//     // final User? user = auth.currentUser;
//     final User? user = auth.currentUser;
//
//     if (user == null) {
//       return null;
//     }
//     String uid = user.uid;
//     try {
//       //get user info
//       final userDoc =
//           await FirebaseFirestore.instance.collection('users').doc(uid).get();
// //to get the userCart and userWish
//       final userDocDic = userDoc.data() as Map<String, dynamic>;
//     } catch (e) {
//       rethrow;
//     }
//
//     return _userModel;
//   }
}
