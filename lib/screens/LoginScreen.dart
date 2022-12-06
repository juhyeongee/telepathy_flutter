import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telepathy_flutter/kakao_login.dart';
import 'package:telepathy_flutter/main_view_model.dart';
import '../functions/fcmController/fcmController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final viewModel = MainViewModel(KakaoLogin());
  final firestore = FirebaseFirestore.instance;

  getData() async {
    var result = await firestore.collection('example').doc("exampleDocs").get();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff1A1A22),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("TELEPATHY",
                    style: TextStyle(
                        fontSize: 50,
                        fontFamily: "neodgm",
                        color: Color(0xff72D4A5))),
                Text("Login Screen",
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: "neodgm",
                        color: Color(0xff72D4A5))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    context.go('/intro');
                    print("읽히나?");
                  },
                  child: Text(
                    "로그인 후 다음 화면 ",
                  ),
                ),
                // Image.network(
                //     viewModel.user?.kakaoAccount?.profile?.profileImageUrl ??
                //         ""),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black),
                  onPressed: () async {
                    await viewModel.login();
                    setState(() {});
                  },
                  child: Text(
                    "카카오톡 로그인하기",
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.blue),
                  onPressed: () async {
                    await viewModel.logout();
                    setState(() {});
                  },
                  child: Text(
                    "카카오톡 로그아웃하기",
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    fcmController.sendPushNotification(
                        userToken:
                            "cfZ8XEdQq0AfkOSRjb7qRm:APA91bGCd0M7wmY-4W3YbAtt_iLizXy_qmmVuQy3abQ7Wmz96eiyydgFCrDxGssawOJpKnhAZlnqJjFRWou5BIuEY7Mwj_D-epHMQLdjIvC1IOFJ--4N4gb4G_7e5F9SGuODDK-BbUJG",
                        title: "테스트 메세지",
                        body: "임시 메세지 입니다🚀");
                  },
                  child: Text(
                    "push notification 보내기",
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white),
                  onPressed: () async {
                    final result = await getData();
                    print(result.data());
                  },
                  child: Text(
                    "Firestore 정보 가져오기 ",
                  ),
                )
                //
                // TextField(
                //   obscureText: false,
                //   decoration: InputDecoration(
                //       border: OutlineInputBorder(), labelText: 'Email'),
                // ),
              ]),
        ));
    ;
  }
}
