import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  static const int redColor = 0xffFF5B8C;
  static const int greenColor = 0xff72D4A5;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1E1831),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getTopColumn("설정"),
                  getArrowRow("내 행성 수정하기"),
                  getArrowRow("알림"),
                  getArrowRow("연락처 차단"),
                  getArrowRow("약관 및 개인정보 처리 동의"),
                  getAppVersionRow("앱 버전"),
                  getRow("고객 문의"),
                  getRow("로그아웃", redColor),
                  getRow("탈퇴하기", redColor),
                  const Padding(padding: EdgeInsets.all(0)),
                  getBox("공지사항", "팀 텔레파시가 전합니다."),
                  getBox("FAQ", "안전한 교신을 위한 거의 모든 정보"),
                ],
              )),
        ),
      ),
    );
  }

  Column getTopColumn(String text, {int colorName = greenColor}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(
          text,
          style: TextStyle(
            color: Color(colorName),
            fontFamily: "neodgm",
            fontSize: 20,
          ),
        ),
      ),
      Container(
        height: 2.0,
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(57, 51, 77, 100),
              width: 3,
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 10),
      )
    ]);
  }

  Row getArrowRow(String text, [int colorName = greenColor]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Color(colorName),
            fontFamily: "neodgm",
            fontSize: 20,
          ),
        ),
        Icon(
          Icons.navigate_next,
          color: Color(colorName),
          size: 30,
        ),
      ],
    );
  }

  Row getAppVersionRow(String text, [int colorName = greenColor]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Color(colorName),
            fontFamily: "neodgm",
            fontSize: 20,
          ),
        ),
        Text(
          "최신버전",
          style: TextStyle(
            color: Color(colorName),
            fontFamily: "neodgm",
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Row getRow(String text, [int colorName = greenColor]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Color(colorName),
            fontFamily: "neodgm",
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Container getBox(String title, String description,
      [int colorName = greenColor]) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 90,
      decoration: BoxDecoration(
          border: Border.all(
            color: Color(colorName),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Color(colorName),
                fontFamily: "neodgm",
                fontSize: 15,
              ),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            Text(
              description,
              style: TextStyle(
                color: Color(colorName),
                fontFamily: "neodgm",
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0x0039334d)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0.0, 0.0), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
