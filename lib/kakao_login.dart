import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:telepathy_flutter/social_login.dart';

class KakaoLogin implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        try {
          await UserApi.instance.loginWithKakaoTalk();
          return true;
        } catch (e) {
          print("errer" + e.toString());
          return false;
        }
      } else {
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print("카카오 계정으로 로그인 성공 ${token.accessToken}");
          return true;
        } catch (e) {
          print("카카오 계정 로그인 실패 ${e}");
          return false;
        }
      }
    } catch (e) {
      print("error2" + e.toString());
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      print("로그아웃 완료");
      return true;
    } catch (e) {
      return false;
    }
  }
}
