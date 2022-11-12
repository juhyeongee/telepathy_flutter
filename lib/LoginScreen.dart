import 'package:flutter/material.dart';
import 'package:telepathy_flutter/kakao_login.dart';
import 'package:telepathy_flutter/main_view_model.dart';

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
