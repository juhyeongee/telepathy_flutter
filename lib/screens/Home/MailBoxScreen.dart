import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telepathy_flutter/screens/Home/WritingMessageScreen.dart';

import 'HomeProvider.dart';

enum DataType {
  text,
  type,
  sentTime,
  senderPhoneNum,
  targetPhoneNum,
  received,
  sent
}

final firestore = FirebaseFirestore.instance;

/* 메세지 프로바이더~ */
final messagesProvider = Provider<Map>((ref) {
  final allTelepathyData = ref.watch(telepathyRawDataProvider);

  List receivedTelepathyList = [];
  List sentTelepathyList = [];
  allTelepathyData.forEach((key, value) {
    if (value["type"] == "received") {
      receivedTelepathyList.add(value);
    } else {
      sentTelepathyList.add(value);
    }
  });

  return {
    "receivedTelepathyList": receivedTelepathyList,
    "sentTelepathyList": sentTelepathyList
  };
});

class MailBoxScreen extends ConsumerStatefulWidget {
  const MailBoxScreen({super.key});

  @override
  ConsumerState<MailBoxScreen> createState() => _MailBoxScreenState();
}

class _MailBoxScreenState extends ConsumerState<MailBoxScreen> {
  bool messageSwitch = false;
  bool connectedTelepathySwitch = false;

  var myMessage = [];

  void initState() {
    super.initState();
    messageSwitch = false;
    ref.read(messagesProvider);
    // getMySentTelepathyList();
  }

  routeToWriteMessagingScreen() {
    // context.go("/homeScreen/writeMessage");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WritingMessageScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final telepathyInfo = ref.watch(messagesProvider);

    Future<void> refresh() async {
      ref.read(telepathyRawDataProvider.notifier).initializeTelepathyInfo();
      print("initializeTelepathyInfo read 완료");
      setState(() {});
    }

    // if (telepathyInfo == {}) {
    //   return CircularProgressIndicator();
    // }

    return Scaffold(
      backgroundColor: Color(0xff1E1831),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //HEADER
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (messageSwitch == true)
                              setState(() {
                                messageSwitch = false;
                              });
                          },
                          child: Text(
                            "받은 텔레파시",
                            style: TextStyle(
                              color: messageSwitch ? Colors.grey : Colors.white,
                              fontSize: 22,
                              fontFamily: "neodgm",
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (messageSwitch == false)
                              setState(() {
                                messageSwitch = true;
                              });
                          },
                          child: Text(
                            "보낸 텔레파시",
                            style: TextStyle(
                              color: messageSwitch ? Colors.white : Colors.grey,
                              fontSize: 22,
                              fontFamily: "neodgm",
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 50,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Container(
                        color: Colors.grey,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "교신 텔레파시만 보기",
                      //이거 토글의 역할이 좀 이상한데..?
                      style: TextStyle(
                        color: Color(0xff72D4A5),
                        fontFamily: "neodgm",
                        fontSize: 15,
                      ),
                    ),
                    Switch(
                      activeTrackColor: const Color(0xff72D4A5),
                      activeColor: Color(0xff72D4A5),
                      onChanged: (value) {
                        setState(() {
                          connectedTelepathySwitch = !connectedTelepathySwitch;
                        });
                      },
                      value: connectedTelepathySwitch,
                    ),
                  ],
                ),
              ),
              //BODY
              Expanded(
                flex: 12,
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            //   SentTelepathyBoxes(
                            //       sentTelepathies:
                            //           telepathyInfo["sentTelepathy"]),
                            // if (messageSwitch == false)
                            //   //  텍스트 필드. 텍스트필드에 controller를 등록하여 리스너를 통한 핸들링
                            //   ReceivedTelepathyBoxes(
                            //     receivedTelepathies:
                            //         telepathyInfo["receivedTelepathy"],
                            //   ),
                            // if (messageSwitch == false)
                            //   NewReceivedTelepathyBoxes(
                            //     receivedTelepathies:
                            //         telepathyInfo["receivedTelepathyList"]!,
                            //   ),
                            // if (messageSwitch == true)
                            //   NewSentTelepathyBoxes(
                            //       sentTelepathies:
                            //           telepathyInfo["sentTelepathyList"]!)
                          ],
                        ),
                      ]),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  color: Colors.amber,
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                          color: Color(0xff72D4A5),
                          fontFamily: "neodgm",
                          fontSize: 20,
                        ),
                        backgroundColor: Color(0xff72D4A5),
                        minimumSize: Size(10, 10),
                        maximumSize: Size(30, 40)),
                    onPressed: routeToWriteMessagingScreen,
                    child: Text(
                      "텔레파시 보내기",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//보낸 메세지들

//받은 메세지들

//메시지 박스 위젯
class NewMessageContainer extends StatelessWidget {
  final text;
  final phoneNumber;
  final connected;
  final DataType type;
  final sentTime;
  const NewMessageContainer({
    super.key,
    required this.text,
    required this.phoneNumber,
    required this.type,
    required this.sentTime,
    this.connected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: connected ? Color(0xff72D4A5) : Color(0xff2F3E48),
          width: 5,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[900],
      ),
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text(
                        type == DataType.received ? "미지의 행성 B" : "$phoneNumber",
                        style: TextStyle(
                            fontFamily: "neodgm",
                            color: connected
                                ? Color(0xff72D4A5)
                                : Color(0xff2F3E48),
                            fontSize: 14),
                      ),
                    ),
                    Text(
                      // "${DateFormat('yyyy-MM-dd–kk:mm').format(DateTime.fromMillisecondsSinceEpoch(sentTime))}",
                      "",
                      style: TextStyle(
                          fontFamily: "neodgm",
                          color:
                              connected ? Color(0xff72D4A5) : Color(0xff2F3E48),
                          fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  type == DataType.sent ? "교신대기 중인 텔레파시입니다." : "$text",
                  style: TextStyle(
                      fontFamily: "neodgm",
                      color: connected ? Color(0xff72D4A5) : Color(0xff2F3E48),
                      fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                )
              ],
            ),
          ),
          //오른쪽 빨간색 표시등
          if (connected == true)
            Container(height: 20, width: 8, color: Color(0xffEF366D))
        ],
      ),
    );
  }
}

//TODO

class NewSentTelepathyBoxes extends ConsumerWidget {
  final List sentTelepathies;
  const NewSentTelepathyBoxes({
    super.key,
    required this.sentTelepathies,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("sentTelepathies $sentTelepathies");

    return Column(
      children: [
        for (var sentTelepathy in sentTelepathies)
          NewMessageContainer(
            text: sentTelepathy["text"],
            phoneNumber: sentTelepathy["targetPhoneNum"],
            connected: true,
            type: DataType.sent,
            sentTime: sentTelepathy["sentTime"],
          )
      ],
    );
  }
}

class NewReceivedTelepathyBoxes extends ConsumerWidget {
  final List receivedTelepathies;
  const NewReceivedTelepathyBoxes({
    super.key,
    required this.receivedTelepathies,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List finalTelepathyResult = [];
    // 연결이 된 것을 찾는 로직
    print("receivedTelepathies $receivedTelepathies");
    return Column(
      children: [
        for (var recievedTelepathy in receivedTelepathies)
          NewMessageContainer(
            text: recievedTelepathy["text"],
            phoneNumber: recievedTelepathy["senderPhoneNum"],
            connected: true,
            type: DataType.received,
            sentTime: recievedTelepathy["sentTime"],
          )
      ],
    );
  }
}


//아 ㄴ
