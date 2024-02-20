import 'package:flutter/material.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      // backgroundColor: AppColors.lightScaffoldColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SubtitleTextWidget(
              label: "Hello",
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              textDecoration: TextDecoration.underline,
              fontStyle: FontStyle.italic,
            ),
            TitleTextWidget(
              label: "Hello Title" * 10,
            ),
            ElevatedButton(
              onPressed: () {
                // print("Theme is ${themeProvider.getIsDarkTheme}");
              },
              child: const Text("Change Theme"),
            ),
            SwitchListTile(
                title: Text(
                    themeProvider.getIsDarkTheme ? "DarkMode" : "LightMode"),
                value: themeProvider.getIsDarkTheme,
                onChanged: (value) {
                  themeProvider.setDarkTheme(value);
                })
          ],
        ),
      ),
    );
  }
}
