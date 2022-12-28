import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

final firestore = FirebaseFirestore.instance;

final telepathyInfoProvider =
    StateNotifierProvider<telepathyInfoNotifier, Map>((ref) {
  return telepathyInfoNotifier();
});

class telepathyInfoNotifier extends StateNotifier<Map> {
  telepathyInfoNotifier()
      : super({"sentTelepathy": [], "receivedTelepathy": []}) {
    initializeTelepathyInfo();
    //constructor body 안에 함수를 넣음으로서 인스턴스 생성될 때 바로 실행이 되도록 한다.
  }

  void initializeTelepathyInfo() async {
    final List sentTelepathy = await getMySentMessageList();
    final List receivedTelepathy = await getMyReceivedMessageList();
    final Map initResult = {
      "sentTelepathy": sentTelepathy,
      "receivedTelepathy": receivedTelepathy
    };
    state = initResult;
  }
}

Future<List> getSuccessfulTelepathy() async {
  //getMyReceivedMessage & getMySentMessageList 가 끝난 후에, 두 개의 캐싱된 값을 비교해서 세팅하는게 좋을 듯
  //위의 두 함수도 한번만 실행되게 하는게 최 우선일 듯 함.
  return [];
}

Future<List> getMyReceivedMessageList() async {
  final List myReceivedMessageList = [];

  QuerySnapshot messageBodyResult = await firestore
      .collection('messageData')
      .doc("01053618962")
      .collection("receivedMessage")
      .get();
  messageBodyResult.docs.forEach((doc) {
    myReceivedMessageList.add(doc["body"]);
  });
  print("사이즈 ${myReceivedMessageList}");
  return myReceivedMessageList;
}

Future<List> getMySentMessageList() async {
  final List mySentMessageList = [];
  QuerySnapshot result = await firestore
      .collection('messageData')
      .doc("01053618962")
      .collection("sentMessage")
      .get();
  result.docs.forEach((doc) {
    mySentMessageList.add(doc["body"]);
  });

  print("사이즈 ${mySentMessageList}");
  return mySentMessageList;
}
