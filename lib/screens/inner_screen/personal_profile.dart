import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/consts/validator.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/models/user_model.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/user_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/all_users_screen.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/services/my_app_functions.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/subtitle_text.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class PersonalProfile extends StatefulWidget {
  const PersonalProfile({super.key, required this.uid});

  static const String routeName = '/personal-profile';
  final String? uid;

  @override
  State<PersonalProfile> createState() => _PersonalProfileState();
}

class _PersonalProfileState extends State<PersonalProfile>
    with AutomaticKeepAliveClientMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  bool get wantKeepAlive => true;
  // User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool _isLoading = true;

// Function to sum values in the array field
//   Future<void> sumArrayField() async {
//     var arraySum = 50;
// // Fetch document from Firestore
//     DocumentSnapshot document = await FirebaseFirestore.instance
//         .collection('ordersAdvanced')
//         .doc('8FDOP1pYDOQc4iQLuBBc5PGXhRd2')
//         .get();
//     // Get the array field from the document
//     List<dynamic> arrayField = document.get('orderSummary')["paymentMethod"];
//     // Sum the values in the array
//     for (var value in arrayField) {
//       // ararySum += value!;
//       print(value);
//     }

  num fieldValueSum = 0;

// Function to sum values in a specific field within the array field
//   Future<void> sumArrayFieldValues() async {
// // Fetch document from Firestore
//     DocumentSnapshot document = await FirebaseFirestore.instance
//         .collection('ordersAdvanced')
//         .doc('8FDOP1pYDOQc4iQLuBBc5PGXhRd2')
//         .get();
//     // Cast the result of document.data() to Map<String, dynamic>
//     Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
//     // Extract array field from the document
//     if (data != null && data.containsKey('orderSummary')) {
//       List<dynamic> arrayField = data["totalPrice"];
//       num sum = 0;
//       List all = [];
//       for (var obj in arrayField) {
//         // Assuming each object in the array has a field named 'specific_field'
//         num fieldValue = obj['totalPrice'];
//         all.add(fieldValue);
//         print(all);
//         // sum += fieldValue;
//         // print(fieldValue);
//       }
//       setState(() {
//         fieldValueSum = sum;
//       });
//     }
//
// // Sum values in the specific field within the array field
//
// // Update the state with the sum
//   }

  //very important funcion to sum the totalPrice for specific user
  num tPurchases = 0;
  Future<List<dynamic>> fetchSpecificValues(
      // String documentId, String arrayFieldName
      ) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('ordersAdvanced')
            .doc(widget.uid)
            .get();

    // Check if the document snapshot actually contains data.
    if (documentSnapshot.data() != null) {
      // Use 'as List<dynamic>' to ensure the correct type.
      List<dynamic> values =
          List.from(documentSnapshot.data()!["orderSummary"] as List<dynamic>);
      // print(values);
      Map mappy = Map.fromIterable(values,
          key: (item) => item["totalPrice"],
          value: (item) => item["totalPrice"]);
      var totalPurchases = mappy.values;
      var result = totalPurchases.reduce((sum, element) => sum + element);
      // print(result);
      // Map<dynamic, dynamic> mapy = Map.from();
      print(mappy);
      tPurchases = result;
      setState(() {});
      print(tPurchases);
      return values;
    } else {
      // Handle the case where data is not available.
      return [];
    }
  }

  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      userModel = await userProvider.fetchUserInfo();
      setState(() {
        //Update the controllers
        _firstNameController.text = userModel!.userName;
        _phoneController.text = userModel!.userPhone;
        _addressController.text = userModel!.userAddress;
      });
    } catch (error) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: error.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  late TextEditingController _firstNameController = TextEditingController();
  late TextEditingController _userEmailController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _createdAtController;
  late TextEditingController _totalPurchasesController;
  late final FocusNode _firstNameFocusNode;
  late final FocusNode _userEmailFocusNode;
  late final FocusNode _addressFocusNode;
  late final FocusNode _phoneFocusNode;
  late final FocusNode _createdAtFocusNode;
  late final FocusNode _totalPurchasesFocusNode;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // fetchUserInfo();
    fetchSpecificValues();
    _firstNameController = TextEditingController();
    _userEmailController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _createdAtController = TextEditingController();
    _totalPurchasesController = TextEditingController();
    _firstNameFocusNode = FocusNode();
    _userEmailFocusNode = FocusNode();
    _addressFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _createdAtFocusNode = FocusNode();
    _totalPurchasesFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _userEmailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _createdAtController.dispose();
    _totalPurchasesController.dispose();
    _firstNameFocusNode.dispose();
    _userEmailFocusNode.dispose();
    _addressFocusNode.dispose();
    _phoneFocusNode.dispose();
    _createdAtFocusNode.dispose();
    _totalPurchasesFocusNode.dispose();
    super.dispose();
  }

  Future<void> updateUserDetailsFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });

        final User user = auth.currentUser!;
        final String uid = user.uid;

        //Register user in FirebaseFirestore
        await FirebaseFirestore.instance.collection("users").doc(uid).update({
          "userName": _firstNameController.text.trim(),
          "userAddress": _addressController.text.trim(),
          "userPhone": _phoneController.text.trim(),
        });

        //SToast Message
        Fluttertoast.showToast(
            msg: "An Account Has been Updated!",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AllUsersScreen.routeName);
      } on FirebaseException catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
            context: context, fct: () {}, subtitle: error.message.toString());
      } catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
            context: context, fct: () {}, subtitle: error.toString());
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Future<void> _launched;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        // leading: Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: Image.asset(AssetsManager.shoppingCart),
        // ),
        title: AppNameTextWidget(
          label: "User Profile",
          fontSize: 30,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child:
            // userModel == null
            //     ? SizedBox.shrink()
            //     :
            Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    // Step 3: Build UI based on the stream
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SubtitleTextWidget(
                          label: "User Details: ",
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          textDecoration: TextDecoration.underline,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // SubtitleTextWidget(
                        //   label:
                        //       "You Can Change your Details From Here , Then Press Save. ",
                        //   fontWeight: FontWeight.normal,
                        //   fontSize: 18,
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubtitleTextWidget(
                                label: "First Name: ",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: _firstNameController,
                                focusNode: _firstNameFocusNode,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  // hintText: userModel!.userName,
                                  hintText: snapshot.data!["userName"],
                                  prefixIcon: Icon(Icons.person),
                                ),
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(_addressFocusNode);
                                },
                                validator: (value) {
                                  return MyValidators.displayNamevalidator(
                                      value);
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SubtitleTextWidget(
                                label: "E-mail: You Can\'t Change Your E-mail ",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: _userEmailController,
                                focusNode: _userEmailFocusNode,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: snapshot.data!["userEmail"],
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SubtitleTextWidget(
                                label: "Address: ",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: _addressController,
                                focusNode: _addressFocusNode,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  // hintText: userModel!.userAddress,
                                  hintText: snapshot.data!["userAddress"] * 3,
                                  prefixIcon: Icon(Icons.location_city),
                                ),
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(_phoneFocusNode);
                                },
                                validator: (value) {
                                  return MyValidators.addressvalidator(value);
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SubtitleTextWidget(
                                label: "Phone: ",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: _phoneController,
                                focusNode: _phoneFocusNode,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  // hintText: userModel!.userPhone,
                                  hintText: snapshot.data!["userPhone"],
                                  prefixIcon: Icon(Icons.phone),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: IconButton(
                                        onPressed: () async {
                                          final Uri url = Uri(
                                              scheme: "tel",
                                              path:
                                                  snapshot.data!["userPhone"]);
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          } else {
                                            print("can not launch");
                                          }
                                        },
                                        icon: Icon(
                                          Icons.call,
                                        )),
                                  ),
                                ),
                                onFieldSubmitted: (value) async {
                                  await updateUserDetailsFct();
                                },
                                validator: (value) {
                                  return MyValidators.phonevalidator(value);
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SubtitleTextWidget(
                                label: "Creation Date: ",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: _createdAtController,
                                focusNode: _createdAtFocusNode,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  // hintText: timeago
                                  //     .format(userModel!.createdAt.toDate()),
                                  // hintText: userModel!.createdAt.toString(),
                                  hintText: timeago.format(
                                      snapshot.data!["createdAt"].toDate()),
                                  prefixIcon: Icon(Icons.date_range),
                                ),
                              ),

                              SizedBox(
                                height: 20,
                              ),
                              SubtitleTextWidget(
                                label: "TotalPurchases: ",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: _totalPurchasesController,
                                focusNode: _totalPurchasesFocusNode,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  // hintText: userModel!.userAddress,
                                  hintText: "\$ ${tPurchases.toString()}",
                                  hintStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  prefixIcon: Icon(Icons.money),
                                ),
                                // onFieldSubmitted: (value) {
                                //   FocusScope.of(context)
                                //       .requestFocus(_phoneFocusNode);
                                // },
                                validator: (value) {
                                  return MyValidators.addressvalidator(value);
                                },
                              ),
                              // SizedBox(
                              //   width: double.infinity,
                              //   child: ElevatedButton.icon(
                              //     style: ElevatedButton.styleFrom(
                              //       padding: EdgeInsets.all(12),
                              //       backgroundColor: Colors.purpleAccent,
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(12),
                              //       ),
                              //     ),
                              //     onPressed: () async {
                              //       await updateUserDetailsFct();
                              //     },
                              //     label: Text(
                              //       "Save",
                              //       style: TextStyle(fontSize: 20),
                              //     ),
                              //     icon: Icon(IconlyLight.addUser),
                              //   ),
                              // ),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                }
              }),
        ),
      ),
    );
  }
}
