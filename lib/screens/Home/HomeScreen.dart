// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:telepathy_flutter/kakao_login.dart';
// import 'package:telepathy_flutter/main_view_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'HomeProvider.dart';
// import 'MailBoxScreen.dart';
// import 'PlanetScreen.dart';
// import 'SettingScreen.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   int _selectedIndex = 0; // 선택된 페이지의 인덱스 넘버 초기화

//   // 3개의 페이지를 연결할 예정이므로 3개의 페이지를 여기서 지정해준다. 탭 레이아웃은 3개.

//   void _onItemTapped(int index) {
//     // 탭을 클릭했을떄 지정한 페이지로 이동
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final telepathyInfos = ref.watch(telepathyInfoProvider);
//     final List<Widget> _widgetOptions = <Widget>[
//       PlanetScreen(),
//       MailBoxScreen(
//         telepathyInfo: telepathyInfos,
//       ),
//       SettingScreen(),
//     ];

//     return PlanetScreen();

//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 14, 7, 34),
//       body: Container(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       // * tab- rerender 방지용 코드, 필요하면 사용
//       // body: IndexedStack(
//       //   index: _selectedIndex,
//       //   children: _widgetOptions,
//       // ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: new Image.asset('assets/planetIcon.png'),
//             label: '행성',
//           ),
//           BottomNavigationBarItem(
//             icon: new Image.asset('assets/computerIcon.png'),
//             label: '컴퓨터',
//           ),
//           BottomNavigationBarItem(
//             icon: new Image.asset('assets/settingIcon.png'),
//             label: '설정',
//           ),
//         ],
//         currentIndex: _selectedIndex, // 지정 인덱스로 이동
//         backgroundColor: Colors.black,
//         selectedItemColor: Colors.purple,
//         unselectedItemColor: Colors.white,
//         unselectedFontSize: 20,
//         selectedFontSize: 20,
//         onTap: _onItemTapped, // 선언했던 onItemTapped
//       ),
//     );
//   }
// }
