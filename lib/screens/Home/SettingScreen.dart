import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text(
        "settingScreen",
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
    ));
  }
}
