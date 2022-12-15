import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WritingMessageScreen extends StatelessWidget {
  const WritingMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    final messageTextController = TextEditingController();
    final phoneNumberTextController = TextEditingController();

    void _printLatestValue() {
      print("Second text field: ${messageTextController.text}");
    }

    //같은 doc으로 보내면, 초기화가 됨
    updateMyNewMessage() {
      firestore
          .collection("messageData")
          .doc("01053618962")
          .collection("sentMessage")
          .doc("${phoneNumberTextController}")
          .set({"body": messageTextController.text});
    }

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: TextField(
              style: TextStyle(fontSize: 20, color: Colors.white),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: '전화번호 적는 곳',
                  filled: true,
                  fillColor: Colors.black54),
              maxLines: 40, // <-- SEE HERE
              minLines: 30,

              // 컨트롤러에 필드 messageTextController를 부여
              controller: phoneNumberTextController,
            ),
          ),
          SizedBox(
            height: 400,
            child: TextField(
              style: TextStyle(fontSize: 20, color: Colors.white),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: '진심으로 텔레파시를 보내보아요',
                  filled: true,
                  fillColor: Colors.black54),
              maxLines: 40, // <-- SEE HERE
              minLines: 30,

              // 컨트롤러에 필드 messageTextController를 부여
              controller: messageTextController,
            ),
          ),
          ElevatedButton(
              onPressed: updateMyNewMessage, child: Text("updateMessage"))
        ],
      ),
    );
  }
}
