import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telepathy_flutter/screens/Home/WritingMessageScreen.dart';

import 'HomeProvider.dart';

final firestore = FirebaseFirestore.instance;

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
    final telepathyInfo = ref.watch(telepathyInfoProvider);

    Future<void> refresh() async {
      ref.read(telepathyInfoProvider.notifier).initializeTelepathyInfo();
      print("initializeTelepathyInfo read 완료");
      setState(() {});
    }

    if (telepathyInfo == {}) {
      return CircularProgressIndicator();
    }

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
                            // if (messageSwitch == true)
                            //   SentTelepathyBoxes(
                            //       sentTelepathies:
                            //           telepathyInfo["sentTelepathy"]),
                            // if (messageSwitch == false)
                            //   //  텍스트 필드. 텍스트필드에 controller를 등록하여 리스너를 통한 핸들링
                            //   ReceivedTelepathyBoxes(
                            //     receivedTelepathies:
                            //         telepathyInfo["receivedTelepathy"],
                            //   ),
                            NewSentTelepathyBoxes(
                              sentTelepathies: telepathyInfo["sentTelepathy"],
                              receivedTelepathies:
                                  telepathyInfo["receivedTelepathy"],
                            )
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

//연결된 텔레파시들

class ConnectedTelepathyBoxes extends StatelessWidget {
  final List sentTelepathies;
  final List receivedTelepathies;

  ConnectedTelepathyBoxes({
    super.key,
    required this.sentTelepathies,
    required this.receivedTelepathies,
  });

  List searchConnectNumber() {
    List sentTelepathyNumberList = [];
    List result = [];
    for (var sentTelepathy in sentTelepathies) {
      sentTelepathy.keys.forEach((phoneNumber) {
        sentTelepathyNumberList.add(phoneNumber);
      });
      // print("각각 sentTelepathy $sentTelepathy");
    }

    for (var receivedTelepathy in receivedTelepathies) {
      // print("각각 receivedTelepathy $receivedTelepathy");
      receivedTelepathy.forEach((phoneNumber, text) {
        if (sentTelepathyNumberList.contains(phoneNumber) == true) {
          result.add({"$phoneNumber": '$text'});
        }
      });
    }
    // print("sentTelepathyNumberList $sentTelepathyNumberList");
    return result;
  }

  MessageContainer makeMessageContainer(sortedResultTelepathy) {
    String phoneNumber = "";
    String text = "";

    sortedResultTelepathy.forEach((k, v) {
      phoneNumber = k;
      text = v;
    });
    return MessageContainer(
      text: text,
      phoneNumber: phoneNumber,
      connected: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List sortedResultTelepathies = searchConnectNumber();

    return Column(
      children: [
        for (var sortedResultTelepathy in sortedResultTelepathies)
          makeMessageContainer(sortedResultTelepathy)
      ],
    );
  }
}

//보낸 메세지들

class SentTelepathyBoxes extends ConsumerWidget {
  final List sentTelepathies;
  const SentTelepathyBoxes({super.key, required this.sentTelepathies});

  MessageContainer makeMessageContainer(sentTelepathy) {
    String phoneNumber = "";
    String text = "";

    sentTelepathy.forEach((k, v) {
      phoneNumber = k;
      text = v;
    });
    return MessageContainer(
      text: text,
      phoneNumber: phoneNumber,
      connected: false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        for (var sentTelepathy in sentTelepathies)
          makeMessageContainer(sentTelepathy)
      ],
    );
  }
}

//받은 메세지들

class ReceivedTelepathyBoxes extends StatelessWidget {
  final List receivedTelepathies;
  const ReceivedTelepathyBoxes({super.key, required this.receivedTelepathies});

  MessageContainer makeMessageContainer(receivedTelepathy) {
    String phoneNumber = "";
    String text = "";

    receivedTelepathy.forEach((k, v) {
      phoneNumber = k;
      text = v;
    });
    return MessageContainer(
      text: text,
      phoneNumber: phoneNumber,
      connected: false,
      received: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var receivedTelepathy in receivedTelepathies)
          makeMessageContainer(receivedTelepathy)
      ],
    );
  }
}

