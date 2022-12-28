import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'HomeProvider.dart';

final firestore = FirebaseFirestore.instance;

class MailBoxScreen extends StatefulWidget {
  final telepathyInfo;
  const MailBoxScreen({super.key, required this.telepathyInfo});

  @override
  State<MailBoxScreen> createState() => _MailBoxScreenState();
}

class _MailBoxScreenState extends State<MailBoxScreen> {
  var myMessage = [];

  void initState() {
    super.initState();
  }

  routeToWriteMessagingScreen() {
    context.go("/homeScreen/writeMessage");
  }

  @override
  Widget build(BuildContext context) {
    if (widget.telepathyInfo == {}) {
      return CircularProgressIndicator();
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            Text(
              "통한 텔레파시",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            Text(
              "보낸 텔레파시",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            SentTelepathyBoxes(
                sentTelepathies: widget.telepathyInfo["sentTelepathy"]),
            Text(
              "받은 텔레파시",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            ReceivedTelepathyBoxes(
              receivedTelepathies: widget.telepathyInfo["receivedTelepathy"],
            ),
            //  텍스트 필드. 텍스트필드에 controller를 등록하여 리스너를 통한 핸들링

            ElevatedButton(
                onPressed: routeToWriteMessagingScreen,
                child: Text("메세지 보내러 가기")),
          ]),
        ),
      ),
    );
  }
}

//연결된 텔레파시들

class ConnectedTelepathyBoxes extends StatelessWidget {
  final List sentTelepathies;
  final List receivedTelepathies;

  const ConnectedTelepathyBoxes({
    super.key,
    required this.sentTelepathies,
    required this.receivedTelepathies,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//보낸 메세지들

class SentTelepathyBoxes extends StatelessWidget {
  final List sentTelepathies;
  const SentTelepathyBoxes({super.key, required this.sentTelepathies});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var sentMessage in sentTelepathies)
          MessageContainer(
            result: sentMessage,
          )
      ],
    );
  }
}

//받은 메세지들

class ReceivedTelepathyBoxes extends StatelessWidget {
  final List receivedTelepathies;
  const ReceivedTelepathyBoxes({super.key, required this.receivedTelepathies});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var sentMessage in receivedTelepathies)
          MessageContainer(
            result: sentMessage,
          )
      ],
    );
  }
}

//메시지 박스 위젯
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "010-3008-8962",
              style: TextStyle(
                  fontFamily: "neodgm", color: Color(0xff72D4A5), fontSize: 14),
            ),
            Text(
              "$result",
              style: TextStyle(
                  fontFamily: "neodgm", color: Color(0xff72D4A5), fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}
