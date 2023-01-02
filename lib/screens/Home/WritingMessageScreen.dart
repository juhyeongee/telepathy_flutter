import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:telepathy_flutter/global.dart' as globals;

// const MY_PHONE_NUM = "01053618962";

class WritingMessageScreen extends StatefulWidget {
  const WritingMessageScreen({super.key});

  @override
  State<WritingMessageScreen> createState() => _WritingMessageScreenState();
}

class _WritingMessageScreenState extends State<WritingMessageScreen> {
  final _storage = const FlutterSecureStorage();
  final firestore = FirebaseFirestore.instance;

  final messageTextController = TextEditingController();
  final phoneNumberTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    messageTextController.dispose();
    phoneNumberTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* 
     :::  Modal dialogs functions ::: 
    */
    Future<dynamic> showCheckingPhoneNumDialog({
      required BuildContext context,
      required text,
    }) {
      return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          titleTextStyle: const TextStyle(
            color: Color(0xff72D4A5),
            fontFamily: "neodgm",
            fontSize: 22,
          ),
          contentTextStyle: const TextStyle(
            color: Color(0xff72D4A5),
            fontFamily: "neodgm",
            fontSize: 18,
          ),
          backgroundColor: Color(0xff262630),
          title: Text('🚧 문제가 발생했어요'),
          content: Text(text),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      color: Color(0xff72D4A5),
                      fontFamily: "neodgm",
                      fontSize: 20,
                    ),
                    backgroundColor: Color(0xff72D4A5),
                    minimumSize: Size(40, 50)),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('확인')),
          ],
        ),
      );
    }

    Future<dynamic> showCheckingTextDialog({
      required BuildContext context,
      required text,
    }) {
      return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          titleTextStyle: const TextStyle(
            color: Color(0xff72D4A5),
            fontFamily: "neodgm",
            fontSize: 22,
          ),
          contentTextStyle: const TextStyle(
            color: Color(0xff72D4A5),
            fontFamily: "neodgm",
            fontSize: 18,
          ),
          backgroundColor: const Color(0xff262630),
          title: const Text('🚧 잠깐!'),
          content: Text(text),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      color: Color(0xff72D4A5),
                      fontFamily: "neodgm",
                      fontSize: 20,
                    ),
                    backgroundColor: const Color(0xff72D4A5),
                    minimumSize: const Size(40, 50)),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인')),
          ],
        ),
      );
    }

    Future<dynamic> showTelepathyConfirmSendingDialog({
      required BuildContext context,
    }) {
      return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          titleTextStyle: const TextStyle(
            color: Color(0xff72D4A5),
            fontFamily: "neodgm",
            fontSize: 22,
          ),
          contentTextStyle: const TextStyle(
            color: Color(0xff72D4A5),
            fontFamily: "neodgm",
            fontSize: 18,
          ),
          backgroundColor: const Color(0xff262630),
          title: Text('텔레파시를 전송합니다🚀'),
          content: Text("텔레파시 배터리가 1개 차감됩니다."),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      color: Color(0xff72D4A5),
                      fontFamily: "neodgm",
                      fontSize: 20,
                    ),
                    backgroundColor: const Color(0xff72D4A5),
                    minimumSize: const Size(40, 50)),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('보내기')),
          ],
        ),
      );
    }

    /* 
     :::  secure-storage dialogs functions ::: 
    */

    Future<void> readTempSavedTelepathy() async {
      String? tempSavedTelepathy =
          await _storage.read(key: "tempSavedTelepathy");
      if (tempSavedTelepathy == null) {
        print("엇습니다0");
        return;
      } else {
        print("tempSavedTelepathy $tempSavedTelepathy");
      }

      Map decodedValue = jsonDecode(tempSavedTelepathy);
      print("decodedValue $decodedValue");
      print(decodedValue.runtimeType);

      var phoneNumber;
      var text;
      decodedValue.forEach((key, value) {
        phoneNumber = key;
        text = value;
      });
      // readTempSavedTelepathy();
      messageTextController.value = TextEditingValue(
        text: text,
        selection: TextSelection.fromPosition(
          TextPosition(offset: text.length),
        ),
      );
      phoneNumberTextController.value = TextEditingValue(
        text: phoneNumber,
        selection: TextSelection.fromPosition(
          TextPosition(offset: phoneNumber.length),
        ),
      );
    }

    Future<void> addTempSavedTelepathy({
      required targetNumber,
      required text,
    }) async {
      final encodedValue = jsonEncode({"$targetNumber": "$text"});
      await _storage.write(key: "tempSavedTelepathy", value: encodedValue);
      print("저장 완료");
      String? tempSavedText = await _storage.read(key: "tempSavedTelepathy");
    }

    //같은 doc으로 보내면, 초기화가 됨
    void updateMyNewMessage() async {
      if (phoneNumberTextController.text.length != 11) {
        showCheckingPhoneNumDialog(context: context, text: '전화번호 입력창을 확인해주세요!');
        return;
      }
      // if (phoneNumberTextController.text)
      if (messageTextController.text.length == 0) {
        showCheckingTextDialog(context: context, text: "텔레파시 입력창을 확인해주세요!");
        return;
      }

      if (phoneNumberTextController.text.substring(0, 3) != "010") {
        showCheckingPhoneNumDialog(context: context, text: "앞에 010을 붙여주세요!");
        return;
      }

      if (phoneNumberTextController.text == globals.MY_PHONE_NUM) {
        showCheckingPhoneNumDialog(context: context, text: "본인에게 보낼 수 없어요!");
        return;
      }

      try {
        await firestore
            .collection("messageData")
            .doc(globals.MY_PHONE_NUM)
            .collection("sentMessage")
            .doc(phoneNumberTextController.text)
            .set({
          "body": messageTextController.text,
          "targetPhoneNum": phoneNumberTextController.text,
          "sentTime": DateTime.now().millisecondsSinceEpoch
        });
        Fluttertoast.showToast(
            msg: "메세지가 전송되었습니다.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: const Color(0xff72D4A5),
            fontSize: 18.0);
        Navigator.pop(context);
      } catch (err) {
        print("updateMyNewMessage err: $err");
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xff1E1831),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
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
                const Text(
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
                    decoration: const InputDecoration(
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
                    textStyle: const TextStyle(
                      color: Color(0xff72D4A5),
                      fontFamily: "neodgm",
                      fontSize: 20,
                    ),
                    backgroundColor: const Color(0xff30453B),
                    minimumSize: const Size(40, 50)),
                onPressed: () {
                  addTempSavedTelepathy(
                    targetNumber: phoneNumberTextController.text,
                    text: messageTextController.text,
                  );
                },
                child: const Text(
                  "임시저장",
                  style: TextStyle(color: Color(0xff72D4A5)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      color: Color(0xff72D4A5),
                      fontFamily: "neodgm",
                      fontSize: 20,
                    ),
                    backgroundColor: const Color(0xff72D4A5),
                    minimumSize: const Size(40, 50)),
                onPressed: () async {
                  await showTelepathyConfirmSendingDialog(context: context);
                  updateMyNewMessage();
                },
                child: const Text(
                  "메세지 보내기",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      color: Color(0xff72D4A5),
                      fontFamily: "neodgm",
                      fontSize: 20,
                    ),
                    backgroundColor: const Color(0xff72D4A5),
                    minimumSize: const Size(40, 50)),
                onPressed: readTempSavedTelepathy,
                child: const Text(
                  "임시저장 불러와보기 ",
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