//메시지 박스 위젯
class MessageContainer extends StatelessWidget {
  const MessageContainer({
    super.key,
    required this.text,
    required this.phoneNumber,
    this.connected = false,
    this.received = false,
  });
  final text;
  final phoneNumber;
  final connected;
  final received;

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
                Text(
                  received ? "미지의 행성 B" : "$phoneNumber",
                  style: TextStyle(
                      fontFamily: "neodgm",
                      color: connected ? Color(0xff72D4A5) : Color(0xff2F3E48),
                      fontSize: 14),
                ),
                Text(
                  received ? "교신대기 중인 텔레파시입니다." : "$text",
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

//메시지 박스 위젯
class NewMessageContainer extends StatelessWidget {
  const NewMessageContainer({
    super.key,
    required this.text,
    required this.phoneNumber,
    required this.type,
    this.connected = false,
  });
  final text;
  final phoneNumber;
  final connected;
  final type;

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
                Text(
                  type == "received" ? "미지의 행성 B" : "$phoneNumber",
                  style: TextStyle(
                      fontFamily: "neodgm",
                      color: connected ? Color(0xff72D4A5) : Color(0xff2F3E48),
                      fontSize: 14),
                ),
                Text(
                  type == "received" ? "교신대기 중인 텔레파시입니다." : "$text",
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

class NewSentTelepathyBoxes extends ConsumerWidget {
  final List sentTelepathies;
  final List receivedTelepathies;
  const NewSentTelepathyBoxes({
    super.key,
    required this.sentTelepathies,
    required this.receivedTelepathies,
  });

  // print("sentTelepathyNumberList $sentTelepathyNumberList");

  NewMessageContainer makeMessageContainer({
    required sentTelepathy,
  }) {
    String phoneNumber = "";
    String text = "";
    bool connected = false;

    sentTelepathy.forEach((k, v) {
      phoneNumber = k;
      text = v["text"];
      connected = v['connected'];
    });

    return NewMessageContainer(
      text: text,
      phoneNumber: phoneNumber,
      connected: connected,
      type: "sent",
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List receivedTelepathyNumberList = [];
    List finalTelepathyResult = [];
    // 연결이 된 것을 찾는 로직
    for (var receivedTelepathy in receivedTelepathies) {
      receivedTelepathy.keys.forEach((phoneNumber) {
        receivedTelepathyNumberList.add(phoneNumber);
      });
    }
    for (var sentTelepathy in sentTelepathies) {
      sentTelepathy.forEach((phoneNumber, text) {
        if (receivedTelepathyNumberList.contains(phoneNumber) == true) {
          finalTelepathyResult.add({
            "$phoneNumber": {"connected": true, "text": text}
          });
        } else {
          finalTelepathyResult.add({
            "$phoneNumber": {"connected": false, "text": text}
          });
        }
      });
    }

    return Column(
      children: [
        for (var sentTelepathy in finalTelepathyResult)
          makeMessageContainer(sentTelepathy: sentTelepathy)
      ],
    );
  }
}

class NewReceivedTelepathyBoxes extends StatelessWidget {
  final List receivedTelepathies;
  const NewReceivedTelepathyBoxes({
    super.key,
    required this.receivedTelepathies,
  });

  NewMessageContainer makeMessageContainer(receivedTelepathy) {
    String phoneNumber = "";
    String text = "";

    receivedTelepathy.forEach((k, v) {
      phoneNumber = k;
      text = v;
    });
    return NewMessageContainer(
      text: text,
      phoneNumber: phoneNumber,
      connected: false,
      type: "received",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var receivedTelepathy in receivedTelepathies)
          makeMessageContainer(receivedTelepathy)
      ],
    );
  }
}
