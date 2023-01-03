import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1E1831),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getArrowRow("설정"),
                  getArrowRow("내 행성 수정하기"),
                  getArrowRow("알림"),
                  getArrowRow("연락처 차단"),
                  getArrowRow("약관 및 개인정보 처리 동의"),
                  getArrowRow("앱 버전"),
                  getArrowRow("고객 문의"),
                  getArrowRow("로그아웃"),
                  getArrowRow("탈퇴하기"),
                ],
              )),
        ),
      ),
    );
  }
}

Row getArrowRow(String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        text,
        style: const TextStyle(
          color: Color(0xff72D4A5),
          fontFamily: "neodgm",
          fontSize: 20,
        ),
      ),
      const Icon(
        Icons.navigate_next,
        color: Color(0xff72D4A5),
        size: 30,
      ),
    ],
  );
}

Padding getPadding(double point) {
  return Padding(padding: EdgeInsets.all(point));
}
