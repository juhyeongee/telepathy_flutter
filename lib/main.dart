import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:telepathy_flutter/Intro.dart';
import 'package:telepathy_flutter/LoginScreen.dart';
import 'firebase_options.dart';

void main() async {
  KakaoSdk.init(nativeAppKey: "21af5e54154aa1f80dce5e0cad4ab097");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const LoginScreen());
  }
}
