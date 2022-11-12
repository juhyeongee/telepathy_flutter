import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black),
                  onPressed: () {
                    print("kakao Login");
                  },
                  child: Text(
                    "카카오톡 로그인하기",
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
