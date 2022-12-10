import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:telepathy_flutter/screens/Home/WritingMessageScreen.dart';
import 'package:telepathy_flutter/screens/Intro/Intro.dart';
import 'package:telepathy_flutter/screens/LoginScreen.dart';
import 'firebase_options.dart';
import 'package:telepathy_flutter/keys.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";

import 'screens/Home/HomeScreen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  /* 카카오 init 로직 */
  KakaoSdk.init(nativeAppKey: KAKAO_APP_KEY);

  /* Firebase init 로직 */

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  var initialzationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  var initialzationSettingsIOS = DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid, iOS: initialzationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  final token = await FirebaseMessaging.instance.getToken();

  print("token : ${token ?? 'token NULL!'}");

  /* 맨 처음 초기화 시켜주기  */

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) {
      return Container(
        child: Text("errer"),
      );
    },
    routes: [
      GoRoute(
          path: "/",
          builder: (_, state) {
            return LoginScreen();
          },
          routes: [
            GoRoute(
              path: "intro",
              name: "intro",
              builder: (_, state) => IntroScreen(),
            )
          ]),
      GoRoute(
        path: "/homeScreen",
        builder: (_, state) => HomeScreen(),
        routes: [
          GoRoute(
              path: "writeMessage",
              name: "writeMessage",
              builder: (_, state) => WritingMessageScreen())
        ],
      )
      // GoRoute(path: "/Intro", builder: (_, state) => IntroScreen()),
      // GoRoute(path: "/Home", builder: (_, state) => HomeScreen())
    ],
  );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      //라우트 정보전달: 여기에 이렇게 해놓으면, GoRoute만 신경쓰면 된다
      routeInformationProvider: _router.routeInformationProvider,
      //URI String을 상태 및 Go router에서 사용할 수 있는 형태로 변환해주는 함수
      routeInformationParser: _router.routeInformationParser,
      // 위에서 변경된 값으로 실제 어떤 라우트를 보여줄지 정하는 함수
      routerDelegate: _router.routerDelegate,
    );
  }
}
