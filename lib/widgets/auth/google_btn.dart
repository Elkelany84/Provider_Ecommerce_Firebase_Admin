import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: EdgeInsets.all(12),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () async {},
      label: Text(
        "SignIn With Google",
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
      icon: Icon(
        Ionicons.logo_google,
        color: Colors.red,
      ),
    );
  }
}
