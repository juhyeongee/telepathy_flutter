import 'package:flutter/material.dart';
import 'package:telepathy_flutter/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("LoginScreen")),
        body: Column(children: [
          Text("Email"),
          TextField(
            obscureText: false,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Email'),
          ),
          Text("Password "),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Password'),
          ),
          GestureDetector(
              onTap: () {
                AuthService().signInWithGoogle();
              },
              child: Container(
                  child: Text("Let's Google LogIn, Click this",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          backgroundColor: Colors.pink, fontSize: 25))))
        ]));
    ;
  }
}
