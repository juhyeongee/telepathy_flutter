import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:telepathy_flutter/kakao_login.dart';
import 'package:telepathy_flutter/main_view_model.dart';
import 'package:telepathy_flutter/screens/Home/PlanetScreen.dart';
import 'package:telepathy_flutter/screens/Intro/Intro.dart';
import '../functions/fcmController/fcmController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:telepathy_flutter/global.dart' as globals;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _storage = const FlutterSecureStorage();
  final viewModel = MainViewModel(KakaoLogin());
  final firestore = FirebaseFirestore.instance;

  late TextEditingController nameTextController;
  late TextEditingController phoneNumberTextController;

  @override
  void initState() {
    super.initState();
    nameTextController = TextEditingController();
    phoneNumberTextController = TextEditingController();

    /// 저장되어있는 유저정보가 있다면 인트로페이지로 갑니다
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? userInfo = await _storage.read(key: "UserSignInData");
      print(userInfo);

      if (userInfo != null) {
        globals.MY_PHONE_NUM = userInfo;
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const IntroScreen()),
        );
      }
    });
  }

  /// 입력 정보가 올바른지 불린을 응답합니다.
  bool isValidInput() {
    if (phoneNumberTextController.text.length != 11 ||
        phoneNumberTextController.text.substring(0, 3) != "010") {
      print(phoneNumberTextController.text);
      print("전화번호를 확인해주세요");
      return false;
    }
    // if (phoneNumberTextController.text)
    if (nameTextController.text.isEmpty) {
      print(nameTextController.text);
      print("이름이 비어있습니다");
      return false;
    }
    print("이름, 번호 유효성 확인완료!");
    return true;
  }

  Future<void> SignIn() async {
    try {
      DocumentSnapshot user = await firestore
          .collection("user")
          .doc(phoneNumberTextController.text)
          .get();
      if (user.exists) {
        print("이미 존재하는 유저입니다");
        print(user.data());
      } else {
        print("유저 정보를 저장합니다");
        await firestore
            .collection("user")
            .doc(phoneNumberTextController.text)
            .set({
          "name": nameTextController.text,
          "phoneNum": phoneNumberTextController.text
        });
      }

      addUserSignInData(
        name: nameTextController.text,
        phoneNum: phoneNumberTextController.text,
      );

      Fluttertoast.showToast(
          msg: "교신 시작합니다",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: const Color(0xff72D4A5),
          fontSize: 18.0);
      Navigator.pop(context);
    } catch (err) {
      print("signIn input err: $err");
    }
  }

  Future<void> addUserSignInData({
    required name,
    required phoneNum,
  }) async {
    await _storage.write(key: "UserSignInData", value: phoneNum);
    print("로그인 정보 저장 완료");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff1A1A22),
        body: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                // 새 로비화면 start
                children: [
                  Column(
                    children: [
                      const Text(
                        "당신의 누구인가요?",
                        style: TextStyle(
                          color: Color(0xff72D4A5),
                          fontFamily: "neodgm",
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        height: 80,

                        // ignore: prefer_const_constructors
                        child: TextField(
                          style: const TextStyle(
                            fontFamily: "neodgm",
                            fontSize: 20,
                            color: Color(0xff72D4A5),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '이름',
                            hintStyle: TextStyle(
                              color: Color(0xff479871),
                            ),
                          ),
                          controller: nameTextController,
                        ),
                      ),
                      const Text(
                        "당신의 연락처를 알려주세요",
                        style: TextStyle(
                          color: Color(0xff72D4A5),
                          fontFamily: "neodgm",
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        height: 80,
                        // ignore: prefer_const_constructors
                        child: TextField(
                          style: const TextStyle(
                            fontFamily: "neodgm",
                            fontSize: 20,
                            color: Color(0xff72D4A5),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '전화번호 11자리',
                            hintStyle: TextStyle(
                              color: Color(0xff479871),
                            ),
                          ),
                          controller: phoneNumberTextController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                color: Color(0xff72D4A5),
                                fontFamily: "neodgm",
                                fontSize: 20,
                              ),
                              backgroundColor: const Color(0xff72D4A5),
                              minimumSize: const Size(30, 45)),
                          onPressed: () async {
                            if (isValidInput()) {
                              await SignIn();
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const IntroScreen()),
                              );
                            }
                            ;
                          },
                          child: const Text(
                            "텔레파시 시작하기",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
                // 새 로비화면 end
                //
                // 기존 로비화면
                // children: [
                //   Column(
                //     children: [
                //       Text("TELEPATHY",
                //           style: TextStyle(
                //               fontSize: 50,
                //               fontFamily: "neodgm",
                //               color: Color(0xff72D4A5))),
                //       Text("Login Screen",
                //           style: TextStyle(
                //               fontSize: 25,
                //               fontFamily: "neodgm",
                //               color: Color(0xff72D4A5))),
                //     ],
                //   ),
                //   Column(
                //     children: [
                //       ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.black,
                //             foregroundColor: Colors.white),
                //         onPressed: () {
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => const PlanetScreen()));
                //         },
                //         child: Text(
                //           "회원가입하기",
                //         ),
                //       ),
                //       ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.black,
                //             foregroundColor: Colors.white),
                //         onPressed: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const IntroScreen()),
                //           );
                //         },
                //         child: Text(
                //           "인트로보기",
                //         ),
                //       ),
                //       ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.amber,
                //             foregroundColor: Colors.black),
                //         onPressed: () async {
                //           await viewModel.login();
                //           setState(() {});
                //         },
                //         child: Text(
                //           "카카오톡 로그인하기",
                //         ),
                //       ),
                //     ],
                //   ),
                //   Column(
                //     children: [
                //       Container(
                //         height: 1,
                //         width: MediaQuery.of(context).size.width,
                //         color: Colors.white,
                //       ),
                //       Text(
                //         "ETC",
                //         style: TextStyle(color: Colors.white, fontSize: 20),
                //       ),
                //       ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.amber,
                //             foregroundColor: Colors.blue),
                //         onPressed: () async {
                //           await viewModel.logout();
                //           setState(() {});
                //         },
                //         child: Text(
                //           "카카오톡 로그아웃하기",
                //         ),
                //       ),
                //       ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.blue,
                //             foregroundColor: Colors.white),
                //         onPressed: () {
                //           fcmController.sendPushNotification(
                //               userToken:
                //                   "cfZ8XEdQq0AfkOSRjb7qRm:APA91bGCd0M7wmY-4W3YbAtt_iLizXy_qmmVuQy3abQ7Wmz96eiyydgFCrDxGssawOJpKnhAZlnqJjFRWou5BIuEY7Mwj_D-epHMQLdjIvC1IOFJ--4N4gb4G_7e5F9SGuODDK-BbUJG",
                //               title: "테스트 메세지",
                //               body: "임시 메세지 입니다🚀");
                //         },
                //         child: Text(
                //           "push notification 보내기",
                //         ),
                //       ),
                //       ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.redAccent,
                //             foregroundColor: Colors.white),
                //         onPressed: () async {
                //           final result = await getData();
                //           print(result.data());
                //         },
                //         child: Text(
                //           "Firestore 정보 가져오기 ",
                //         ),
                //       )
                //     ],
                //   )

                //   // Image.network(
                //   //     viewModel.user?.kakaoAccount?.profile?.profileImageUrl ??
                //   //         ""),

                //   //
                //   // TextField(
                //   //   obscureText: false,
                //   //   decoration: InputDecoration(
                //   //       border: OutlineInputBorder(), labelText: 'Email'),
                //   // ),
                // ],
                // 기존 로비화면
                )));
    ;
  }
}
