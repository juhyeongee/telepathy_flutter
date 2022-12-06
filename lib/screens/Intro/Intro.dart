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
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(router.location,
            style: TextStyle(
                fontSize: 30, fontFamily: "neodgm", color: Color(0xff72D4A5))),
        ElevatedButton(
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (BuildContext context) => LoginScreen()));
              context.pop();

              // => goRouter를 통해 간단하게 이렇게 라우팅 로직을 바꿔줄 수 있습니다. 전 화면으로 가는 건 POP
            },
            child: Text("pop")),
      ]),
    );
  }
}
