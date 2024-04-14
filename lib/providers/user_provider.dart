import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hadi_ecommerce_firebase_admin/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _userModel;
  //getters
  UserModel? get getUserModel => _userModel;

  //fetch user info from firestore
  Future<UserModel?> fetchUserInfo() async {
    final auth = FirebaseAuth.instance;

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

  //customized user profile fetch data for personal profile
}
