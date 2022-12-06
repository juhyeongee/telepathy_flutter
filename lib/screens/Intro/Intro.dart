import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:telepathy_flutter/screens/LoginScreen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    void initState() {
      super.initState();
    }

    final router = GoRouter.of(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Intro Screen입니다",
                style: TextStyle(
                    fontSize: 60,
                    fontFamily: "neodgm",
                    color: Color(0xff72D4A5))),
            ElevatedButton(
                onPressed: () {
                  context.go("/homeScreen");
                },
                child: Text("HomeScreen"))
          ]),
    );
  }
}
