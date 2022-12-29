import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:telepathy_flutter/kakao_login.dart';
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
    final introTextList = [
      "치직,\n이곳은 끝없는 우주...",
      "저 멀리 당신의 행성이 보입니다.",
      "드넓은 우주에서\n누군가 당신과의 연결을\n기다리고 있습니다.",
      "당신만의 행성을 만들고\n다른 행성으로 교신을 시도하세요."
    ];

    return Scaffold(
        body: Container(
      decoration: getBackground(screenNumber),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 250, 20, 100),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                screenNumber < 4 ? introTextList[screenNumber] : "",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: "neodgm",
                  height: 1.5,
                  color: Color(0xff72D4A5),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(75, 15, 75, 15)),
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(114, 212, 165, 0.1)),
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.white, width: 2)),
                ),
                onPressed: () {
                  setState(() {
                    if (screenNumber == 3) {
                      KakaoLogin().login();
                    } else {
                      screenNumber++;
                    }
                  });
                },
                child: const Text(
                  "NEXT",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "neodgm",
                    color: Color(0xff72D4A5),
                  ),
                ),
              )
            ]),
      ),
    ));
  }

  BoxDecoration getBackground(int screenNumber) {
    List<String> arr = [
      'assets/images/intro1.png',
      'assets/images/intro2.png',
      'assets/images/intro3.png',
      'assets/images/intro4.png'
    ];
    return BoxDecoration(
      color: Color(0xff1E1831),
      image: DecorationImage(
        image: AssetImage(arr[screenNumber]),
        fit: BoxFit.contain,
      ),
    );
  }
}
