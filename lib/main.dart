import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:telepathy_flutter/screens/LoginScreen.dart';
import 'package:telepathy_flutter/keys.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";

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

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // final _router = GoRouter(
  //   initialLocation: '/',
  //   errorBuilder: (context, state) {
  //     return Container(
  //       child: Text("errer"),
  //     );
  //   },
  //   routes: [
  //     GoRoute(
  //         path: "/",
  //         builder: (_, state) {
  //           return const LoginScreen();
  //         },
  //         routes: [
  //           GoRoute(
  //             path: "intro",
  //             name: "intro",
  //             builder: (_, state) => const IntroScreen(),
  //           ),
  //           GoRoute(
  //             path: "planetScreen",
  //             builder: (_, state) => const PlanetScreen(),
  //             routes: [
  //               GoRoute(
  //                   path: "writeMessage",
  //                   name: "writeMessage",
  //                   builder: (_, state) => const MailBoxScreen(
  //                         telepathyInfo: telepathyInfos,
  //                       )),
  //               GoRoute(
  //                   path: "settings",
  //                   name: "settings",
  //                   builder: (_, state) => const SettingScreen())
  //             ],
  //           )
  //         ]),

  // GoRoute(path: "/Intro", builder: (_, state) => IntroScreen()),
  // GoRoute(path: "/Home", builder: (_, state) => HomeScreen())
  //   ],
  // );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Telepathy Flutter', home: LoginScreen());
    // return MaterialApp.router(
    //   //라우트 정보전달: 여기에 이렇게 해놓으면, GoRoute만 신경쓰면 된다
    //   routeInformationProvider: _router.routeInformationProvider,
    //   //URI String을 상태 및 Go router에서 사용할 수 있는 형태로 변환해주는 함수
    //   routeInformationParser: _router.routeInformationParser,
    //   // 위에서 변경된 값으로 실제 어떤 라우트를 보여줄지 정하는 함수
    //   routerDelegate: _router.routerDelegate,
    // );
  }
}
