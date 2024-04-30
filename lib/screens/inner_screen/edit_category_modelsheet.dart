import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/consts/validator.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/models/categories_model.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/loading_manager.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/services/my_app_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class EditCategoryBottomSheet extends StatefulWidget {
  EditCategoryBottomSheet(
      {super.key,
      this.categoryModel,
      required this.categoryName,
      required this.categoryImage,
      required this.categoryId,
      required this.createdAt});
  static const routeName = '/edit_category_bottomSheet';
  final CategoryModel? categoryModel;
  final String? categoryId;
  final String? categoryName;
  String? categoryImage;
  final Timestamp createdAt;
  @override
  State<EditCategoryBottomSheet> createState() =>
      _EditCategoryBottomSheetState();
}

class _EditCategoryBottomSheetState extends State<EditCategoryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  bool isLoading = false;
  bool isEditing = true;
  late TextEditingController _titleController;

  // String? productNetworkImage;
  // late String productImageUrl;

  @override
  void initState() {
    if (widget.categoryModel != null) {
      // isEditing = true;
      // widget.productNetworkImage = widget.categoryModel!.categoryImage;
    }
    isEditing = true;
    widget.categoryImage = widget.categoryImage;
    // _titleController = TextEditingController(
    //     text: widget.categoryModel == null
    //         ? ""
    //         : widget.categoryModel!.categoryName);
    _titleController = TextEditingController(text: widget.categoryName);

    super.initState();
  }

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
      widget.categoryImage = null;
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
        }).then((value) => Navigator.pop(context));

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

  Future<void> _editCategory() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
//check if he choose image or not
    if (_pickedImage == null && widget.categoryImage == null) {
      MyAppFunctions.showErrorOrWarningDialog(
          context: context, subtitle: "Please Pick an Image", fct: () {});
      return;
    }
    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });

        //store picked image to firebase storage
        if (_pickedImage != null) {
          final ref = FirebaseStorage.instance.ref();
          final imageRef =
              ref.child("categoriesImages").child('${widget.categoryId}.jpg');
          await imageRef.putFile(File(_pickedImage!.path));
          widget.categoryImage = await imageRef.getDownloadURL();
        }

        //Register user in FirebaseFirestore
        // final productId = Uuid().v4();
        await FirebaseFirestore.instance
            .collection("categories")
            .doc(widget.categoryId)
            .update({
          "categoryId": widget.categoryId,
          "categoryName": _titleController.text.trim(),
          "categoryImage": widget.categoryImage,
          "createdAt": widget.createdAt,
        });

        //SToast Message
        Fluttertoast.showToast(
            msg: "A Category has been edited!",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if (!mounted) return;
        Navigator.pop(context);
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
            // widget.categoryImage = _pickedImage as String?;
            widget.categoryImage = null;
          });
        },
        galleryFCT: () async {
          _pickedImage = await picker.pickImage(
              source: ImageSource.gallery, imageQuality: 85);
          setState(() {
            // productNetworkImage = null;
            widget.categoryImage = null;
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
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: LoadingManager(
        isLoading: isLoading,
        child: Container(
          // height: 435.0,
          color: Colors.transparent, //could change this to Color(0xFF737373),
          //so you don't have to change MaterialApp canvasColor
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100,
                      ), //Image Picker
                      //Image Picker
                      if (isEditing && widget.categoryImage != null) ...[
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.categoryImage!,
                              height: size.width * 0.4,
                              alignment: Alignment.center,
                            ),
                          ),
                        )
                      ]
                      // else if (_pickedImage == null) ...[
                      //   Center(
                      //     child: SizedBox(
                      //       width: size.width * 0.4 + 10,
                      //       height: size.width * 0.4,
                      //       child: DottedBorder(
                      //         child: Center(
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               Icon(
                      //                 Icons.image_outlined,
                      //                 size: 80,
                      //                 color: Colors.blue,
                      //               ),
                      //               TextButton(
                      //                 onPressed: () {
                      //                   localImagePicker();
                      //                 },
                      //                 child: Text("Pick Category Image"),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   )
                      // ]
                      else ...[
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(
                                _pickedImage!.path,
                              ),
                              height: size.width * 0.4,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ],
                      widget.categoryImage != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    localImagePicker();
                                  },
                                  child: Text("Pick another Image"),
                                ),
                                // TextButton(
                                //   onPressed: () {
                                //     removePickedImage();
                                //   },
                                //   child: Text(
                                //     "Remove Image",
                                //     style: TextStyle(color: Colors.red),
                                //   ),
                                // ),
                              ],
                            )
                          : SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Category Name: ",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                      SizedBox(
                        height: 10,
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
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SizedBox(
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
                                  _editCategory();
                                },
                                child: const Text(
                                  "Edit Category",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                )),
                          ),
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
