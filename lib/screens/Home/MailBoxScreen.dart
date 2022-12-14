import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

final firestore = FirebaseFirestore.instance;

Future<Object?> getMyReceivedMessage() async {
  DocumentSnapshot messageBodyResult = await firestore
      .collection('messageData')
      .doc("01053618962")
      .collection("receivedMessage")
      .doc("01030088962")
      .get();

  Map<String, dynamic> converted =
      jsonDecode(jsonEncode(messageBodyResult.data()));
  String messageBody = converted['body'];

  return messageBody;
}

Future<Object?> getMySentMessage() async {
  DocumentSnapshot result = await firestore
      .collection('messageData')
      .doc("01053618962")
      .collection("sentMessage")
      .doc("01030088962")
      .get();

  Map<String, dynamic> converted = jsonDecode(jsonEncode(result.data()));
  String messageBody = converted['body'];

  return messageBody;
}

class MailBoxScreen extends StatefulWidget {
  const MailBoxScreen({super.key});

  @override
  State<MailBoxScreen> createState() => _MailBoxScreenState();
}

class _MailBoxScreenState extends State<MailBoxScreen> {
  var myMessage = [];

  void initState() {
    super.initState();
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

  routeToWriteMessagingScreen() {
    context.go("/homeScreen/writeMessage");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          Text(
            "보낸 메세지",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          SentMessageBoxes(),
          Text(
            "받은 메세지",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          ReceivedMessageBoxes(),
          //  텍스트 필드. 텍스트필드에 controller를 등록하여 리스너를 통한 핸들링
          ElevatedButton(
              onPressed: routeToWriteMessagingScreen,
              child: Text("메세지 보내러 가기")),
        ]),
      ),
    );
  }
}

class SentMessageBoxes extends StatefulWidget {
  const SentMessageBoxes({super.key});

  @override
  State<SentMessageBoxes> createState() => _SentMessageBoxesState();
}

class _SentMessageBoxesState extends State<SentMessageBoxes> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMySentMessage(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return CircularProgressIndicator();
        }
        //error가 발생하게 될 경우 반환하게 되는 부분
        else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(fontSize: 15),
            ),
          );
        }
        // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
        else {
          return MessageContainer(
            result: snapshot.data,
          );
        }
      },
    );
  }
}

class ReceivedMessageBoxes extends StatefulWidget {
  const ReceivedMessageBoxes({super.key});

  @override
  State<ReceivedMessageBoxes> createState() => _ReceivedMessageBoxesState();
}

class _ReceivedMessageBoxesState extends State<ReceivedMessageBoxes> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMyReceivedMessage(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return CircularProgressIndicator();
        }
        //error가 발생하게 될 경우 반환하게 되는 부분
        else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(fontSize: 15),
            ),
          );
        }
        // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
        else {
          return MessageContainer(
            result: snapshot.data,
          );
        }
      },
    );
  }
}

class MessageContainer extends StatelessWidget {
  const MessageContainer({super.key, required this.result, this.phoneNumber});
  final result;
  final phoneNumber;

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
                  "010-3008-8962",
                  style: TextStyle(
                      fontFamily: "neodgm",
                      color: Color(0xff72D4A5),
                      fontSize: 14),
                ),
                Text(
                  "$result",
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
