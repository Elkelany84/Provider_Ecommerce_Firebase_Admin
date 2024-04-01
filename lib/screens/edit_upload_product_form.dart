import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/consts/app_constants.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/consts/validator.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/services/my_app_functions.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_adminpanel/widgets/title_text.dart';
import 'package:image_picker/image_picker.dart';

class EditOrUploadProductForm extends StatefulWidget {
  const EditOrUploadProductForm({super.key});
  static const routeName = '/edit-or-upload-product-form';
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

  @override
  void initState() {
    _titleController = TextEditingController(text: "");
    _priceController = TextEditingController(text: "");
    _descriptionController = TextEditingController(text: "");
    _quantityController = TextEditingController(text: "");
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
    if (_pickedImage != null) {
      File(_pickedImage!.path).delete();
      setState(() {
        _pickedImage = null;
      });
    }
  }

  Future<void> _uploadProduct() async {
    if (_pickedImage == null) {
      MyAppFunctions.showErrorOrWarningDialog(
          context: context, subtitle: "Please Pick an Image", fct: () {});
      return;
    }
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {}
  }

  Future<void> _editProduct() async {
    if (_pickedImage == null) {
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
    return GestureDetector(
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
                  onPressed: () {},
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
                    _uploadProduct();
                  },
                  icon: const Icon(Icons.upload),
                  label: const Text(
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
          title: const TitlesTextWidget(
            label: "Upload a New Product",
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
                _pickedImage == null
                    ? SizedBox(
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
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(
                            _pickedImage!.path,
                          ),
                          height: size.width * 0.4,
                          alignment: Alignment.center,
                        ),
                      ),
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
                                        toBeReturnedString: "Price is Missing");
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
                            controller: _quantityController,
                            key: ValueKey("Description"),
                            maxLength: 1000,
                            maxLines: 8,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            decoration:
                                InputDecoration(hintText: "Description"),
                            validator: (value) {
                              MyValidators.uploadProdTexts(
                                  value: value,
                                  toBeReturnedString: "Description is Missing");
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
    );
  }
}
