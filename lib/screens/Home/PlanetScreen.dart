import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telepathy_flutter/screens/Home/SettingScreen.dart';
import 'HomeProvider.dart';
import 'MailBoxScreen.dart';

class PlanetScreen extends ConsumerWidget {
  const PlanetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telepathyInfos = ref.watch(telepathyInfoProvider);

    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Container(
              alignment: Alignment(0, -0.5),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/planetScreen.png'),
                  fit: BoxFit.cover,
                ),
              ),
              // child: Image.asset(
              //   'assets/planetScreen.png',
              //   width: MediaQuery.of(context).size.width,
              //   height: MediaQuery.of(context).size.height,
              // ),
            ),
          ),
        ),
        Positioned(
            width: MediaQuery.of(context).size.width,
            top: MediaQuery.of(context).size.height * 0.5,
            right: 100,
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Image.asset('assets/images/appicon.png', scale: 2.5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MailBoxScreen(
                                    telepathyInfo: telepathyInfos)));
                      },
                      child: SizedBox(
                        height: 130,
                        width: 130,
                        child: Container(
                            color: const Color(0xFF0E3311).withOpacity(0)),
                      ),
                    ),
                  ]),
            )),
        Positioned(
            width: MediaQuery.of(context).size.width,
            top: MediaQuery.of(context).size.height * 0.65,
            left: 140,
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Image.asset('assets/images/appicon.png', scale: 2.5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingScreen()));
                      },
                      child: SizedBox(
                        height: 110,
                        width: 110,
                        child: Container(
                            color: const Color(0xFF0E3311).withOpacity(0)),
                      ),
                    ),
                  ]),
            ))
      ],
    );
  }
}
