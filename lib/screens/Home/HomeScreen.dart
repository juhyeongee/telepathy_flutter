import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telepathy_flutter/kakao_login.dart';
import 'package:telepathy_flutter/main_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final myController = TextEditingController();
  final firestore = FirebaseFirestore.instance;

  void initState() {
    super.initState();
    myController.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    print("Second text field: ${myController.text}");
  }

  getMyMessage() async {
    var result =
        await firestore.collection('messageData').doc("01053618962").get();
    return result;
  }

  setMyNewMessage() {
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

// updateMyNewMessage() {
//     firestore.collection("messageData").doc("01053618962").update(
//       {"to": "01033333333", "from": "01077777777", "message": "update Method"},
//     );
//   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeScreen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          //  텍스트 필드. 텍스트필드에 controller를 등록하여 리스너를 통한 핸들링
          SizedBox(
            height: 400,
            child: TextField(
              style: TextStyle(fontSize: 20),
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
              onPressed: setMyNewMessage, child: Text("SendMessage")),
          ElevatedButton(onPressed: getMyMessage, child: Text("getMyMessage")),
          ElevatedButton(
              onPressed: updateMyNewMessage, child: Text("updateMessage"))
        ]),
      ),
    );
  }
}
