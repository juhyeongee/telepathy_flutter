import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "settingScreen",
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
    );
  }
}
