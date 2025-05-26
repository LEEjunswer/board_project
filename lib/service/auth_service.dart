import 'dart:convert';

import 'package:board_project/globals.dart';
import 'package:board_project/models/member.dart';
import 'package:board_project/storage/local_stroage.dart';
import 'package:http/http.dart' as http;
class AuthService{
  static const String authIp = "$ip/auth";


   Future<bool> signup(Member member) async{
    var url = Uri.parse("$authIp/signup");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": member.username,
        "name": member.name,
        "password": member.password,
        "confirmPassword": member.confirmPassword,
      }),
    );
    print(" 상태 확인 : ${response.statusCode}");
    print("리스폰스 체크 : ${response.body}");
    if(response.statusCode == 200){
      UserBox().setName(member.name);
      UserBox().setUsername(member.username);
      print("회원가입 완료");
      return true;
    }
    print("회원가입 실패");
    return false;
  }


  Future<bool> signin(Member member) async{
    var url = Uri.parse("$authIp/signin");

    http.Response response;
    response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": member.username,
        "password": member.password,
      }),
    );
    print(" 상태 확인 : ${response.statusCode}");
    print("바디 체크 : ${response.body}");
    print("헤더 체크 : ${response.headers}");

    if(response.statusCode == 200){
      final data = json.decode(response.body);
      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];
      if(accessToken != null && refreshToken != null){
        await UserBox().setRefreshToken(refreshToken);
        await UserBox().setAccessToken(accessToken);
        print("로그인 완료");
        return true;
      }
    }
    print("로그인 실패");
    return false;
  }

  Future<String?> refresh() async{
     var url = Uri.parse("$authIp/refresh");
     final refreshToken =  await UserBox().getRefreshToken();
    http.Response response;
    response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "refreshToken": refreshToken
      }),
    );
    print(" 상태 확인 : ${response.statusCode}");
    print("바디 체크 : ${response.body}");
    print("헤더 체크 : ${response.headers}");

    if(response.statusCode == 200){
      final data = json.decode(response.body);
      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];
      if(accessToken != null && refreshToken != null){
        await UserBox().setRefreshToken(refreshToken);
        await UserBox().setAccessToken(accessToken);
        print(await UserBox().getRefreshToken());
        print("새로운 토큰 재발급 성공");
        return accessToken;
      }
    }
    print("토큰 발급 실패");
    /*여기에 다시 로그인페이지로 넘겨야함*/
    return null;
  }
}