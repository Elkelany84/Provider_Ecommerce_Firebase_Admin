import 'package:flutter/material.dart';
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
            const Text(
              "Hello World",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                print("Theme is ${themeProvider.getIsDarkTheme}");
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
