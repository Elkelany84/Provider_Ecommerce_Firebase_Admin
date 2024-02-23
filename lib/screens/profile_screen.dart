import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/theme_provider.dart';
import 'package:hadi_ecommerce_firebase_admin/services/assets_manager.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/app_name_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/subtitle_text.dart';
import 'package:hadi_ecommerce_firebase_admin/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
        title: AppNameTextWidget(
          label: "Profile Screen",
          fontSize: 22,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Visibility(
              visible: false,
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: TitleTextWidget(
                    label: "Please Login To Have Unlimited Access"),
              ),
            ),
            Visibility(
              visible: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                            width: 3,
                            color: Theme.of(context).colorScheme.background),
                        image: const DecorationImage(
                            image: NetworkImage(
                              "https://images.unsplash.com/photo-1635324236775-868d3680b65f?q=80&w=1892&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                            ),
                            fit: BoxFit.fill),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleTextWidget(label: "Ahmed Elkelany"),
                        SizedBox(
                          height: 6,
                        ),
                        SubtitleTextWidget(label: "ahmed@gmail.com")
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Divider(
                thickness: 3,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(14.0),
              child: Column(
                children: [
                  TitleTextWidget(label: "General"),
                ],
              ),
            ),
            CustomListTile(
              label: "All Orders",
              imagePath: AssetsManager.orderSvg,
              onTab: () {},
            ),
            SizedBox(
              height: 10,
            ),
            CustomListTile(
              label: "WishList",
              imagePath: AssetsManager.wishlistSvg,
              onTab: () {},
            ),
            SizedBox(
              height: 10,
            ),
            CustomListTile(
              label: "Viewed Recently",
              imagePath: AssetsManager.recent,
              onTab: () {},
            ),
            SizedBox(
              height: 10,
            ),
            CustomListTile(
              label: "Address",
              imagePath: AssetsManager.address,
              onTab: () {},
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Divider(
                thickness: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TitleTextWidget(label: "Settings"),
            ),
            SwitchListTile(
                secondary: Image.asset(
                  AssetsManager.theme,
                  height: 34,
                ),
                title: Text(
                    themeProvider.getIsDarkTheme ? "DarkMode" : "LightMode"),
                value: themeProvider.getIsDarkTheme,
                onChanged: (value) {
                  themeProvider.setDarkTheme(value);
                }),
            SizedBox(
              height: 30,
            ),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                label: Text(
                  "Log Out",
                  style: TextStyle(fontSize: 20),
                ),
                icon: Icon(Icons.logout),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.label,
      required this.imagePath,
      required this.onTab});

  final String label;
  final String imagePath;
  final Function() onTab;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTab,
      title: SubtitleTextWidget(
        label: label,
      ),
      leading: Image.asset(
        imagePath,
        height: 34,
      ),
      trailing: Icon(IconlyLight.arrowRight2),
    );
  }
}
