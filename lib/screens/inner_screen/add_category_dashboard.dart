import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/consts/validator.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/providers/categories_provider.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/categories_screen.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/loading_manager.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/services/my_app_functions.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/title_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddCategoryDashboard extends StatefulWidget {
  const AddCategoryDashboard({super.key});
  static const routeName = '/add_category_dashboard';

  @override
  State<AddCategoryDashboard> createState() => _AddCategoryDashboardState();
}

class _AddCategoryDashboardState extends State<AddCategoryDashboard> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  bool isLoading = false;
  final TextEditingController _titleController = TextEditingController();
  String? productImageUrl;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _titleController.clear();
    removePickedImage();
  }

  void removePickedImage() {
    setState(() {
      _pickedImage = null;
      // productNetworkImage = null;
    });
  }

  Future<void> _uploadCategory() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
//check if he choose image or not
    if (_pickedImage == null) {
      MyAppFunctions.showErrorOrWarningDialog(
          context: context, fct: () {}, subtitle: "Please Choose an Image");
      return;
    }
    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });

        //store picked image to firebase storage
        final categoryId = Uuid().v4();
        final ref = FirebaseStorage.instance.ref();
        final imageRef = ref.child("categoriesImages").child('$categoryId.jpg');
        await imageRef.putFile(File(_pickedImage!.path));
        final imageUrl = await imageRef.getDownloadURL();

        //Register user in FirebaseFirestore

        await FirebaseFirestore.instance
            .collection("categories")
            .doc(categoryId)
            .set({
          "categoryId": categoryId,
          "categoryName": _titleController.text.trim(),
          "categoryImage": imageUrl,
          "createdAt": Timestamp.now(),
        }).then((value) => Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const CategoriesScreen(),
                  ),
                ));
        // await categoriesProvider.countCategories();
        //SToast Message
        Fluttertoast.showToast(
            msg: "A Category has been added!",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if (!mounted) return;

        // MyAppFunctions.showErrorOrWarningDialog(
        //     isError: false,
        //     context: context,
        //     subtitle: "Clear Form",
        //     fct: () {
        //       _clearForm();
        //     });
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

  Future<void> localImagePicker() async {
    final picker = ImagePicker();
    await MyAppFunctions.imagePickerDialog(
        context: context,
        cameraFCT: () async {
          _pickedImage = await picker.pickImage(
              source: ImageSource.camera, imageQuality: 85);
          setState(() {
            // productNetworkImage = null;
          });
        },
        galleryFCT: () async {
          _pickedImage = await picker.pickImage(
              source: ImageSource.gallery, imageQuality: 85);
          setState(() {
            // productNetworkImage = null;
          });
        },
        removeFCT: () async {
          setState(() {
            _pickedImage = null;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(
      context,
    );
    Size size = MediaQuery.of(context).size;
    return LoadingManager(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: TitlesTextWidget(
            label: "Add Category",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12.0),
                  topRight: const Radius.circular(12.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Image Picker
                      if (_pickedImage == null) ...[
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              localImagePicker();
                            },
                            child: SizedBox(
                              width: size.width * 0.4 + 10,
                              height: size.width * 0.4,
                              child: DottedBorder(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_outlined,
                                        size: 80,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        "Pick Category Image",
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ] else ...[
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(
                                _pickedImage!.path,
                              ),
                              height: size.width * 0.3,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ],
                      _pickedImage != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    localImagePicker();
                                  },
                                  child: Text("Pick another Image"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    removePickedImage();
                                  },
                                  child: Text(
                                    "Remove Image",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Category Name: ",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _titleController,
                          key: ValueKey("Title"),
                          maxLength: 80,
                          maxLines: 1,
                          minLines: 1,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.newline,
                          decoration:
                              InputDecoration(hintText: "Category Name"),
                          validator: (value) {
                            return MyValidators.uploadProdTexts(
                                value: value,
                                toBeReturnedString:
                                    "Please Enter Valid Category Name");
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Material(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  // textStyle: TextStyle(color: Colors.white),
                                  padding: const EdgeInsets.all(10),
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              onPressed: () {
                                _uploadCategory();
                                // await categoriesProvider.countCategories();
                              },
                              child: const Text(
                                "Add Category",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
