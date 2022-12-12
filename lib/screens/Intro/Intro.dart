import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:telepathy_flutter/screens/LoginScreen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int screenNumber = 0;
  void initState() {
    setState(() {
      screenNumber = 0;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);

    final introTextList = [
      "치직 이곳은 끝없는 우주",
      "저 멀리 당신의 행성이 보입니다",
      "드넓은 우주에서 당신은 누군가의 연결을 기다리고 있습니다",
      "당신만의 행성을 만들고 다른 행성으로 교신을 시도하세요"
    ];

    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Color(0xff1E1831),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                screenNumber < 4 ? introTextList[screenNumber] : "",
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: "neodgm",
                  color: Color(0xff72D4A5),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (screenNumber == 3) {
                        context.go("/HomeScreen");
                      } else {
                        screenNumber++;
                      }
                    });
                  },
                  child: Text("Next"))
            ]),
      ),
    ));
  }
}
