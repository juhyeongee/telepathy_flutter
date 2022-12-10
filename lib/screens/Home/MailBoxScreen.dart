import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

class MailBoxScreen extends StatefulWidget {
  const MailBoxScreen({super.key});

  @override
  State<MailBoxScreen> createState() => _MailBoxScreenState();
}

class _MailBoxScreenState extends State<MailBoxScreen> {
  @override
  Widget build(BuildContext context) {
    void initState() {
      super.initState();
    }

    routeToWriteMessagingScreen() {
      context.go("/homeScreen/writeMessage");
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          MessageContainer(),
          MessageContainer(),
          MessageContainer(),

          //  텍스트 필드. 텍스트필드에 controller를 등록하여 리스너를 통한 핸들링
          ElevatedButton(
              onPressed: routeToWriteMessagingScreen,
              child: Text("메세지 보내러 가기")),
        ]),
      ),
    );
  }
}

class MessageContainer extends StatelessWidget {
  const MessageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff72D4A5), width: 5),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[900],
      ),
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "미지의 친구",
                  style: TextStyle(
                      fontFamily: "neodgm",
                      color: Color(0xff72D4A5),
                      fontSize: 14),
                ),
                Text(
                  "텔레파시에 가입한 것을 환영합니다",
                  style: TextStyle(
                      fontFamily: "neodgm",
                      color: Color(0xff72D4A5),
                      fontSize: 16),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
