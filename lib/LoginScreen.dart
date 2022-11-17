import 'package:flutter/material.dart';
import 'package:telepathy_flutter/kakao_login.dart';
import 'package:telepathy_flutter/main_view_model.dart';
import 'functions/fcmController/fcmController.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final viewModel = MainViewModel(KakaoLogin());

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
                // Image.network(
                //     viewModel.user?.kakaoAccount?.profile?.profileImageUrl ??
                //         ""),
                Text(
                  '${viewModel.isLoggedIn}',
                  style: TextStyle(color: Colors.white10),
                ),
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
                        body: "임시 메세지 입니다");
                  },
                  child: Text(
                    "push notification 보내기",
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
