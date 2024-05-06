import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';

class MyAppFunctions {
  static Future<void> showErrorOrWarningDialog(
      {required BuildContext context,
      required Function fct,
      required String subTitle,
      bool isError = true}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  isError ? AssetsManager.error : AssetsManager.warning,
                  height: 60,
                  width: 60,
                ),
                const SizedBox(
                  height: 16,
                ),
                SubtitleTextWidget(
                  label: subTitle,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      visible: !isError,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const SubtitleTextWidget(
                          label: "Cancel",
                          color: Colors.green,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        fct();
                        Navigator.pop(context);
                      },
                      child: const SubtitleTextWidget(
                        label: "Ok",
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function cameraFct,
    required Function galleryFct,
    required Function removeFct,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Center(
              child: TitleTextWidget(
                label: "Choose Option",
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      cameraFct();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("Camera"),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      galleryFct();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery"),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      removeFct();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                    label: const Text("Remove"),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
