import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/consts/app_constants.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/consts/validator.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/models/product_model.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/screens/loading_manager.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/services/my_app_functions.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/title_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class EditOrUploadProductForm extends StatefulWidget {
  const EditOrUploadProductForm({super.key, this.productModel});
  static const routeName = '/edit-or-upload-product-form';
  final ProductModel? productModel;
  @override
  State<EditOrUploadProductForm> createState() =>
      _EditOrUploadProductFormState();
}

class _EditOrUploadProductFormState extends State<EditOrUploadProductForm> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;

  late TextEditingController _titleController,
      _priceController,
      _descriptionController,
      _quantityController;
  String? _categoryValue;
  bool isEditing = false;
  String? productNetworkImage;
  bool isLoading = false;

  @override
  void initState() {
    if (widget.productModel != null) {
      _categoryValue = widget.productModel!.productCategory;
      isEditing = true;
      productNetworkImage = widget.productModel!.productImage;
    }
    _titleController = TextEditingController(
        text: widget.productModel == null
            ? ""
            : widget.productModel!.productTitle);
    _priceController = TextEditingController(
        text: widget.productModel == null
            ? ""
            : widget.productModel!.productPrice);
    _descriptionController =
        TextEditingController(text: widget.productModel?.productDescription);
    _quantityController = TextEditingController(
        text: widget.productModel == null
            ? ""
            : widget.productModel!.productQuantity);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    removePickedImage();
  }

  void removePickedImage() {
    setState(() {
      _pickedImage = null;
      productNetworkImage = null;
    });
  }

  Future<void> _uploadProduct() async {
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
        final ref = FirebaseStorage.instance.ref();
        final imageRef = ref
            .child("productsImages")
            .child('${_titleController.text} + ".jpg"');
        await imageRef.putFile(File(_pickedImage!.path));
        final imageUrl = await imageRef.getDownloadURL();

        //Register user in FirebaseFirestore
        final productId = Uuid().v4();
        await FirebaseFirestore.instance
            .collection("products")
            .doc(productId)
            .set({
          "productId": productId,
          "productTitle": _titleController.text.trim(),
          "productCategory": _categoryValue,
          "productDescription": _descriptionController.text,
          "userImage": imageUrl,
          "createdAt": Timestamp.now(),
          "productQuantity": _quantityController.text,
        });

        //SToast Message
        Fluttertoast.showToast(
            msg: "A Product has been added!",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if (!mounted) return;
        MyAppFunctions.showErrorOrWarningDialog(
            isError: false,
            context: context,
            subtitle: "Clear Form",
            fct: () {
              _clearForm();
            });
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

  Future<void> _editProduct() async {
    if (_pickedImage == null && productNetworkImage == null) {
      MyAppFunctions.showErrorOrWarningDialog(
          context: context, subtitle: "Please Pick an Image", fct: () {});
      return;
    }
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {}
  }

  Future<void> localImagePicker() async {
    final picker = ImagePicker();
    await MyAppFunctions.imagePickerDialog(
        context: context,
        cameraFCT: () async {
          _pickedImage = await picker.pickImage(source: ImageSource.camera);
          setState(() {});
        },
        galleryFCT: () async {
          _pickedImage = await picker.pickImage(source: ImageSource.gallery);
          setState(() {});
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
    return LoadingManager(
      isLoading: isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          bottomSheet: SizedBox(
            height: kBottomNavigationBarHeight + 10,
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    onPressed: () {
                      _clearForm();
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text(
                      "Clear",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        // backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    onPressed: () {
                      if (isEditing) {
                        _editProduct();
                      } else {
                        _uploadProduct();
                      }
                    },
                    icon: const Icon(Icons.upload),
                    label: isEditing
                        ? const Text(
                            "Edit Product",
                            style: TextStyle(fontSize: 20),
                          )
                        : Text(
                            "Upload Product",
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: TitlesTextWidget(
              label: isEditing ? "Edit Product" : "Upload a New Product",
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),

                  //Image Picker
                  if (isEditing && productNetworkImage != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        productNetworkImage!,
                        height: size.width * 0.5,
                        alignment: Alignment.center,
                      ),
                    )
                  ] else if (_pickedImage == null) ...[
                    SizedBox(
                      width: size.width * 0.4 + 10,
                      height: size.width * 0.4,
                      child: DottedBorder(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 80,
                                color: Colors.blue,
                              ),
                              TextButton(
                                onPressed: () {
                                  localImagePicker();
                                },
                                child: Text("Pick Product Image"),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ] else ...[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(
                            _pickedImage!.path,
                          ),
                          height: size.width * 0.4,
                          alignment: Alignment.center,
                        ))
                  ],
                  _pickedImage != null || productNetworkImage != null
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
                    height: 10,
                  ),
                  //DropDown Widget
                  DropdownButton(
                      items: AppConstants.categoriesDropDownList,
                      value: _categoryValue,
                      hint: Text("Choose a Category"),
                      onChanged: (String? value) {
                        setState(() {
                          _categoryValue = value;
                        });
                      }),
                  const SizedBox(
                    height: 25,
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _titleController,
                              key: ValueKey("Title"),
                              maxLength: 80,
                              maxLines: 2,
                              minLines: 1,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              decoration:
                                  InputDecoration(hintText: "Product Name"),
                              validator: (value) {
                                MyValidators.uploadProdTexts(
                                    value: value,
                                    toBeReturnedString:
                                        "Please Enter Valid Product Name");
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: _priceController,
                                    key: ValueKey("Price \$"),
                                    maxLength: 5,
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'),
                                      ),
                                    ],
                                    decoration: InputDecoration(
                                      hintText: "Price",
                                      prefix: SubtitleTextWidget(
                                        label: "\$",
                                        color: Colors.blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                    validator: (value) {
                                      MyValidators.uploadProdTexts(
                                          value: value,
                                          toBeReturnedString:
                                              "Price is Missing");
                                    },
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: _quantityController,
                                    key: ValueKey("Quantity"),
                                    maxLength: 5,
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]"),
                                      )
                                    ],
                                    decoration:
                                        InputDecoration(hintText: "Quantity"),
                                    validator: (value) {
                                      MyValidators.uploadProdTexts(
                                          value: value,
                                          toBeReturnedString:
                                              "Quantity is Missing");
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _descriptionController,
                              key: ValueKey("Description"),
                              maxLength: 1000,
                              maxLines: 5,
                              minLines: 1,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.sentences,
                              decoration:
                                  InputDecoration(hintText: "Description"),
                              validator: (value) {
                                MyValidators.uploadProdTexts(
                                    value: value,
                                    toBeReturnedString:
                                        "Description is Missing");
                              },
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
