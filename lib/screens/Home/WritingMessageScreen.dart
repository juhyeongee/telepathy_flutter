import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WritingMessageScreen extends StatelessWidget {
  const WritingMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    final myController = TextEditingController();
    void _printLatestValue() {
      print("Second text field: ${myController.text}");
    }

    getMyMessage() async {
      var result =
          await firestore.collection('messageData').doc("01053618962").get();
      return result;
    }

    sendMyNewMessage() {
      firestore
          .collection("messageData")
          .doc("01053618962")
          .set({"to": "01011111111", "from": "010", "message": "코드로 보내본 메세지"});
    }

    //같은 doc으로 보내면, 초기화가 됨
    updateMyNewMessage() {
      firestore.collection("messageData").doc("01053618962").set(
          {"to": "01033333333", "from": "01022222222", "message": "update"},
          SetOptions(merge: true));
    }

    return Scaffold(
      body: Column(
        children: [
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

              // 컨트롤러에 필드 myController를 부여
              controller: myController,
            ),
          ),
          ElevatedButton(
              onPressed: sendMyNewMessage, child: Text("SendMessage")),
          ElevatedButton(onPressed: getMyMessage, child: Text("getMyMessage")),
          ElevatedButton(
              onPressed: updateMyNewMessage, child: Text("updateMessage"))
        ],
      ),
    );
  }
}
