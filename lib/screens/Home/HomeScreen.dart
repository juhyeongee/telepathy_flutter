import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telepathy_flutter/kakao_login.dart';
import 'package:telepathy_flutter/main_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'MailBoxScreen.dart';
import 'PlanetScreen.dart';
import 'SettingScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // 선택된 페이지의 인덱스 넘버 초기화

  final List<Widget> _widgetOptions = <Widget>[
    PlanetScreen(),
    MailBoxScreen(),
    SettingScreen(),
  ]; // 3개의 페이지를 연결할 예정이므로 3개의 페이지를 여기서 지정해준다. 탭 레이아웃은 3개.

  void _onItemTapped(int index) {
    // 탭을 클릭했을떄 지정한 페이지로 이동
    setState(() {
      _selectedIndex = index;
    });
  }

  void initState() {
    super.initState();
  }

  // 방법 3개 다 doc안에 내용이 포개어 지는데? 다 업데이트 되어버림 추가로 add가 되지 않고
  // 내려받아 와서, spread 문법으로 다시 추가해서 update해주는 방향으로
  // updateMyNewMessage() {
  //   firestore.collection("messageData").doc("01053618962").set(
  //       {"to": "01033333333", "from": "01022222222", "message": "update"},
  //       );
  // }
  // updateMyNewMessage() {
  //     firestore.collection("messageData").doc("01053618962").update(
  //       {"to": "01033333333", "from": "01077777777", "message": "update Method"},
  //     );
  //   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 14, 7, 34),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: new Image.asset('assets/planetIcon.png'),
            label: '행성',
          ),
          BottomNavigationBarItem(
            icon: new Image.asset('assets/computerIcon.png'),
            label: '컴퓨터',
          ),
          BottomNavigationBarItem(
            icon: new Image.asset('assets/settingIcon.png'),
            label: '설정',
          ),
        ],
        currentIndex: _selectedIndex, // 지정 인덱스로 이동
        backgroundColor: Colors.black,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.white,
        unselectedFontSize: 20,
        selectedFontSize: 20,
        onTap: _onItemTapped, // 선언했던 onItemTapped
      ),
    );
  }
}
