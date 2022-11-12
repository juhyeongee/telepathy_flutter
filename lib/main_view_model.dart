import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:telepathy_flutter/social_login.dart';

class MainViewModel {
  final SocialLogin _socialLogin;
  bool isLoggedIn = false;
  User? user;

  MainViewModel(this._socialLogin);

  Future login() async {
    isLoggedIn = await _socialLogin.login();
    if (isLoggedIn) {
      print("isLoggedIn" + isLoggedIn.toString());
      print(UserApi.instance.me());

      user = await UserApi.instance.me();
    }
  }

  Future logout() async {
    await _socialLogin.logout();
    isLoggedIn = false;
    user = null;
  }
}
