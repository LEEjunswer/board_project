


  import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

  const accessTokenKey = 'accessToken';
  const refreshTokenKey = 'refreshToken';

  /*이름담는 용도*/
  const name = 'name';

  /*이메일 담는 용도*/
  const username = 'username';

class UserBox {
    final box = GetStorage();
    final FlutterSecureStorage secure = const FlutterSecureStorage();
    init() async {
      await GetStorage.init();
    }

    void setName(String na) {
      box.write(name, na);
    }

    String getName() {
        return box.read(name) ?? '';
    }

    void setUsername(String un){
      box.write(username, un);
    }
    String getUsername(){
      return box.read(username) ?? '';
    }


    Future<void> setAccessToken(String token) async {
      await secure.write(key: accessTokenKey, value: token);
    }

    Future<String> getAccessToken() async {
      return await secure.read(key: accessTokenKey) ?? '';
    }

    Future<void> setRefreshToken(String token) async {
      await secure.write(key: refreshTokenKey, value: token);
    }

    Future<String> getRefreshToken() async {
      return await secure.read(key: refreshTokenKey) ?? '';
    }

    /*로그아웃 또는 회원 탈퇴시  전부 제거*/
    Future<void> clearTokens() async {
      box.erase();
      await secure.deleteAll();
    }
}
