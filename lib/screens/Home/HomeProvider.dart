import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

const MY_PHONE_NUM = "01053618962";

final firestore = FirebaseFirestore.instance;

final telepathyInfoProvider =
    StateNotifierProvider<TelepathyInfoNotifier, Map>((ref) {
  return TelepathyInfoNotifier();
});

class TelepathyInfoNotifier extends StateNotifier<Map> {
  TelepathyInfoNotifier()
      : super({"sentTelepathy": [], "receivedTelepathy": []}) {
    initializeTelepathyInfo();
    //constructor body 안에 함수를 넣음으로서 인스턴스 생성될 때 바로 실행이 되도록 한다.
  }

  void initializeTelepathyInfo() async {
    final List sentTelepathy = await getMySentTelepathyList();
    final List receivedTelepathy = await getMyReceivedTelepathyList();
    final Map initResult = {
      "sentTelepathy": sentTelepathy,
      "receivedTelepathy": receivedTelepathy
    };
    print("initResult $initResult");
    state = initResult;
  }
}

Future<List> getSuccessfulTelepathy() async {
  //getMyReceivedMessage & getMySentMessageList 가 끝난 후에, 두 개의 캐싱된 값을 비교해서 세팅하는게 좋을 듯
  //위의 두 함수도 한번만 실행되게 하는게 최 우선일 듯 함.
  return [];
}

Future<List> getMyReceivedTelepathyList() async {
  final List myReceivedTelepathyList = [];

  QuerySnapshot querySnapshot = await firestore
      .collection('messageData')
      .doc(MY_PHONE_NUM)
      .collection("receivedMessage")
      .get();

  querySnapshot.docs.forEach((doc) {
    myReceivedTelepathyList.add({'${doc["targetPhoneNum"]}': doc["body"]});
    // mySentMessageMap['${doc["targetPhoneNum"]}'] = doc["body"];
  });
  return myReceivedTelepathyList;
}

// Future<List> getMySentMessageList() async {
//   final List mySentMessageList = [];
//   QuerySnapshot result = await firestore
//       .collection('messageData')
//       .doc(MY_PHONE_NUM)
//       .collection("sentMessage")
//       .get();
//   result.docs.forEach((doc) {
//     mySentMessageList.add(doc["body"]);
//   });

//   print("사이즈 ${mySentMessageList}");
//   return mySentMessageList;
// }

Future<List> getMySentTelepathyList() async {
  final List mySentTelepathyList = [];

  QuerySnapshot querySnapshot = await firestore
      .collection('messageData')
      .doc(MY_PHONE_NUM)
      .collection("sentMessage")
      .get();

  // Query query = await firestore
  //     .collection('messageData')
  //     .doc(MY_PHONE_NUM)
  //     .collection("sentMessage");
  // QuerySnapshot result =
  //     await query.where("targetPhoneNum", isEqualTo: '01099999999').get();
  // if (querySnapshot.exists() != true) {
  //   print("querySnapshot has no data");
  //   return;
  // }

  List<QueryDocumentSnapshot> dataExample = querySnapshot.docs;

  querySnapshot.docs.forEach((doc) {
    mySentTelepathyList.add({'${doc["targetPhoneNum"]}': doc["body"]});
    // mySentMessageMap['${doc["targetPhoneNum"]}'] = doc["body"];
  });
  print("mySentMessageList $mySentTelepathyList");
  // print("querySnapshot.where. ${result}");
  // Map<String, dynamic> converted = jsonDecode(jsonEncode(result.data()));
  // String messageBody = converted['body'];
  // print("mySentMessageList $result");

  return mySentTelepathyList;
}

/* 
  Firebase Theory

  // ::: Collection Reference :::
  //get()을 통해 QuerySnapshot을 얻는다
  //add() new document(docs)를 추가
  //doc() : DocumentReference를 return

  //??? doc id를 설정하면서 만들어주는 방법은 뭐지??

  // ::: Document Reference :::
  // set(data): data 갱신
  // update(data) : data 갱신 . set 과 다른점은 document가 없으면 에러가 남. set은 그리고 있으면 덮어씀.
  // get() => DocumentSnapshot return 해줌.
  // snapshot() => stream을 return 해줌

  // :::  Document Snapshot :::
  // document Reference로부터 document snapshot 받기
  // ** data() => 실제 data를 가져올 수 있음 **
  // documentSnapshot.exists => 데이터가 null인지 아닌지 판별 가능 -> 있을 때 return
  
  // ::: Query
  // CollectionReference로 부터 시작하는 것은 마찬가지임 
  // get() => QuerySnapshot 리턴함 
  // snapshot() => stream QuerySnapshot 을 리턴함  

  */