import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telepathy_flutter/screens/Home/WritingMessageScreen.dart';

final firestore = FirebaseFirestore.instance;

class MailBoxScreen extends StatefulWidget {
  final telepathyInfo;
  const MailBoxScreen({super.key, required this.telepathyInfo});

  @override
  State<MailBoxScreen> createState() => _MailBoxScreenState();
}

class _MailBoxScreenState extends State<MailBoxScreen> {
  bool messageSwitch = false;
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
    if (widget.telepathyInfo == {}) {
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
                flex: 1,
                child: Column(
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
                        bottom: 10,
                      ),
                      child: Container(
                        color: Colors.grey,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),

              //BODY
              Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ConnectedTelepathyBoxes(
                        sentTelepathies: widget.telepathyInfo["sentTelepathy"],
                        receivedTelepathies:
                            widget.telepathyInfo["receivedTelepathy"],
                      ),
                      if (messageSwitch == true)
                        SentTelepathyBoxes(
                            sentTelepathies:
                                widget.telepathyInfo["sentTelepathy"]),
                      if (messageSwitch == false)
                        //  텍스트 필드. 텍스트필드에 controller를 등록하여 리스너를 통한 핸들링
                        ReceivedTelepathyBoxes(
                          receivedTelepathies:
                              widget.telepathyInfo["receivedTelepathy"],
                        ),
                    ],
                  ),
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

class SentTelepathyBoxes extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
    required this.connected,
  });
  final text;
  final phoneNumber;
  final connected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: connected ? Color(0xffF0E455) : Color(0xff72D4A5),
          width: 5,
        ),
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
              "$phoneNumber",
              style: TextStyle(
                  fontFamily: "neodgm", color: Color(0xff72D4A5), fontSize: 14),
            ),
            Text(
              "$text",
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
