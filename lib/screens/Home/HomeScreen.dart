import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telepathy_flutter/kakao_login.dart';
import 'package:telepathy_flutter/main_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final myController = TextEditingController();

  void initState() {
    super.initState();
    myController.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    print("Second text field: ${myController.text}");
  }

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
          ElevatedButton(onPressed: () {}, child: Text("암거니"))
        ]),
      ),
    );
  }
}
