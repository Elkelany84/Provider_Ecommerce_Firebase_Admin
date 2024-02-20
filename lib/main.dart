import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hadi_ecommerce_firebase_admin/constants/theme_data.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/theme_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return ThemeProvider();
        })
      ],
      child: Consumer<ThemeProvider>(
        builder: (builder, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ShopSmart',
            theme: Styles.themeData(
                isDarkTheme: themeProvider.getIsDarkTheme, context: context),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
