import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const MY_PHONE_NUM = "01053618962";

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
    void updateMyNewMessage() async {
      await firestore
          .collection("messageData")
          .doc(MY_PHONE_NUM)
          .collection("sentMessage")
          .doc(phoneNumberTextController.text)
          .set({
        "body": messageTextController.text,
        "targetPhoneNum": phoneNumberTextController.text
      });
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Color(0xff1E1831),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                "보내기",
                style: TextStyle(
                  color: Color(0xff72D4A5),
                  fontFamily: "neodgm",
                  fontSize: 20,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  "to.",
                  style: TextStyle(
                    color: Color(0xff72D4A5),
                    fontFamily: "neodgm",
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 60,
                  child: TextField(
                    style: const TextStyle(
                      fontFamily: "neodgm",
                      fontSize: 20,
                      color: Color(0xff72D4A5),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '전화번호를 입력하세요',
                      hintStyle: TextStyle(
                        color: Color(0xff479871),
                      ),
                    ),

                    // decoration: const InputDecoration(
                    //   enabledBorder: OutlineInputBorder(
                    //     borderSide: BorderSide(width: 3, color: Color(0xff479871)),
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //   ),
                    //   focusedBorder: OutlineInputBorder(
                    //     borderSide: BorderSide(width: 3, color: Color(0xff72D4A5)),
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //   ),
                    //   hintText: '전화번호 적는 곳',
                    //   hintStyle: TextStyle(color: Color(0xff479871)),
                    //   filled: true,
                    // ),
                    // maxLines: null, // <-- SEE HERE
                    // minLines: 20,

                    // 컨트롤러에 필드 messageTextController를 부여
                    controller: phoneNumberTextController,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 500,
              child: TextField(
                style: const TextStyle(
                    fontFamily: "neodgm",
                    fontSize: 20,
                    color: Color(0xff72D4A5)),
                decoration: const InputDecoration(
                  fillColor: Color(0xff1E1831),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Color(0xff479871)),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Color(0xff72D4A5)),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: '여기에 텔레파시 입력',
                  hintStyle: TextStyle(color: Color(0xff479871)),
                  filled: true,
                ),
                maxLines: null, // <-- SEE HERE
                minLines: 70,

                // 컨트롤러에 필드 messageTextController를 부여
                controller: messageTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                      color: Color(0xff72D4A5),
                      fontFamily: "neodgm",
                      fontSize: 20,
                    ),
                    backgroundColor: Color(0xff30453B),
                    minimumSize: Size(40, 50)),
                onPressed: updateMyNewMessage,
                child: Text(
                  "임시저장",
                  style: TextStyle(color: Color(0xff72D4A5)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                      color: Color(0xff72D4A5),
                      fontFamily: "neodgm",
                      fontSize: 20,
                    ),
                    backgroundColor: Color(0xff72D4A5),
                    minimumSize: Size(40, 50)),
                onPressed: updateMyNewMessage,
                child: Text(
                  "메세지 보내기",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
